import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/message_model.dart';
import '../../services/auth_service.dart';
import '../../services/message_service.dart';
import '../../services/user_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final ConversationModel conversation;

  const ChatDetailScreen({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _messageService = MessageService();
  final _authService = AuthService();
  final _userService = UserService();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _markMessagesAsRead() async {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      await _messageService.markAllMessagesAsRead(
        conversationId: widget.conversation.id,
        userId: currentUser.uid,
      );
    }
  }

  String _getOtherUserName() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser?.uid == widget.conversation.userId1) {
      return widget.conversation.userId2Name;
    } else {
      return widget.conversation.userId1Name;
    }
  }

  String _getOtherUserPhoto() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser?.uid == widget.conversation.userId1) {
      return widget.conversation.userId2Photo;
    } else {
      return widget.conversation.userId1Photo;
    }
  }

  String _getOtherUserId() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser?.uid == widget.conversation.userId1) {
      return widget.conversation.userId2;
    } else {
      return widget.conversation.userId1;
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isSending = true);

    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Get current user profile
      final userProfile = await _userService.getUserProfile(currentUser.uid);
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      // Get receiver info
      final receiverId = _getOtherUserId();
      final receiverProfile = await _userService.getUserProfile(receiverId);
      if (receiverProfile == null) {
        throw Exception('Receiver profile not found');
      }

      // Send message
      await _messageService.sendMessage(
        senderId: currentUser.uid,
        senderName: userProfile.fullName,
        senderPhotoUrl: userProfile.profilePhotoUrl,
        receiverId: receiverId,
        receiverName: receiverProfile.fullName,
        receiverPhotoUrl: receiverProfile.profilePhotoUrl,
        text: _messageController.text.trim(),
      );

      _messageController.clear();
      setState(() => _isSending = false);
    } catch (e) {
      setState(() => _isSending = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا: $e')),
        );
      }
    }
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
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.getCurrentUser();
    final otherUserName = _getOtherUserName();
    final otherUserPhoto = _getOtherUserPhoto();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
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
                        return const Icon(
                          Icons.person,
                          color: AppColors.white,
                        );
                      },
                    ),
                  )
                  : const Icon(Icons.person, color: AppColors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Text(
                    'فعال',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _messageService.getConversationMessagesStream(
                widget.conversation.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.darkGreen),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          size: 64,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'هنوز پیامی وجود ندارد',
                          style: TextStyle(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUserMessage = message.senderId == currentUser?.uid;

                    return Align(
                      alignment: isCurrentUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: isCurrentUserMessage
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrentUserMessage
                                    ? AppColors.darkGreen
                                    : AppColors.lightGray,
                                borderRadius: BorderRadius.circular(16),
                                border: isCurrentUserMessage
                                    ? null
                                    : Border.all(color: AppColors.mediumGray),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isCurrentUserMessage
                                      ? AppColors.white
                                      : AppColors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(message.createdAt),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.mediumGray,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(color: AppColors.mediumGray),
              ),
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      maxLength: 1000,
                      textDirection: TextDirection.rtl,
                      enabled: !_isSending,
                      decoration: InputDecoration(
                        hintText: 'پیام بنویسید...',
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppColors.darkGreen,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            color: AppColors.darkGreen,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isSending ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isSending
                            ? AppColors.mediumGray
                            : AppColors.darkGreen,
                      ),
                      child: _isSending
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(
                            Icons.send,
                            color: AppColors.white,
                            size: 20,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
