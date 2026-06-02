import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final _auth = FirebaseService.auth;
  final _firestore = FirebaseService.firestore;

  // Register with email and password
  Future<UserCredential?> register({
    required String email,
    required String password,
    required String fullName,
    required String farmName,
    required String location,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'fullName': fullName,
        'farmName': farmName,
        'location': location,
        'profilePhotoUrl': '',
        'bio': '',
        'farmType': '',
        'agriculturalProducts': [],
        'followers': 0,
        'following': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isVerified': false,
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed');
    }
  }

  // Login with email and password
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Login failed');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Logout failed');
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Password reset failed');
    }
  }

  // Get current user
  User? getCurrentUser() => _auth.currentUser;

  // Listen to auth changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Update user profile
  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw AuthException('Profile update failed');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
