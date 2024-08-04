import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: const Color(0xFF0E86D4).withOpacity(0.8),
      cardColor: const Color(0xFFEDF1F8),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
            fontFamily: 'Montserrat', fontSize: 30.0, color: Colors.black),
        bodyMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16.0,
            fontWeight: FontWeight.w300),
        bodyLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16.0,
            color: Color(0xFF737373),
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
