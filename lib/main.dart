import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/theme.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await NotificationService.initialize();
  runApp(const AgranovaApp());
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
      localizationsDelegates: [
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
