import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import 'user_profile_screen.dart';

class FollowingScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const FollowingScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final _userService = UserService();
  final _authService = AuthService();
  final _searchController = TextEditingController();
  List<UserModel> _allFollowing = [];
  List<UserModel> _filteredFollowing = [];

  @override
  void initState() {
    super.initState();
    _loadFollowing();
    _searchController.addListener(_filterFollowing);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowing() async {
    try {
      // Get all users this user is following
      final following = await _userService.getFollowingList(widget.userId);

      setState(() {
        _allFollowing = following;
        _filteredFollowing = following;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا: $e')),
      );
    }
  }

  void _filterFollowing() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFollowing = _allFollowing
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
        title: Text('${widget.userName} - دنبال‌ شده'),
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

          // Following List
          Expanded(
            child: _filteredFollowing.isEmpty
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
                          'کسی را دنبال نمی‌کند',
                          style:
                              TextStyle(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredFollowing.length,
                    itemBuilder: (context, index) {
                      final following = _filteredFollowing[index];
                      return FutureBuilder<bool>(
                        future: currentUser != null
                            ? _userService.isFollowing(
                                currentUserId: currentUser.uid,
                                targetUserId: following.uid,
                              )
                            : Future.value(false),
                        builder: (context, snapshot) {
                          final isFollowing = snapshot.data ?? false;
                          final isOwnProfile =
                              currentUser?.uid == following.uid;

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
                                  child: following.profilePhotoUrl
                                          .isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            following.profilePhotoUrl,
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
                                  following.fullName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                subtitle: Text(
                                  following.farmName,
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
                                              _toggleFollow(following),
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
                                            userId: following.uid,
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
