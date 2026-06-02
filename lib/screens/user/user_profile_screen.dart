import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import 'followers_screen.dart';
import 'following_screen.dart';
import '../../models/app_localizations_stub.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _userService = UserService();
  final _authService = AuthService();

  AppLocalizations _localizations(BuildContext context) {
    return AppLocalizations.of(context) ?? AppLocalizationsEn();
  }

  @override
  Widget build(BuildContext context) {
    final loc = _localizations(context);
    final currentUser = _authService.getCurrentUser();
    final isOwnProfile = currentUser?.uid == widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        centerTitle: true,
        elevation: 2,
        actions: isOwnProfile
            ? [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile screen
            },
          ),
        ]
            : null,
      ),
      body: StreamBuilder<UserModel?>(
        stream: _userService.getUserProfileStream(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.darkGreen),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(loc.errorProfileUpdateFailed),
                ],
              ),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.darkGreen, AppColors.forestGreen],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Profile Photo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.warmYellow,
                            width: 4,
                          ),
                          color: AppColors.forestGreen,
                        ),
                        child: user.profilePhotoUrl.isNotEmpty
                            ? ClipOval(
                          child: Image.network(
                            user.profilePhotoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, size: 60, color: AppColors.white),
                          ),
                        )
                            : const Icon(Icons.person, size: 60, color: AppColors.white),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Farm Name
                      Text(
                        user.farmName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.warmYellow,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatColumn(
                            label: loc.posts,
                            value: '12', // TODO: Get actual count from Firestore
                            onTap: () {},
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.sandBeige,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowersScreen(
                                    userId: user.uid,
                                    userName: user.fullName,
                                  ),
                                ),
                              );
                            },
                            child: _StatColumn(
                              label: loc.followers,
                              value: '${user.followers}',
                              onTap: () {},
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: AppColors.sandBeige,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowingScreen(
                                    userId: user.uid,
                                    userName: user.fullName,
                                  ),
                                ),
                              );
                            },
                            child: _StatColumn(
                              label: loc.following,
                              value: '${user.following}',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // User Info Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location
                      _InfoCard(
                        icon: Icons.location_on,
                        title: loc.labelLocation,
                        value: user.location,
                      ),
                      const SizedBox(height: 12),

                      // Farm Type
                      _InfoCard(
                        icon: Icons.agriculture,
                        title: loc.labelFarmType,
                        value: user.farmType.isEmpty ? 'مشخص نشده' : user.farmType,
                      ),
                      const SizedBox(height: 12),

                      // Bio
                      if (user.bio.isNotEmpty)
                        _InfoCard(
                          icon: Icons.info,
                          title: loc.labelBio,
                          value: user.bio,
                        ),

                      if (user.bio.isNotEmpty) const SizedBox(height: 12),

                      // Agricultural Products
                      if (user.agriculturalProducts.isNotEmpty)
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.agriculture,
                                      color: AppColors.darkGreen,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      loc.labelAgriculturalProducts,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: user.agriculturalProducts.map((product) {
                                    return Chip(
                                      label: Text(product),
                                      backgroundColor: AppColors.sandBeige,
                                      labelStyle: const TextStyle(
                                        color: AppColors.darkGreen,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Action Buttons (if not own profile)
                      if (!isOwnProfile)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Send message
                                },
                                icon: const Icon(Icons.message),
                                label: const Text('پیام'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkGreen,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            StreamBuilder<bool>(
                              stream: currentUser != null
                                  ? _userService
                                      .isFollowingStream(
                                        currentUserId: currentUser.uid,
                                        targetUserId: widget.userId,
                                      )
                                  : Stream.value(false),
                              builder: (context, snapshot) {
                                final isFollowing = snapshot.data ?? false;
                                return SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      if (currentUser == null) return;

                                      if (isFollowing) {
                                        await _userService.unfollowUser(
                                          currentUserId: currentUser.uid,
                                          targetUserId: widget.userId,
                                        );
                                      } else {
                                        await _userService.followUser(
                                          currentUserId: currentUser.uid,
                                          targetUserId: widget.userId,
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.person_add),
                                    label: Text(
                                      isFollowing ? 'دنبال‌شده' : 'دنبال کن',
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: isFollowing
                                          ? AppColors.darkGreen
                                          : AppColors.darkGreen,
                                      side: const BorderSide(
                                        color: AppColors.darkGreen,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.warmYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.sandBeige,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.darkGreen, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
