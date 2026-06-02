import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/post_model.dart';
import '../../models/comment_model.dart';
import '../../services/auth_service.dart';
import '../../services/comment_service.dart';
import '../../services/user_service.dart';
import '../../models/app_localizations_stub.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;

  const CommentsScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  final _commentService = CommentService();
  final _authService = AuthService();
  final _userService = UserService();
  AppLocalizations _localizations(BuildContext context) {
    return AppLocalizations.of(context) ?? AppLocalizationsEn();
  }
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'نظر نمی‌تواند خالی باشد');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Get user profile
      final userProfile = await _userService.getUserProfile(currentUser.uid);
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      // Create comment
      await _commentService.createComment(
        postId: widget.post.id,
        uid: currentUser.uid,
        authorName: userProfile.fullName,
        profilePhotoUrl: userProfile.profilePhotoUrl,
        text: _commentController.text.trim(),
      );

      _commentController.clear();
      setState(() => _isSubmitting = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('نظر شما افزوده شد')),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'خطا در ارسال نظر: $e';
      });
    }
  }

  Future<void> _deleteComment(CommentModel comment) async {
    final currentUser = _authService.getCurrentUser();
    if (currentUser?.uid != comment.uid && currentUser?.uid != widget.post.uid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فقط نویسنده می‌تواند نظر را حذف کند')),
      );
      return;
    }

    try {
      await _commentService.deleteComment(
        postId: widget.post.id,
        commentId: comment.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('نظر حذف شد')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا: $e')),
        );
      }
    }
  }

  Future<void> _toggleLikeComment(CommentModel comment) async {
    final currentUser = _authService.getCurrentUser();
    if (currentUser == null) return;

    try {
      if (comment.hasLikedBy(currentUser.uid)) {
        await _commentService.unlikeComment(
          postId: widget.post.id,
          commentId: comment.id,
          userId: currentUser.uid,
        );
      } else {
        await _commentService.likeComment(
          postId: widget.post.id,
          commentId: comment.id,
          userId: currentUser.uid,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا: $e')),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'اکنون';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقیقه';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعت';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} روز';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = _localizations(context);
    final currentUser = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('نظرات'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Comments List
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: _commentService.getPostCommentsStream(
                postId: widget.post.id,
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
                          Icons.comment_outlined,
                          size: 64,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'هنوز نظری وجود ندارد',
                          style: TextStyle(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  );
                }

                final comments = snapshot.data!;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final isCommentOwner = currentUser?.uid == comment.uid;
                    final isPostOwner = currentUser?.uid == widget.post.uid;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.mediumGray),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Comment Header
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.forestGreen,
                                    ),
                                    child: comment.profilePhotoUrl.isNotEmpty
                                        ? ClipOval(
                                          child: Image.network(
                                            comment.profilePhotoUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                color: AppColors.white,
                                              );
                                            },
                                          ),
                                        )
                                        : const Icon(
                                          Icons.person,
                                          color: AppColors.white,
                                        ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.authorName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(comment.createdAt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color: AppColors.mediumGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isCommentOwner || isPostOwner)
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: const Text('حذف'),
                                          onTap: () {
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () => _deleteComment(comment),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Comment Text
                              Text(
                                comment.text,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                              const SizedBox(height: 12),

                              // Comment Actions
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _toggleLikeComment(comment),
                                    child: Row(
                                      children: [
                                        Icon(
                                          comment.hasLikedBy(
                                            currentUser?.uid ?? '',
                                          )
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: comment.hasLikedBy(
                                            currentUser?.uid ?? '',
                                          )
                                              ? AppColors.error
                                              : AppColors.mediumGray,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          comment.likes.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Error Message
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),

          // Comment Input
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
                      controller: _commentController,
                      maxLines: null,
                      maxLength: 500,
                      textDirection: TextDirection.rtl,
                      enabled: !_isSubmitting,
                      decoration: InputDecoration(
                        hintText: 'نظر خود را بنویسید...',
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.darkGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.darkGreen,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isSubmitting ? null : _submitComment,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isSubmitting
                            ? AppColors.mediumGray
                            : AppColors.darkGreen,
                      ),
                      child: _isSubmitting
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
