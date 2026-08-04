import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const standard = TextTheme(
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

  static const large = TextTheme(
    displayLarge: TextStyle(fontSize: 64, height: 1.12),
    displayMedium: TextStyle(fontSize: 51, height: 1.16),
    displaySmall: TextStyle(fontSize: 41, height: 1.22),
    headlineLarge: TextStyle(fontSize: 36, height: 1.25),
    headlineMedium: TextStyle(fontSize: 32, height: 1.29),
    headlineSmall: TextStyle(fontSize: 28, height: 1.33),
    titleLarge: TextStyle(fontSize: 25, height: 1.28),
    titleMedium: TextStyle(
      fontSize: 18,
      height: 1.45,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(fontSize: 18, height: 1.5),
    bodyMedium: TextStyle(fontSize: 16, height: 1.45),
    bodySmall: TextStyle(fontSize: 14, height: 1.4),
    labelLarge: TextStyle(
      fontSize: 16,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
  );

  static const extraLarge = TextTheme(
    displayLarge: TextStyle(fontSize: 72, height: 1.12),
    displayMedium: TextStyle(fontSize: 58, height: 1.16),
    displaySmall: TextStyle(fontSize: 47, height: 1.22),
    headlineLarge: TextStyle(fontSize: 42, height: 1.24),
    headlineMedium: TextStyle(fontSize: 36, height: 1.28),
    headlineSmall: TextStyle(fontSize: 32, height: 1.3),
    titleLarge: TextStyle(fontSize: 28, height: 1.3),
    titleMedium: TextStyle(
      fontSize: 21,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 18,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(fontSize: 21, height: 1.45),
    bodyMedium: TextStyle(fontSize: 18, height: 1.45),
    bodySmall: TextStyle(fontSize: 16, height: 1.4),
    labelLarge: TextStyle(
      fontSize: 18,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 16,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w500,
    ),
  );
}
