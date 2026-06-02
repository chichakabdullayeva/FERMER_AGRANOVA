# Agranova - Quick Start Guide

Get Agranova running in minutes!

## 🚀 Quick Setup (5 minutes)

### 1. Prerequisites
```bash
# Check Flutter installation
flutter --version
# Should show Flutter 3.0+
```

### 2. Install Dependencies
```bash
cd FERMER_AGRANOVA
flutter pub get
flutter gen-l10n
```

### 3. Configure Firebase (Optional for Testing)
- Skip this if you want to test UI without Firebase
- Follow `FIREBASE_SETUP.md` for complete setup

### 4. Run the App
```bash
flutter run
```

## 📁 Project Structure Quick Reference

```
lib/
├── main.dart                 ← App entry point
├── config/
│   └── theme.dart           ← Colors & design system
├── screens/
│   ├── home_screen.dart     ← Main app with bottom nav
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   └── tabs/
│       ├── feed_screen.dart        (Posts)
│       ├── messages_screen.dart    (Chats)
│       ├── groups_screen.dart      (Groups)
│       ├── weather_screen.dart     (Weather)
│       └── support_screen.dart     (AI & Expert)
├── services/
│   ├── auth_service.dart    ← Login/Register logic
│   └── firebase_service.dart ← Firebase init
├── models/
│   └── user_model.dart      ← User data structure
└── l10n/
    ├── app_az.arb           ← Azerbaijani text
    └── app_en.arb           ← English text
```

## 🎨 Design System

### Colors (in `config/theme.dart`)
```
Greens:  #2D5016 (Dark), #3D6B1F (Forest), #5A8C3A (Sage)
Yellows: #E8B547 (Warm), #F5E6D3 (Sand), #D4AF37 (Gold)
Blues:   #87CEEB (Sky), #1E3A5F (Navy), #E0F4FF (Light)
```

### Navigation
5-tab bottom navigation:
1. 🏠 Ana Səhifə (Feed)
2. 💬 Söhbətlər (Messages)
3. 👥 Qruplar (Groups)
4. 🌤️ Hava (Weather)
5. 🤖 Dəstək (Support/AI)

## 🔐 Authentication Flow

```
App Start
    ↓
Check if User Logged In (Firebase Auth)
    ↓
No → Show Login/Register Screen
    ↓
Yes → Show Home Screen (5 tabs)
```

### Test Credentials (after Firebase setup)
```
Email: test@agranova.com
Password: Test123456
```

## 🛠️ Common Tasks

### Change Language
In `main.dart`, line ~70:
```dart
// Change from Azerbaijani to English
locale: const Locale('en'),  // Change 'az' to 'en'
```

### Add New Localization String
1. Edit `lib/l10n/app_az.arb` and `app_en.arb`
2. Add your string key and value
3. Run `flutter gen-l10n`

### Change Theme Colors
Edit `lib/config/theme.dart` → `AppColors` class

### Navigate to Different Screen
Use setState to change tab in `home_screen.dart`

## 📱 Test on Different Devices

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run on Android emulator
flutter run

# Run on iOS simulator
open -a Simulator
flutter run
```

## 🐛 Troubleshooting

### "Command not found: flutter"
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### "Android SDK not found"
```bash
# Install via Android Studio or
flutter config --android-sdk-path /path/to/android-sdk
```

### "iOS pods not installed"
```bash
cd ios
pod install
cd ..
flutter run
```

### "Localization files not generated"
```bash
flutter clean
flutter pub get
flutter gen-l10n
flutter run
```

## 📚 Key Files to Know

| File | Purpose |
|------|---------|
| `main.dart` | App starts here |
| `home_screen.dart` | Main navigation hub |
| `theme.dart` | All colors & styles |
| `auth_service.dart` | Login/Register logic |
| `firebase_options.dart` | Firebase config (TO FILL) |
| `app_localizations.dart` | Auto-generated translations |

## 🔄 Development Workflow

```bash
# Make changes to code
# (Auto hot-reload should apply changes)
flutter run

# Make localization changes
flutter gen-l10n
flutter run

# Need fresh start?
flutter clean
flutter pub get
flutter run
```

## 📦 Build for Release

```bash
# Android APK
flutter build apk

# iOS app
flutter build ios

# Web
flutter build web

# Windows
flutter build windows
```

## 🚀 Next Phase Preview

Phase 2 will add:
- ✅ Post creation and real-time updates
- ✅ Image/video uploads to Firebase Storage
- ✅ Commenting and liking system
- ✅ Real-time messaging
- ✅ Group chat features

## 💡 Tips

- Use `flutter run -d chrome` for web testing
- DevTools: Press `D` while running to open in DevTools
- Hot Reload: Press `R` to reload changes
- Full Restart: Press `Shift + R` to restart app

## 📞 Support

For issues:
1. Check `README.md` for detailed documentation
2. Check `FIREBASE_SETUP.md` if Firebase issues
3. Review error messages in console
4. Common issues likely in pubspec.yaml or Firebase config

---

**Happy coding! 🎉**

Next: Complete Phase 2 - Core Feed Features
