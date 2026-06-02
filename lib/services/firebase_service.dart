import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Set Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Auth Singleton
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // Firestore Singleton
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;
}
