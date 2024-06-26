import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: const Color(0xFF0E86D4).withOpacity(0.8),
      cardColor: const Color(0xFFE3E7EE),
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
        bodyLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.grey[700], fontWeight: FontWeight.bold),
      ),
    );
  }
}