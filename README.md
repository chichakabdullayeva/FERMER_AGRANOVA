# Agranova - Farmer Community App

A comprehensive cross-platform Flutter application for farmers, featuring a social community feed, real-time messaging, group management, weather information, and AI-powered agricultural support.

## Phase 1: Project Setup and UI Structure ✅

### Project Overview

**Agranova** is designed with a modern, clean interface using:
- **Color Palette**: Deep earth greens, warm sand yellows, and sky blues
- **Language**: Azerbaijani (az-AZ) localization with English fallback
- **Platform**: Cross-platform Flutter application (iOS, Android, Windows, Web)

### Phase 1 Features Implemented

#### 1. **Project Structure**
```
agranova/
├── lib/
│   ├── config/
│   │   └── theme.dart              # App colors, theme configuration
│   ├── l10n/
│   │   ├── app_az.arb              # Azerbaijani localizations
│   │   └── app_en.arb              # English localizations
│   ├── models/
│   │   └── user_model.dart         # User data model
│   ├── services/
│   │   ├── auth_service.dart       # Authentication logic
│   │   ├── firebase_service.dart   # Firebase initialization
│   │   └── firebase_options.dart   # Firebase configuration
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart   # Login UI
│   │   │   └── register_screen.dart # Registration UI
│   │   ├── tabs/
│   │   │   ├── feed_screen.dart    # Ana Səhifə (Feed)
│   │   │   ├── messages_screen.dart # Söhbətlər (Messages)
│   │   │   ├── groups_screen.dart   # Qruplar (Groups)
│   │   │   ├── weather_screen.dart  # Hava (Weather)
│   │   │   └── support_screen.dart  # Dəstək (Support/AI)
│   │   └── home_screen.dart        # Main home with bottom navigation
│   └── main.dart                   # App entry point
├── pubspec.yaml                    # Dependencies
├── l10n.yaml                       # Localization configuration
└── README.md                       # This file
```

#### 2. **Bottom Navigation Bar**
Five main tabs with localized labels:
- **Ana Səhifə** (Feed) - Farmer community feed with posts
- **Söhbətlər** (Messages) - Direct chats and group messaging
- **Qruplar** (Groups) - Community group list and cards
- **Hava** (Weather) - Weather forecast and agricultural tips
- **Dəstək** (Support/AI) - AGRO-BOT AI assistant and expert services

#### 3. **Authentication System**
- Firebase Authentication integration
- User registration with farm details
- Secure login/logout functionality
- User profile creation with:
  - Full name
  - Farm name
  - Location
  - Profile photo
  - Bio and farm type
  - Agricultural products list

#### 4. **Localization**
- Complete Azerbaijani (az) translation
- English (en) fallback
- 100+ localized strings covering:
  - Navigation labels
  - Button labels
  - Form validations
  - Error messages
  - UI descriptions

#### 5. **Design System**
- **AppColors**: Predefined color palette
- **AppTheme**: Material 3 theme with custom colors
- Consistent UI components across the app
- Responsive design for multiple screen sizes

### Dependencies Added

Key packages installed:
```yaml
# Firebase
firebase_core: ^2.24.0
firebase_auth: ^4.13.0
cloud_firestore: ^4.13.0
firebase_storage: ^11.5.0
firebase_messaging: ^14.7.0

# State Management
provider: ^6.0.0

# Localization
intl: ^0.19.0
flutter_localizations: sdk

# UI/UX
google_fonts: ^6.1.0
flutter_svg: ^2.0.7
cached_network_image: ^3.3.0
shimmer: ^3.0.0

# Navigation & Data
go_router: ^12.0.0
image_picker: ^1.0.4

# Advanced Features
stream_chat_flutter: ^6.7.0
google_generative_ai: ^0.3.0
in_app_purchase: ^3.1.5
geolocator: ^9.0.2
```

### Setup Instructions

#### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Firebase account
- Android Studio / Xcode (for mobile development)

#### Step 1: Clone and Setup
```bash
cd FERMER_AGRANOVA
flutter pub get
flutter gen-l10n  # Generate localization files
```

#### Step 2: Firebase Configuration
1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Add Android, iOS, Web, and Windows apps
3. Download configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Web: Copy config from Firebase console
4. Update `lib/services/firebase_options.dart` with your Firebase credentials

#### Step 3: Install Localization
```bash
flutter pub run intl_utils:generate  # If using intl_utils
# OR use Flutter's built-in l10n support
flutter generate-l10n
```

#### Step 4: Run the App
```bash
flutter run
```

### File Structure Details

#### **lib/config/theme.dart**
Defines the complete design system:
- Color constants (earth greens, sand yellows, sky blues, neutrals)
- Material 3 theme configuration
- AppBar and BottomNavigationBar styling

#### **lib/services/**
- `firebase_service.dart`: Singleton pattern for Firebase initialization
- `auth_service.dart`: Authentication business logic
- `firebase_options.dart`: Platform-specific Firebase configurations (TO BE FILLED)

#### **lib/screens/auth/**
- `login_screen.dart`: Beautiful login form with validation
- `register_screen.dart`: Multi-field registration with farm details

#### **lib/screens/tabs/**
- `feed_screen.dart`: Posts feed with user profiles, interactions
- `messages_screen.dart`: Chat list with online status
- `groups_screen.dart`: Group cards in grid layout
- `weather_screen.dart`: 7-day forecast and agricultural tips
- `support_screen.dart`: AGRO-BOT AI portal and expert services

### UI Components Created

1. **FeedPostCard**: Shows user info, post content, and interactions
2. **ChatListTile**: Displays chat/group with status indicators
3. **GroupCard**: Beautiful group card with member count
4. **WeatherDetailCard**: Weather information display
5. **FAQItem**: Expandable FAQ for support section

### Next Steps (Phase 2)

Phase 2 will implement:
- **Feed Features**: Real-time post creation, image/video upload
- **Messaging**: Real-time chat with file sharing
- **Database Models**: Firestore collections for posts, messages, users
- **Search & Filtering**: Find posts, users, and groups

### Important Notes

⚠️ **Firebase Configuration Required**
- Update `firebase_options.dart` with your Firebase project details
- Initialize Firebase in your Android/iOS/Web project settings

⚠️ **Localization**
- Currently set to Azerbaijani locale
- Change in `main.dart` line `locale: const Locale('az')`
- The app will auto-generate `gen/l10n/app_localizations.dart`

⚠️ **Testing**
- Use Firebase Emulator Suite for local development
- Configure Firebase rules for authentication

### Development Commands

```bash
# Generate localization files
flutter gen-l10n

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Run on specific device
flutter run -d <device_id>

# Build for production
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
flutter build windows    # Windows
```

### Architecture Decisions

1. **Firebase Backend**: Scalable, real-time database
2. **Provider for State Management**: Lightweight and efficient
3. **Localization with arb files**: Standard Flutter approach
4. **Singleton Pattern for Services**: Ensures single instance of Firebase/Auth
5. **Material 3 Design**: Modern and accessible UI

### Contributing Guidelines

- Follow Dart naming conventions (camelCase for variables/methods)
- Use const constructors where possible
- Document complex logic with comments
- Test on multiple screen sizes

---

**Phase 1 Status**: ✅ Complete
**Next Release**: Phase 2 - Core Features Implementation
**Maintainer**: Agranova Development Team
