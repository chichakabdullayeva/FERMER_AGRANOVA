import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/comment_model.dart';

class CommentService {
  static final CommentService _instance = CommentService._internal();

  factory CommentService() {
    return _instance;
  }

  CommentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = Uuid();

  /// Create a new comment on a post
  Future<CommentModel> createComment({
    required String postId,
    required String uid,
    required String authorName,
    required String profilePhotoUrl,
    required String text,
  }) async {
    try {
      final commentId = _uuid.v4();
      final now = DateTime.now();

      final commentData = CommentModel(
        id: commentId,
        postId: postId,
        uid: uid,
        authorName: authorName,
        profilePhotoUrl: profilePhotoUrl,
        text: text,
        likes: 0,
        likedBy: [],
        createdAt: now,
        updatedAt: now,
      );

      // Save to comments collection
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(commentData.toMap());

      // Increment post comments count
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({
        'comments': FieldValue.increment(1),
      });

      return commentData;
    } catch (e) {
      throw Exception('خطا در ایجاد نظر: $e');
    }
  }

  /// Get all comments for a post as a stream
  Stream<List<CommentModel>> getPostCommentsStream({
    required String postId,
    int limit = 100,
  }) {
    try {
      return _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CommentModel.fromFirebase(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('خطا در دریافت نظرات: $e');
    }
  }

  /// Get comment count for a post
  Future<int> getCommentCount(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      throw Exception('خطا در دریافت تعداد نظرات: $e');
    }
  }

  /// Like a comment
  Future<void> likeComment({
    required String postId,
    required String commentId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('خطا در پسند کردن نظر: $e');
    }
  }

  /// Unlike a comment
  Future<void> unlikeComment({
    required String postId,
    required String commentId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('خطا در عدم پسند کردن نظر: $e');
    }
  }

  /// Delete a comment
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      // Delete comment document
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      // Decrement post comments count
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({
        'comments': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('خطا در حذف نظر: $e');
    }
  }

  /// Update a comment
  Future<void> updateComment({
    required String postId,
    required String commentId,
    required String text,
  }) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'text': text,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('خطا در ویرایش نظر: $e');
    }
  }
}
