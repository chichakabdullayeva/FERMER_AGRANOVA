import 'package:flutter/material.dart';

class AppColors {
  // Earth Greens
  static const Color darkGreen = Color(0xFF2D5016);
  static const Color forestGreen = Color(0xFF3D6B1F);
  static const Color sageGreen = Color(0xFF5A8C3A);
  
  // Warm Sand Yellows
  static const Color warmYellow = Color(0xFFE8B547);
  static const Color sandBeige = Color(0xFFF5E6D3);
  static const Color goldAccent = Color(0xFFD4AF37);
  
  // Sky Blues
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color navyBlue = Color(0xFF1E3A5F);
  static const Color lightBlue = Color(0xFFE0F4FF);
  
  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  static const Color black = Color(0xFF000000);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkGreen,
      brightness: Brightness.light,
      primary: AppColors.darkGreen,
      secondary: AppColors.warmYellow,
      tertiary: AppColors.skyBlue,
    ),
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkGreen,
      foregroundColor: AppColors.white,
      elevation: 2,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.darkGreen,
      unselectedItemColor: AppColors.mediumGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkGreen,
      foregroundColor: AppColors.white,
    ),
  );
}
