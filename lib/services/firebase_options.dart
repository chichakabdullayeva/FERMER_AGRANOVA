import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    if (Platform.isAndroid) return android;
    if (Platform.isIOS) return ios;
    if (Platform.isMacOS) return macos;
    if (Platform.isWindows) return windows;
    if (Platform.isLinux) return web;
    throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_K21ksMGpTaDtxi7oyzcfw_RQcKRNeYI',
    appId: '1:551738651492:android:6d972050c318c187a18071',
    messagingSenderId: '551738651492',
    projectId: 'agranova-20260603-app',
    storageBucket: 'agranova-20260603-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC71ORuODv50qd6ALjxgyv4wSZZdAAOAkw',
    appId: '1:551738651492:ios:6e84d848839ba980a18071',
    messagingSenderId: '551738651492',
    projectId: 'agranova-20260603-app',
    storageBucket: 'agranova-20260603-app.firebasestorage.app',
    iosBundleId: 'com.example.agranova',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC71ORuODv50qd6ALjxgyv4wSZZdAAOAkw',
    appId: '1:551738651492:ios:6e84d848839ba980a18071',
    messagingSenderId: '551738651492',
    projectId: 'agranova-20260603-app',
    storageBucket: 'agranova-20260603-app.firebasestorage.app',
    iosBundleId: 'com.example.agranova',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDXuRMkeMCni6TD6Kb8k7Om5wX4X99pffQ',
    appId: '1:551738651492:web:44c30c9e31f31bdda18071',
    messagingSenderId: '551738651492',
    projectId: 'agranova-20260603-app',
    authDomain: 'agranova-20260603-app.firebaseapp.com',
    storageBucket: 'agranova-20260603-app.firebasestorage.app',
    measurementId: 'G-WWL20N08G5',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDXuRMkeMCni6TD6Kb8k7Om5wX4X99pffQ',
    appId: '1:551738651492:web:5c0a3d139f45857ca18071',
    messagingSenderId: '551738651492',
    projectId: 'agranova-20260603-app',
    authDomain: 'agranova-20260603-app.firebaseapp.com',
    storageBucket: 'agranova-20260603-app.firebasestorage.app',
    measurementId: 'G-5NF9GBDS9P',
  );

}