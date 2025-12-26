import 'package:flutter/material.dart';

class AppTheme {

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF44848B),

    scaffoldBackgroundColor: Colors.white,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF44848B),
      secondary: Color(0xFF5BB180),
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF44848B),
      elevation: 0,
      foregroundColor: Colors.white,
      centerTitle: true
    ),

    cardColor: Colors.white,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),

    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF44848B).withValues(alpha: 0.5);
        }
        return Colors.grey.shade300;
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF44848B);
        }
        return Color(0xFF44848B);
      }),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF44848B),
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF44848B),

    scaffoldBackgroundColor: const Color(0xFF1E1E1E),

    colorScheme: const ColorScheme.dark(
     primary: Color(0xFF44848B),
     secondary: Color(0xFF5BB180),
     surface: Color(0xFF1E1E1E),
    ),
    cardColor: const Color(0xFF1E1E1E),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF44848B),
      elevation: 0,
      foregroundColor: Colors.white,
      centerTitle: true
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF44848B).withValues(alpha: 0.6);
        }
        return Colors.grey.shade300;
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF44848B);
        }
        return Colors.grey.shade400;
      }),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF44848B),
      foregroundColor: Colors.white,
    ),
  );
}
