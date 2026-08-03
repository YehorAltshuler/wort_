import 'package:settings_repository/src/app_language.dart';
import 'package:settings_repository/src/color_palette.dart';
import 'package:settings_repository/src/noun_indicator_version.dart';
import 'package:settings_repository/src/theme_preference.dart';

class AppSettings {
  const AppSettings({
    required this.language,
    required this.theme,
    this.palette = ColorPalette.pink,
    this.nounIndicator = NounIndicatorVersion.v2,
    this.bundesland = 'BE',
  });

  final AppLanguage language;
  final ThemePreference theme;
  final ColorPalette palette;
  final NounIndicatorVersion nounIndicator;
  final String bundesland;

  AppSettings copyWith({
    AppLanguage? language,
    ThemePreference? theme,
    ColorPalette? palette,
    NounIndicatorVersion? nounIndicator,
    String? bundesland,
  }) {
    return AppSettings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      palette: palette ?? this.palette,
      nounIndicator: nounIndicator ?? this.nounIndicator,
      bundesland: bundesland ?? this.bundesland,
    );
  }
}
