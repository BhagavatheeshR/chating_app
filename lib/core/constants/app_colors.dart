import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Light Blue theme
  static const Color primary = Color(0xFF2196F3); // Material Light Blue 500
  static const Color primaryLight = Color(
    0xFF64B5F6,
  ); // Material Light Blue 300
  static const Color primaryDark = Color(0xFF1976D2); // Material Light Blue 700

  // Secondary colors
  static const Color secondary = Color(0xFF03A9F4); // Material Light Blue A400
  static const Color secondaryLight = Color(
    0xFF4FC3F7,
  ); // Material Light Blue A200
  static const Color secondaryDark = Color(
    0xFF0288D1,
  ); // Material Light Blue A700

  // Background colors
  static const Color background = Color(0xFFE3F2FD); // Material Light Blue 50
  static const Color surface = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFEB3B);
  static const Color info = Color(0xFF2196F3);

  // Chat-specific colors
  static const Color sentMessage = Color(0xFFE1F5FE); // Material Light Blue 50
  static const Color receivedMessage = Color(0xFFE8F5E9); // Material Green 50
  static const Color onlineStatus = Color(0xFF4CAF50);
  static const Color offlineStatus = Color(0xFF9E9E9E);
}
