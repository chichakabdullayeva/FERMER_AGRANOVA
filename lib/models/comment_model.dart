import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String uid;
  final String authorName;
  final String profilePhotoUrl;
  final String text;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.uid,
    required this.authorName,
    required this.profilePhotoUrl,
    required this.text,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String docId) {
    return CommentModel(
      id: docId,
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      authorName: map['authorName'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
      text: map['text'] ?? '',
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory CommentModel.fromFirebase(DocumentSnapshot doc) {
    return CommentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'authorName': authorName,
      'profilePhotoUrl': profilePhotoUrl,
      'text': text,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? uid,
    String? authorName,
    String? profilePhotoUrl,
    String? text,
    int? likes,
    List<String>? likedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      authorName: authorName ?? this.authorName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool hasLikedBy(String userId) => likedBy.contains(userId);
}
