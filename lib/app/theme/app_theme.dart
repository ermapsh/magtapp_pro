import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1A73E8);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: const Color(0xFFF8F9FA),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F9FA),
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF747775)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF747775)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),

        labelStyle: const TextStyle(color: Color(0xFF5F6368)),

        floatingLabelStyle: const TextStyle(color: primaryBlue),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryBlue),
      ),
    );
  }
}
