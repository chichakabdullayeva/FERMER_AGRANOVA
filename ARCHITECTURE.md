# Agranova Architecture & Navigation Guide

## 🗺️ Application Navigation Map

```
┌─────────────────────────────────────────────────────────────┐
│                     Agranova App                             │
└─────────────────────────────────────────────────────────────┘
                            │
                    ┌───────┴───────┐
                    │               │
            User Not Logged In   User Logged In
                    │               │
        ┌───────────┴───────────┐   │
        │                       │   │
    LoginScreen          RegisterScreen
        ↓                       ↓   │
    [Input Email]          [Farm Details]
    [Input Password]       [Create Account]
        │                       │
        └───────────────────────┘
                    │
                    ↓
        ┌─────────────────────────────────────────────────────┐
        │            HomeScreen (Bottom Navigation)           │
        ├─────────────────────────────────────────────────────┤
        │ [🏠] [💬] [👥] [🌤️] [🤖]                           │
        └─────────────────────────────────────────────────────┘
             │      │      │      │      │
             ↓      ↓      ↓      ↓      ↓
         Feed   Messages Groups Weather Support
         Screen  Screen   Screen  Screen Screen
```

## 📦 Module Architecture

```
lib/
│
├── 🎯 main.dart
│   └─ App entry point
│   └─ Auth state management
│   └─ Navigation to Login/Home
│
├── 📐 config/
│   └─ theme.dart
│      ├─ AppColors (all color constants)
│      ├─ AppTheme (Material 3 theme)
│      └─ Styling configurations
│
├── 🌍 l10n/ (Localization)
│   ├─ app_az.arb (Azerbaijani)
│   └─ app_en.arb (English)
│
├── 📊 models/
│   └─ user_model.dart
│      ├─ User data structure
│      ├─ Firebase mapping
│      └─ Serialization methods
│
├── ⚙️ services/ (Business Logic)
│   ├─ firebase_service.dart
│   │  └─ Firebase initialization
│   │  └─ Singletons for Auth/Firestore
│   │
│   ├─ auth_service.dart
│   │  ├─ register()
│   │  ├─ login()
│   │  ├─ logout()
│   │  ├─ resetPassword()
│   │  └─ updateProfile()
│   │
│   └─ firebase_options.dart
│      └─ Platform-specific configs
│
├── 📱 screens/
│   │
│   ├─ 🔐 auth/
│   │  ├─ login_screen.dart
│   │  │  ├─ Email input
│   │  │  ├─ Password input
│   │  │  ├─ Show/hide password toggle
│   │  │  ├─ Validation
│   │  │  └─ Error handling
│   │  │
│   │  └─ register_screen.dart
│   │     ├─ Email input
│   │     ├─ Full name input
│   │     ├─ Farm name input
│   │     ├─ Location input
│   │     ├─ Password fields
│   │     └─ Form validation
│   │
│   ├─ 🏠 home_screen.dart
│   │  ├─ IndexedStack for tab management
│   │  ├─ BottomNavigationBar with 5 items
│   │  └─ Tab switching logic
│   │
│   └─ 📑 tabs/
│      ├─ feed_screen.dart (Ana Səhifə)
│      │  ├─ Search bar
│      │  ├─ FeedPostCard list
│      │  └─ FAB to create post
│      │
│      ├─ messages_screen.dart (Söhbətlər)
│      │  ├─ Search bar
│      │  ├─ ChatListTile list
│      │  └─ Online status indicators
│      │
│      ├─ groups_screen.dart (Qruplar)
│      │  ├─ Search bar
│      │  ├─ GroupCard grid
│      │  └─ Join/Leave buttons
│      │
│      ├─ weather_screen.dart (Hava)
│      │  ├─ Current weather card
│      │  ├─ Weather details grid
│      │  ├─ 7-day forecast
│      │  └─ Agricultural tips
│      │
│      └─ support_screen.dart (Dəstök)
│         ├─ AGRO-BOT portal card
│         ├─ Premium services
│         ├─ Expert network info
│         └─ FAQ section
│
└── 📚 Documentation
   ├─ README.md
   ├─ FIREBASE_SETUP.md
   ├─ QUICKSTART.md
   └─ PHASE1_COMPLETION.md
```

