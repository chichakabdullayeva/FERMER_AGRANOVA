import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  final _firestore = FirebaseService.firestore;

  // Get user profile by UID
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirebase(doc);
      }
      return null;
    } catch (e) {
      throw UserException('Failed to get user profile: $e');
    }
  }

  // Get user profile stream (real-time)
  Stream<UserModel?> getUserProfileStream(String uid) {
    try {
      return _firestore
          .collection('users')
          .doc(uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return UserModel.fromFirebase(snapshot);
        }
        return null;
      });
    } catch (e) {
      throw UserException('Failed to get user profile stream: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> updates,
  }) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw UserException('Failed to update user profile: $e');
    }
  }

  // Get multiple users (for followers/following lists)
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) return [];

      final docs = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      return docs.docs
          .map((doc) => UserModel.fromFirebase(doc))
          .toList();
    } catch (e) {
      throw UserException('Failed to get users: $e');
    }
  }

  // Search users by name
  Stream<List<UserModel>> searchUsersByName(String searchTerm) {
    try {
      if (searchTerm.isEmpty) {
        return Stream.value([]);
      }

      return _firestore
          .collection('users')
          .where('fullName', isGreaterThanOrEqualTo: searchTerm)
          .where('fullName', isLessThan: searchTerm + 'z')
          .limit(20)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => UserModel.fromFirebase(doc))
            .toList();
      });
    } catch (e) {
      throw UserException('Failed to search users: $e');
    }
  }

  // Follow user
  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      // Add to current user's following list
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .update({
        'following': FieldValue.increment(1),
      });

      // Add to target user's followers list
      await _firestore
          .collection('users')
          .doc(targetUserId)
          .update({
        'followers': FieldValue.increment(1),
      });

      // Create follow relationship document
      await _firestore.collection('follows').doc().set({
        'followerId': currentUserId,
        'followingId': targetUserId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw UserException('Failed to follow user: $e');
    }
  }

  // Unfollow user
  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      // Remove from current user's following list
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .update({
        'following': FieldValue.increment(-1),
      });

      // Remove from target user's followers list
      await _firestore
          .collection('users')
          .doc(targetUserId)
          .update({
        'followers': FieldValue.increment(-1),
      });

      // Delete follow relationship document
      final followQuery = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: currentUserId)
          .where('followingId', isEqualTo: targetUserId)
          .get();

      for (final doc in followQuery.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw UserException('Failed to unfollow user: $e');
    }
  }

  // Check if following user
  Future<bool> isFollowing({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      final query = await _firestore
          .collection('follows')
          .where('followerId', isEqualTo: currentUserId)
          .where('followingId', isEqualTo: targetUserId)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      throw UserException('Failed to check follow status: $e');
    }
  }

  // Check if following user (real-time stream)
  Stream<bool> isFollowingStream({
    required String currentUserId,
    required String targetUserId,
  }) {
    try {
      return _firestore
          .collection('follows')
          .where('followerId', isEqualTo: currentUserId)
          .where('followingId', isEqualTo: targetUserId)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty);
    } catch (e) {
      throw UserException('Failed to check follow status stream: $e');
    }
  }

  // Delete user account (cascading deletes should be handled by Cloud Functions)
  Future<void> deleteUserAccount(String uid) async {
    try {
      // Delete user document
      await _firestore.collection('users').doc(uid).delete();
      
      // Note: Cascading deletes (posts, messages, etc.) should be handled by
      // Cloud Functions or separate operations for data integrity
    } catch (e) {
      throw UserException('Failed to delete user account: $e');
    }
  }

  // Get user stats (followers, following, posts count)
  Future<Map<String, dynamic>> getUserStats(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final postsSnapshot = await _firestore
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .count()
          .get();

      return {
        'followers': userDoc.data()?['followers'] ?? 0,
        'following': userDoc.data()?['following'] ?? 0,
        'posts': postsSnapshot.count,
      };
    } catch (e) {
      throw UserException('Failed to get user stats: $e');
    }
  }

  // Get list of followers for a user
  Future<List<UserModel>> getFollowersList(String uid) async {
    try {
      final followersSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('followers')
          .get();

      final followersList = <UserModel>[];
      for (final doc in followersSnapshot.docs) {
        final followerProfile = await getUserProfile(doc.id);
        if (followerProfile != null) {
          followersList.add(followerProfile);
        }
      }
      return followersList;
    } catch (e) {
      throw UserException('Failed to get followers list: $e');
    }
  }

  // Get list of users that a user is following
  Future<List<UserModel>> getFollowingList(String uid) async {
    try {
      final followingSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('following')
          .get();

      final followingList = <UserModel>[];
      for (final doc in followingSnapshot.docs) {
        final followingProfile = await getUserProfile(doc.id);
        if (followingProfile != null) {
          followingList.add(followingProfile);
        }
      }
      return followingList;
    } catch (e) {
      throw UserException('Failed to get following list: $e');
    }
  }
}

class UserException implements Exception {
  final String message;
  UserException(this.message);

  @override
  String toString() => message;
}
