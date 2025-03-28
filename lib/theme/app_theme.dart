import 'package:flutter/material.dart';

/// The application theme
class AppTheme {
  /// Primary color
  static const Color primary = Color(0xFFFF8800);
  
  /// Primary dark color
  static const Color primaryDark = Color(0xFFE67700);
  
  /// Primary light color
  static const Color primaryLight = Color(0xFFFFAA33);
  
  /// Accent color
  static const Color accent = Color(0xFF00A5FF);
  
  /// Background color
  static const Color background = Color(0xFF121212);
  
  /// Surface color
  static const Color surface = Color(0xFF1E1E1E);
  
  /// Background gradient start color
  static const Color backgroundGradientStart = Color(0xFF121212);
  
  /// Background gradient end color
  static const Color backgroundGradientEnd = Color(0xFF202020);
  
  /// Text color
  static const Color textColor = Color(0xFFF5F5F5);
  
  /// Secondary text color
  static const Color textColorSecondary = Color(0xFFAAAAAA);

  /// Error color
  static const Color error = Color(0xFFCF6679);
  
  /// Get the light theme
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primary,
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryDark,
      secondary: accent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
  );
  
  /// Get the dark theme
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      primaryContainer: primaryDark,
      secondary: accent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: surface,
      background: background,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      color: surface,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: surface,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      filled: true,
      fillColor: background,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textColorSecondary,
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(color: textColor),
      displayMedium: const TextStyle(color: textColor),
      displaySmall: const TextStyle(color: textColor),
      headlineLarge: const TextStyle(color: textColor),
      headlineMedium: const TextStyle(color: textColor),
      headlineSmall: const TextStyle(color: textColor),
      titleLarge: const TextStyle(color: textColor),
      titleMedium: const TextStyle(color: textColor),
      titleSmall: const TextStyle(color: textColor),
      bodyLarge: const TextStyle(color: textColor),
      bodyMedium: const TextStyle(color: textColor),
      bodySmall: const TextStyle(color: textColorSecondary),
      labelLarge: const TextStyle(color: primary),
      labelMedium: const TextStyle(color: primary),
      labelSmall: const TextStyle(color: primary),
    ),
    dividerTheme: const DividerThemeData(
      color: textColorSecondary,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primary,
      inactiveTrackColor: Colors.grey[800],
      thumbColor: primary,
      overlayColor: primary.withOpacity(0.2),
      valueIndicatorColor: primary,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary.withOpacity(0.5);
        }
        return null;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return null;
      }),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primary,
      unselectedLabelColor: textColorSecondary,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primary, width: 2),
      ),
    ),
  );
}