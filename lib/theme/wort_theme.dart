import 'package:flutter/material.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/theme/app_typography.dart';

abstract final class WortTheme {
  static const Map<ColorPalette, Color> _seeds = {
    ColorPalette.pink: Color(0xFFC8409A),
    ColorPalette.azure: Color(0xFF1677C8),
    ColorPalette.lime: Color(0xFF5F8F12),
  };

  static ThemeData light(ColorPalette palette) =>
      _build(Brightness.light, palette);
  static ThemeData dark(ColorPalette palette) =>
      _build(Brightness.dark, palette);

  static ThemeData _build(Brightness brightness, ColorPalette palette) {
    final monochrome = palette == ColorPalette.monochrome;
    final colorScheme = monochrome
        ? _monochromeScheme(brightness)
        : ColorScheme.fromSeed(
            seedColor: _seeds[palette]!,
            brightness: brightness,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: monochrome
          ? colorScheme.surface
          : brightness == Brightness.dark
          ? const Color(0xFF0D0D0D)
          : const Color(0xFFF8F7F9),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ColorScheme _monochromeScheme(Brightness brightness) =>
      brightness == Brightness.light
      ? const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF2C2C2C),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFDEDEDE),
          onPrimaryContainer: Color(0xFF1A1A1A),
          primaryFixed: Color(0xFFD8D8D8),
          primaryFixedDim: Color(0xFFBCBCBC),
          onPrimaryFixed: Color(0xFF181818),
          onPrimaryFixedVariant: Color(0xFF454545),
          secondary: Color(0xFF555555),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFE2E2E2),
          onSecondaryContainer: Color(0xFF202020),
          secondaryFixed: Color(0xFFDDDDDD),
          secondaryFixedDim: Color(0xFFC1C1C1),
          onSecondaryFixed: Color(0xFF1B1B1B),
          onSecondaryFixedVariant: Color(0xFF484848),
          tertiary: Color(0xFF6A6A6A),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFE5E5E5),
          onTertiaryContainer: Color(0xFF222222),
          tertiaryFixed: Color(0xFFE0E0E0),
          tertiaryFixedDim: Color(0xFFC4C4C4),
          onTertiaryFixed: Color(0xFF1D1D1D),
          onTertiaryFixedVariant: Color(0xFF4A4A4A),
          error: Color(0xFFBA1A1A),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
          surface: Color(0xFFF9F9F9),
          onSurface: Color(0xFF1A1A1A),
          surfaceDim: Color(0xFFD9D9D9),
          surfaceBright: Color(0xFFFDFDFD),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF3F3F3),
          surfaceContainer: Color(0xFFEDEDED),
          surfaceContainerHigh: Color(0xFFE7E7E7),
          surfaceContainerHighest: Color(0xFFE1E1E1),
          onSurfaceVariant: Color(0xFF474747),
          outline: Color(0xFF777777),
          outlineVariant: Color(0xFFC7C7C7),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFF303030),
          onInverseSurface: Color(0xFFF2F2F2),
          inversePrimary: Color(0xFFC6C6C6),
          surfaceTint: Color(0xFF2C2C2C),
        )
      : const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFE1E1E1),
          onPrimary: Color(0xFF292929),
          primaryContainer: Color(0xFF454545),
          onPrimaryContainer: Color(0xFFF5F5F5),
          primaryFixed: Color(0xFFD8D8D8),
          primaryFixedDim: Color(0xFFBCBCBC),
          onPrimaryFixed: Color(0xFF181818),
          onPrimaryFixedVariant: Color(0xFF454545),
          secondary: Color(0xFFC8C8C8),
          onSecondary: Color(0xFF303030),
          secondaryContainer: Color(0xFF484848),
          onSecondaryContainer: Color(0xFFE8E8E8),
          secondaryFixed: Color(0xFFDDDDDD),
          secondaryFixedDim: Color(0xFFC1C1C1),
          onSecondaryFixed: Color(0xFF1B1B1B),
          onSecondaryFixedVariant: Color(0xFF484848),
          tertiary: Color(0xFFBDBDBD),
          onTertiary: Color(0xFF292929),
          tertiaryContainer: Color(0xFF4A4A4A),
          onTertiaryContainer: Color(0xFFEAEAEA),
          tertiaryFixed: Color(0xFFE0E0E0),
          tertiaryFixedDim: Color(0xFFC4C4C4),
          onTertiaryFixed: Color(0xFF1D1D1D),
          onTertiaryFixedVariant: Color(0xFF4A4A4A),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
          errorContainer: Color(0xFF93000A),
          onErrorContainer: Color(0xFFFFDAD6),
          surface: Color(0xFF111111),
          onSurface: Color(0xFFE6E6E6),
          surfaceDim: Color(0xFF111111),
          surfaceBright: Color(0xFF383838),
          surfaceContainerLowest: Color(0xFF0C0C0C),
          surfaceContainerLow: Color(0xFF1A1A1A),
          surfaceContainer: Color(0xFF1E1E1E),
          surfaceContainerHigh: Color(0xFF292929),
          surfaceContainerHighest: Color(0xFF343434),
          onSurfaceVariant: Color(0xFFC7C7C7),
          outline: Color(0xFF919191),
          outlineVariant: Color(0xFF474747),
          shadow: Color(0xFF000000),
          scrim: Color(0xFF000000),
          inverseSurface: Color(0xFFE6E6E6),
          onInverseSurface: Color(0xFF303030),
          inversePrimary: Color(0xFF5D5D5D),
          surfaceTint: Color(0xFFE1E1E1),
        );
}