## 🔄 Data Flow Architecture

```
User Input (UI)
    ↓
Event Handler (Screen)
    ↓
Service Layer (Business Logic)
    ├─ AuthService
    │  └─ Firebase Authentication
    └─ FirebaseService
       └─ Firestore/Storage
    ↓
Firebase Backend
    ├─ Authentication
    ├─ Firestore Database
    └─ Cloud Storage
    ↓
Response Data
    ↓
Model Layer
    └─ User Model
    ↓
State Update (setState)
    ↓
UI Rebuild
    ↓
User Sees Result
```

## 🎨 UI Component Hierarchy

```
MaterialApp (Theme + Localization)
│
├─ LoginScreen
│  └─ Form
│     ├─ TextFormField (Email)
│     ├─ TextFormField (Password)
│     └─ ElevatedButton
│
├─ RegisterScreen
│  └─ Form
│     ├─ TextFormField (multiple)
│     └─ ElevatedButton
│
└─ HomeScreen
   ├─ IndexedStack
   │  ├─ FeedScreen
   │  │  ├─ SearchBar
   │  │  └─ ListView
   │  │     └─ FeedPostCard (×5)
   │  │        ├─ UserHeader
   │  │        ├─ PostDescription
   │  │        ├─ PostImage
   │  │        └─ InteractionBar
   │  │           ├─ LikeButton
   │  │           ├─ CommentButton
   │  │           └─ ShareButton
   │  │
   │  ├─ MessagesScreen
   │  │  ├─ SearchBar
   │  │  └─ ListView
   │  │     └─ ChatListTile (×8)
   │  │        ├─ Avatar + OnlineStatus
   │  │        ├─ Name & LastMessage
   │  │        └─ Time & UnreadCount
   │  │
   │  ├─ GroupsScreen
   │  │  ├─ SearchBar
   │  │  └─ GridView (2 columns)
   │  │     └─ GroupCard (×6)
   │  │        ├─ GroupIcon
   │  │        ├─ GroupName & Members
   │  │        └─ JoinButton
   │  │
   │  ├─ WeatherScreen
   │  │  ├─ CurrentWeatherCard
   │  │  ├─ DetailsGrid
   │  │  │  └─ WeatherDetailCard (×4)
   │  │  ├─ ForecastScroll
   │  │  └─ TipsCard
   │  │
   │  └─ SupportScreen
   │     ├─ AgroBotCard
   │     ├─ PremiumSection
   │     │  ├─ ExpertCallCard
   │     │  └─ ExpertNetworkCard
   │     └─ FAQSection
   │        └─ FAQItem (×2)
   │
   └─ BottomNavigationBar
      ├─ Home Item
      ├─ Messages Item
      ├─ Groups Item
      ├─ Weather Item
      └─ Support Item
```

## 🔐 Authentication Flow Diagram

```
┌─────────────────────────────────────────────────────┐
│ App Starts: main() runs                             │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ Firebase Initialized: FirebaseService.initialize()  │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ Auth State Listener: authStateChanges() stream      │
└─────────────────────────────────────────────────────┘
                        ↓
                ┌───────┴───────┐
                │               │
            Snapshot    Snapshot has data?
            received            │
                ├────No─────────┴─→ Show Auth Screens
                │                   (Login/Register)
                │
                └────Yes────────→ Show HomeScreen
                                    (5 tabs)

LOGIN PROCESS:
User enters credentials
        ↓
LoginScreen calls AuthService.login()
        ↓
AuthService calls FirebaseAuth.signInWithEmailAndPassword()
        ↓
Firebase validates credentials
        ↓
AuthState changes
        ↓
StreamBuilder detects change
        ↓
Navigates to HomeScreen

REGISTER PROCESS:
User fills registration form
        ↓
RegisterScreen calls AuthService.register()
        ↓
AuthService calls FirebaseAuth.createUserWithEmailAndPassword()
        ↓
AuthService creates Firestore user document
        ↓
AuthState changes
        ↓
StreamBuilder detects change
        ↓
Navigates to HomeScreen
```

