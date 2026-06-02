import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/theme.dart';
import '../../models/message_model.dart';
import '../../services/auth_service.dart';
import '../../services/message_service.dart';
import '../messages/chat_detail_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _messageService = MessageService();
  final _authService = AuthService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'دیروز';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final currentUser = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.messagesTitle),
        elevation: 4,
      ),
      body: currentUser == null
          ? Center(
              child: Text(loc.errorLoadingPosts),
            )
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: loc.hintSearchUsers,
                      prefixIcon: const Icon(Icons.search,
                          color: AppColors.darkGreen),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.darkGreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: AppColors.darkGreen, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                    ),
                  ),
                ),

                // Conversations List - Real-time Stream
                Expanded(
                  child: StreamBuilder<List<ConversationModel>>(
                    stream: _messageService
                        .getUserConversationsStream(currentUser.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                AppColors.darkGreen),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error,
                                  size: 48, color: AppColors.error),
                              const SizedBox(height: 16),
                              Text(loc.errorLoadingPosts),
                            ],
                          ),
                        );
                      }

                      final conversations = snapshot.data ?? [];

                      if (conversations.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_outlined,
                                size: 48,
                                color: AppColors.mediumGray,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'هنوز محادثه‌ای وجود ندارد',
                                style:
                                    TextStyle(color: AppColors.mediumGray),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = conversations[index];
                          final isCurrentUserFirst =
                              currentUser.uid == conversation.userId1;
                          final otherUserName = isCurrentUserFirst
                              ? conversation.userId2Name
                              : conversation.userId1Name;
                          final otherUserPhoto = isCurrentUserFirst
                              ? conversation.userId2Photo
                              : conversation.userId1Photo;

                          return ChatConversationTile(
                            conversation: conversation,
                            otherUserName: otherUserName,
                            otherUserPhoto: otherUserPhoto,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatDetailScreen(
                                        conversation: conversation,
                                      ),
                                ),
                              );
                            },
                            formatTime: _formatTime,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to start new chat (user search/selection)
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}

class ChatConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final String otherUserName;
  final String otherUserPhoto;
  final VoidCallback onTap;
  final String Function(DateTime) formatTime;

  const ChatConversationTile({
    Key? key,
    required this.conversation,
    required this.otherUserName,
    required this.otherUserPhoto,
    required this.onTap,
    required this.formatTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Stack(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.forestGreen,
            ),
            child: otherUserPhoto.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      otherUserPhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person,
                            color: AppColors.white);
                      },
                    ),
                  )
                : const Icon(Icons.person, color: AppColors.white),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        otherUserName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        conversation.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.mediumGray,
            ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatTime(conversation.lastMessageTime),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mediumGray,
                ),
          ),
          const SizedBox(height: 4),
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
