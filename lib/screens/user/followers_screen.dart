import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'user_profile_screen.dart';

class FollowersScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const FollowersScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final _userService = UserService();
  final _authService = AuthService();
  final _searchController = TextEditingController();
  List<UserModel> _allFollowers = [];
  List<UserModel> _filteredFollowers = [];

  @override
  void initState() {
    super.initState();
    _loadFollowers();
    _searchController.addListener(_filterFollowers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowers() async {
    try {
      final userProfile = await _userService.getUserProfile(widget.userId);
      if (userProfile == null) return;

      // Get all followers for this user
      final followers = await _userService.getFollowersList(widget.userId);

      setState(() {
        _allFollowers = followers;
        _filteredFollowers = followers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا: $e')),
      );
    }
  }

  void _filterFollowers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFollowers = _allFollowers
          .where((user) =>
              user.fullName.toLowerCase().contains(query) ||
              user.farmName.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _toggleFollow(UserModel user) async {
    final currentUser = _authService.getCurrentUser();
    if (currentUser == null) return;

    try {
      final isFollowing = await _userService.isFollowing(
        currentUserId: currentUser.uid,
        targetUserId: user.uid,
      );

      if (isFollowing) {
        await _userService.unfollowUser(
          currentUserId: currentUser.uid,
          targetUserId: user.uid,
        );
      } else {
        await _userService.followUser(
          currentUserId: currentUser.uid,
          targetUserId: user.uid,
        );
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName} - دنبال‌کنندگان'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'جستجو...',
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

          // Followers List
          Expanded(
            child: _filteredFollowers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'دنبال‌کنندگانی وجود ندارد',
                          style:
                              TextStyle(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredFollowers.length,
                    itemBuilder: (context, index) {
                      final follower = _filteredFollowers[index];
                      return FutureBuilder<bool>(
                        future: currentUser != null
                            ? _userService.isFollowing(
                                currentUserId: currentUser.uid,
                                targetUserId: follower.uid,
                              )
                            : Future.value(false),
                        builder: (context, snapshot) {
                          final isFollowing = snapshot.data ?? false;
                          final isOwnProfile =
                              currentUser?.uid == follower.uid;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.mediumGray,
                                ),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.forestGreen,
                                  ),
                                  child: follower.profilePhotoUrl
                                          .isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            follower.profilePhotoUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                color:
                                                    AppColors.white,
                                              );
                                            },
                                          ),
                                        )
                                      : const Icon(Icons.person,
                                          color: AppColors.white),
                                ),
                                title: Text(
                                  follower.fullName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                subtitle: Text(
                                  follower.farmName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.mediumGray,
                                      ),
                                ),
                                trailing: isOwnProfile
                                    ? null
                                    : SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _toggleFollow(follower),
                                          style: ElevatedButton
                                              .styleFrom(
                                            backgroundColor:
                                                isFollowing
                                                    ? AppColors
                                                        .lightGray
                                                    : AppColors
                                                        .darkGreen,
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal: 8,
                                            ),
                                          ),
                                          child: Text(
                                            isFollowing
                                                ? 'دنبال‌شده'
                                                : 'دنبال',
                                            style: TextStyle(
                                              color: isFollowing
                                                  ? AppColors
                                                      .darkGreen
                                                  : AppColors
                                                      .white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileScreen(
                                            userId: follower.uid,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
