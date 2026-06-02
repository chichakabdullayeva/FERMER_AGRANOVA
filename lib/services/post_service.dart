import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import '../models/post_model.dart';

class PostService {
  static final PostService _instance = PostService._internal();

  factory PostService() {
    return _instance;
  }

  PostService._internal();

  final _firestore = FirebaseService.firestore;

  // Create a new post
  Future<String> createPost({
    required String uid,
    required String authorName,
    required String profilePhotoUrl,
    required String location,
    required String description,
    required List<String> mediaUrls,
    required List<String> mediaTypes,
  }) async {
    try {
      final docRef = await _firestore.collection('posts').add({
        'uid': uid,
        'authorName': authorName,
        'profilePhotoUrl': profilePhotoUrl,
        'location': location,
        'description': description,
        'mediaUrls': mediaUrls,
        'mediaTypes': mediaTypes,
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'likedBy': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw PostException('Failed to create post: $e');
    }
  }

  // Get posts stream (real-time)
  Stream<List<PostModel>> getPostsStream({int limit = 20}) {
    try {
      return _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PostModel.fromFirebase(doc))
            .toList();
      });
    } catch (e) {
      throw PostException('Failed to get posts: $e');
    }
  }

  // Get posts from following users (real-time)
  Stream<List<PostModel>> getFollowingPostsStream({
    required List<String> followingUserIds,
    int limit = 50,
  }) {
    try {
      if (followingUserIds.isEmpty) {
        return Stream.value([]);
      }

      return _firestore
          .collection('posts')
          .where('uid', whereIn: followingUserIds)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PostModel.fromFirebase(doc))
            .toList();
      });
    } catch (e) {
      throw PostException('Failed to get following posts: $e');
    }
  }

  // Get paginated posts
  Future<List<PostModel>> getPostsPaginated({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PostModel.fromFirebase(doc))
          .toList();
    } catch (e) {
      throw PostException('Failed to get paginated posts: $e');
    }
  }

  // Get user's posts
  Stream<List<PostModel>> getUserPostsStream(String uid) {
    try {
      return _firestore
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PostModel.fromFirebase(doc))
            .toList();
      });
    } catch (e) {
      throw PostException('Failed to get user posts: $e');
    }
  }

  // Like a post
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likedBy': FieldValue.arrayUnion([userId]),
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      throw PostException('Failed to like post: $e');
    }
  }

  // Unlike a post
  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likedBy': FieldValue.arrayRemove([userId]),
        'likes': FieldValue.increment(-1),
      });
    } catch (e) {
      throw PostException('Failed to unlike post: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      // Delete post document
      await _firestore.collection('posts').doc(postId).delete();
      
      // TODO: Delete associated media from Firebase Storage
      // TODO: Delete associated comments
    } catch (e) {
      throw PostException('Failed to delete post: $e');
    }
  }

  // Update post description
  Future<void> updatePost({
    required String postId,
    required String description,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'description': description,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw PostException('Failed to update post: $e');
    }
  }

  // Get single post
  Future<PostModel?> getPost(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return PostModel.fromFirebase(doc);
      }
      return null;
    } catch (e) {
      throw PostException('Failed to get post: $e');
    }
  }

  // Increment share count
  Future<void> sharePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'shares': FieldValue.increment(1),
      });
    } catch (e) {
      throw PostException('Failed to share post: $e');
    }
  }

  // Get posts by location (for location-based feed)
  Stream<List<PostModel>> getPostsByLocation(String location) {
    try {
      return _firestore
          .collection('posts')
          .where('location', isEqualTo: location)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PostModel.fromFirebase(doc))
            .toList();
      });
    } catch (e) {
      throw PostException('Failed to get posts by location: $e');
    }
  }
}

class PostException implements Exception {
  final String message;
  PostException(this.message);

  @override
  String toString() => message;
}
