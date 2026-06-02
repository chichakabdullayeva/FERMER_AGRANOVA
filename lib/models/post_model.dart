import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String uid;
  final String authorName;
  final String profilePhotoUrl;
  final String location;
  final String description;
  final List<String> mediaUrls;
  final List<String> mediaTypes; // 'image' or 'video'
  final int likes;
  final int comments;
  final int shares;
  final List<String> likedBy; // UIDs who liked this post
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    required this.id,
    required this.uid,
    required this.authorName,
    required this.profilePhotoUrl,
    required this.location,
    required this.description,
    required this.mediaUrls,
    required this.mediaTypes,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.likedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String docId) {
    return PostModel(
      id: docId,
      uid: map['uid'] ?? '',
      authorName: map['authorName'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      mediaTypes: List<String>.from(map['mediaTypes'] ?? []),
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory PostModel.fromFirebase(DocumentSnapshot doc) {
    return PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'authorName': authorName,
      'profilePhotoUrl': profilePhotoUrl,
      'location': location,
      'description': description,
      'mediaUrls': mediaUrls,
      'mediaTypes': mediaTypes,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'likedBy': likedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  PostModel copyWith({
    String? id,
    String? uid,
    String? authorName,
    String? profilePhotoUrl,
    String? location,
    String? description,
    List<String>? mediaUrls,
    List<String>? mediaTypes,
    int? likes,
    int? comments,
    int? shares,
    List<String>? likedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      authorName: authorName ?? this.authorName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      location: location ?? this.location,
      description: description ?? this.description,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaTypes: mediaTypes ?? this.mediaTypes,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool hasLikedBy(String userId) => likedBy.contains(userId);
}
