import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/theme.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? configError;
  try {
    await FirebaseService.initialize();
    await NotificationService.initialize();
  } catch (e) {
    configError = e.toString();
  }

  if (configError != null) {
    runApp(ConfigErrorApp(message: configError));
    return;
  }

  runApp(const AgranovaApp());
}

class ConfigErrorApp extends StatelessWidget {
  final String message;
  const ConfigErrorApp({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agranova - Configuration Error',
      home: Scaffold(
        appBar: AppBar(title: const Text('Configuration Required')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Firebase configuration is missing or invalid.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(message, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                const Text('How to fix:'),
                const SizedBox(height: 8),
                const Text('- Run `flutterfire configure` to generate `firebase_options.dart`'),
                const Text('- Or open the Firebase console → Project settings → Your apps, and copy the web config into'),
                const Text('  `lib/services/firebase_options.dart` replacing the placeholder values.'),
                const SizedBox(height: 12),
                const Text('After updating the config restart the app.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AgranovaApp extends StatefulWidget {
  const AgranovaApp({Key? key}) : super(key: key);

  @override
  State<AgranovaApp> createState() => _AgranovaAppState();
}

class _AgranovaAppState extends State<AgranovaApp> {
  bool _isLogin = true;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agranova',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('az'),
        Locale('en'),
      ],
      locale: const Locale('az'),
      home: StreamBuilder(
        stream: _authService.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          }

          // User is not logged in
          return _isLogin
              ? LoginScreen(
            onLoginSuccess: () {},
            onRegisterTap: () {
              setState(() => _isLogin = false);
            },
          )
              : RegisterScreen(
            onRegisterSuccess: () {
              setState(() => _isLogin = true);
            },
            onLoginTap: () {
              setState(() => _isLogin = true);
            },
          );
        },
      ),
    );
  }
}
