import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/post_service.dart';
import '../../services/user_service.dart';
import '../../models/post_model.dart';
import '../posts/create_post_screen.dart';
import '../posts/comments_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _postService = PostService();
  final _authService = AuthService();
  final _userService = UserService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    ).then((_) {
      // Refresh feed after creating post
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final currentUser = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.feedTitle),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc.hintSearchPosts,
                prefixIcon: const Icon(Icons.search, color: AppColors.darkGreen),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.darkGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.darkGreen, width: 2),
                ),
                filled: true,
                fillColor: AppColors.lightGray,
              ),
            ),
          ),

          // Feed Posts List - Real-time Stream from Following
          Expanded(
            child: StreamBuilder<UserModel?>(
              stream: currentUser != null
                  ? _userService.getUserProfileStream(currentUser.uid)
                  : null,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.darkGreen),
                    ),
                  );
                }

                // Get following list from user profile
                final followingList = userSnapshot.data?.following ?? [];

                return StreamBuilder<List<PostModel>>(
                  stream: followingList.isEmpty
                      ? _postService.getPostsStream(limit: 50)
                      : _postService.getFollowingPostsStream(
                          followingUserIds: followingList,
                          limit: 50,
                        ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.darkGreen),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(loc.errorLoadingPosts),
                      ],
                    ),
                  );
                }

                final posts = snapshot.data ?? [];

                    if (posts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 48,
                              color: AppColors.mediumGray,
                            ),
                            const SizedBox(height: 16),
                            Text(followingList.isEmpty
                                ? 'دنبال‌کنندگانی برای دیدن پست‌های آنها ندارید'
                                : loc.emptyPostsFeed),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final isLiked = post.hasLikedBy(currentUser?.uid ?? '');

                        return FeedPostCard(
                      post: post,
                      isLiked: isLiked,
                      onLikeTap: () async {
                        if (currentUser == null) return;

                        if (isLiked) {
                          await _postService.unlikePost(
                            postId: post.id,
                            userId: currentUser.uid,
                          );
                        } else {
                          await _postService.likePost(
                            postId: post.id,
                            userId: currentUser.uid,
                          );
                        }
                        setState(() {});
                      },
                      onCommentTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(post: post),
                          ),
                        );
                      },
                      onShareTap: () async {
                        await _postService.sharePost(post.id);
                      },
                    );                      },
                    );                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        child: const Icon(Icons.add),
      ),
    );
  }
}


class FeedPostCard extends StatelessWidget {
  final PostModel post;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;

  const FeedPostCard({
    Key? key,
    required this.post,
    required this.isLiked,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
  }) : super(key: key);

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}د پیش';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}س پیش';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}روز پیش';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.forestGreen,
                  ),
                  child: post.profilePhotoUrl.isNotEmpty
                      ? ClipOval(
                    child: Image.network(
                      post.profilePhotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(
                        child: Icon(Icons.person, color: AppColors.white),
                      ),
                    ),
                  )
                      : const Center(
                    child: Icon(Icons.person, color: AppColors.white),
                  ),
                ),
                const SizedBox(width: 12),
                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        post.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                      Text(
                        _formatTime(post.createdAt),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                // Options Menu
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert, color: AppColors.mediumGray),
                ),
              ],
            ),
          ),

          // Post Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              post.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),

          // Post Images
          if (post.mediaUrls.isNotEmpty)
            SizedBox(
              height: 250,
              child: post.mediaUrls.length == 1
                  ? _buildSingleImage(post.mediaUrls[0])
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.mediaUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildSingleImage(post.mediaUrls[index]),
                  );
                },
              ),
            ),

          // Interaction Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Like Button
                Expanded(
                  child: _InteractionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_outline,
                    iconColor: isLiked ? AppColors.error : AppColors.darkGreen,
                    label: '${post.likes}',
                    onTap: onLikeTap,
                  ),
                ),
                const SizedBox(width: 8),
                // Comment Button
                Expanded(
                  child: _InteractionButton(
                    icon: Icons.chat_outline,
                    label: '${post.comments}',
                    onTap: onCommentTap,
                  ),
                ),
                const SizedBox(width: 8),
                // Share Button
                Expanded(
                  child: _InteractionButton(
                    icon: Icons.share_outlined,
                    label: '${post.shares}',
                    onTap: onShareTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleImage(String imageUrl) {
    return Container(
      width: double.infinity,
      color: AppColors.lightGray,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.image, size: 48, color: AppColors.mediumGray),
        ),
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;

  const _InteractionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = AppColors.darkGreen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

