import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String farmName;
  final String location;
  final String profilePhotoUrl;
  final String bio;
  final String farmType;
  final List<String> agriculturalProducts;
  final int followers;
  final int following;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.farmName,
    required this.location,
    required this.profilePhotoUrl,
    required this.bio,
    required this.farmType,
    required this.agriculturalProducts,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      farmName: map['farmName'] ?? '',
      location: map['location'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
      bio: map['bio'] ?? '',
      farmType: map['farmType'] ?? '',
      agriculturalProducts: List<String>.from(map['agriculturalProducts'] ?? []),
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isVerified: map['isVerified'] ?? false,
    );
  }

  factory UserModel.fromFirebase(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'farmName': farmName,
      'location': location,
      'profilePhotoUrl': profilePhotoUrl,
      'bio': bio,
      'farmType': farmType,
      'agriculturalProducts': agriculturalProducts,
      'followers': followers,
      'following': following,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isVerified': isVerified,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? farmName,
    String? location,
    String? profilePhotoUrl,
    String? bio,
    String? farmType,
    List<String>? agriculturalProducts,
    int? followers,
    int? following,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      farmName: farmName ?? this.farmName,
      location: location ?? this.location,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bio: bio ?? this.bio,
      farmType: farmType ?? this.farmType,
      agriculturalProducts: agriculturalProducts ?? this.agriculturalProducts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
