import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, height: 1.12),
    displayMedium: TextStyle(fontSize: 45, height: 1.16),
    displaySmall: TextStyle(fontSize: 36, height: 1.22),
    headlineLarge: TextStyle(fontSize: 32, height: 1.25),
    headlineMedium: TextStyle(fontSize: 28, height: 1.29),
    headlineSmall: TextStyle(fontSize: 24, height: 1.33),
    titleLarge: TextStyle(fontSize: 22, height: 1.27),
    titleMedium: TextStyle(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.43),
    bodySmall: TextStyle(fontSize: 12, height: 1.33),
    labelLarge: TextStyle(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      height: 1.33,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      height: 1.45,
      fontWeight: FontWeight.w500,
    ),
  );
}