## 📍 State Management Strategy

### App Level State
- Authentication state (StreamBuilder)
- User session (Firebase Auth)
- Theme preference (planned)
- Language preference (Locale)

### Screen Level State
- Tab selection (HomeScreen - setState)
- Form fields (LoginScreen/RegisterScreen - TextEditingController)
- Search input (Feed/Messages/Groups - TextEditingController)
- UI visibility (password show/hide - setState)

### Local Component State
- Expansion state (FAQItem - ExpansionTile)
- Form validation (TextFormField - validator)

## 🔌 Service Dependency Injection

```
FirebaseService (Singleton)
├─ Static method: initialize()
├─ Static property: auth → FirebaseAuth
└─ Static property: firestore → FirebaseFirestore

AuthService (Singleton)
├─ Uses: FirebaseService.auth
├─ Uses: FirebaseService.firestore
└─ Methods:
   ├─ register()
   ├─ login()
   ├─ logout()
   ├─ resetPassword()
   ├─ getCurrentUser()
   ├─ authStateChanges()
   └─ updateProfile()
```

## 🌍 Localization Architecture

```
Localization Flow:
User sets locale → const Locale('az') in main.dart
                        ↓
        AppLocalizations.of(context)!
                        ↓
        Access localized strings
        Example: loc.buttonLogin
                        ↓
        Returns Azerbaijani text
        
Supported Languages:
├─ Azerbaijani (az) - Primary
└─ English (en) - Fallback

ARB Files:
├─ app_az.arb (110+ strings)
├─ app_en.arb (110+ strings)
└─ Auto-generates: app_localizations.dart

String Categories:
├─ Navigation (5 tabs)
├─ Buttons (12+ variations)
├─ Labels (15+ fields)
├─ Validations (6+ messages)
├─ Errors (8+ types)
├─ Status (10+ variations)
└─ Hints & Placeholders (10+)
```

## 📊 Database Schema (Phase 1 Ready)

```
Firestore Collections:

users/
├── uid/ (document)
│   ├─ uid: string
│   ├─ email: string
│   ├─ fullName: string
│   ├─ farmName: string
│   ├─ location: string
│   ├─ profilePhotoUrl: string
│   ├─ bio: string
│   ├─ farmType: string
│   ├─ agriculturalProducts: array
│   ├─ followers: number
│   ├─ following: number
│   ├─ createdAt: timestamp
│   ├─ updatedAt: timestamp
│   └─ isVerified: boolean

(More collections in Phase 2)
```

## 🎯 Feature Implementation Map

### Phase 1 ✅ (CURRENT)
- [x] Project setup
- [x] UI structure
- [x] Authentication
- [x] Navigation
- [x] Localization
- [x] Mock UI screens

### Phase 2 ⏳ (NEXT)
- [ ] Real-time posts
- [ ] Image uploads
- [ ] Like/comment system
- [ ] Real-time messaging
- [ ] Group chats

### Phase 3 ⏳ (FUTURE)
- [ ] AI assistant integration
- [ ] Expert video calls (IAP)
- [ ] Push notifications
- [ ] Advanced weather features

### Phase 4 ⏳ (FUTURE)
- [ ] Analytics
- [ ] Performance optimization
- [ ] Offline support
- [ ] App store deployment

---

This architecture provides a solid, scalable foundation for the Agranova application, with clear separation of concerns and room for future features.
