# Firebase Setup Guide for Agranova

This guide explains how to configure Firebase for the Agranova application.

## Prerequisites

- Firebase account (free tier at https://firebase.google.com)
- FlutterFire CLI (optional but recommended)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `agranova`
4. Accept terms and create

## Step 2: Register Your Apps

### For Android:
1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.agranova.app` (or your preferred name)
3. Register app
4. Download `google-services.json`
5. Place in `android/app/google-services.json`

### For iOS:
1. Click "Add app" → iOS
2. Enter Bundle ID: `com.agranova.app`
3. Register app
4. Download `GoogleService-Info.plist`
5. Place in `ios/Runner/GoogleService-Info.plist`

### For Web:
1. Click "Add app" → Web
2. Enter app nickname (e.g., "Agranova Web")
3. Copy the Firebase config object

### For Windows:
1. Click "Add app" → Windows
2. Follow the setup wizard

## Step 3: Update Firebase Configuration

Edit `lib/services/firebase_options.dart` and replace the placeholders:

```dart
// For Android, iOS, macOS, Windows, Web - replace YOUR_* values with actual credentials
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'agranova',  // Your Firebase project ID
  storageBucket: 'agranova.appspot.com',  // Your storage bucket
);
```

You can find these values in:
- Firebase Console → Project Settings → General tab
- Or in your downloaded config files

## Step 4: Enable Authentication

1. Go to Firebase Console → Authentication
2. Click "Get started"
3. Enable "Email/Password" provider
4. Optional: Enable "Phone Number" provider

## Step 5: Create Firestore Database

1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Choose region (closest to your target users)
4. Start in **Test mode** (for development)

### Security Rules (Test Mode):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 6: Setup Cloud Storage

1. Go to Firebase Console → Storage
2. Click "Get started"
3. Choose a location
4. Accept default rules

### Storage Rules (for testing):
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 7: Setup Cloud Messaging (Optional)

1. Go to Firebase Console → Cloud Messaging
2. Copy Server API Key (for backend notifications)
3. Will be used for push notifications in Phase 3

## Step 8: Firestore Collections Schema

Create the following collections:

### `users` Collection
```json
{
  "uid": "string",
  "email": "string",
  "fullName": "string",
  "farmName": "string",
  "location": "string",
  "profilePhotoUrl": "string",
  "bio": "string",
  "farmType": "string",
  "agriculturalProducts": ["string"],
  "followers": 0,
  "following": 0,
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "isVerified": false
}
```

### `posts` Collection (for Phase 2)
```json
{
  "uid": "string",
  "authorName": "string",
  "location": "string",
  "description": "string",
  "mediaUrl": "string",
  "mediaType": "string",
  "likes": 0,
  "comments": 0,
  "shares": 0,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### `messages` Collection (for Phase 3)
```json
{
  "senderId": "string",
  "receiverId": "string",
  "text": "string",
  "mediaUrl": "string",
  "mediaType": "string",
  "timestamp": "timestamp",
  "isRead": false
}
```

## Step 9: Testing Connection

After setup, run:
```bash
flutter run
```

You should see:
1. App loads successfully
2. Navigation to Login screen
3. Can navigate between tabs after login
4. No Firebase errors in console

## Troubleshooting

### "Unable to find google-services.json"
- Ensure file is in `android/app/` directory
- Check file name spelling

### "Firebase initialization failed"
- Verify all API keys in `firebase_options.dart`
- Check Firebase Console → Project Settings for correct project ID

### "Permission denied" errors in Firestore
- Update Firestore Security Rules
- Check that user is authenticated

### "Connection timeout"
- Check internet connectivity
- Verify Firebase project is not suspended
- Check regional availability

## Security Checklist

Before production deployment:

- [ ] Update Firestore Rules from Test mode to Production
- [ ] Enable App Check for platforms
- [ ] Setup Firebase Authentication limits
- [ ] Configure CORS for web app
- [ ] Enable billing (for high traffic)
- [ ] Setup monitoring and alerts
- [ ] Implement rate limiting

### Production Firestore Rules Example:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == userId;
      allow update, delete: if request.auth.uid == userId;
    }
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.uid;
    }
  }
}
```

## Next Steps

- Phase 2 will add real-time post features
- Phase 3 will add messaging functionality
- Phase 4 will add AI integration

For more info: https://firebase.flutter.dev/
