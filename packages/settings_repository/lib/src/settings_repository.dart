import 'package:preferences_client/preferences_client.dart';
import 'package:settings_repository/src/app_language.dart';
import 'package:settings_repository/src/app_settings.dart';
import 'package:settings_repository/src/color_palette.dart';
import 'package:settings_repository/src/noun_indicator_version.dart';
import 'package:settings_repository/src/text_size_preference.dart';
import 'package:settings_repository/src/theme_preference.dart';

class SettingsRepository {
  const SettingsRepository({required PreferencesClient client})
    : _client = client;

  static const _languageKey = 'appLanguage';
  static const _themeKey = 'themePreference';
  static const _paletteKey = 'colorPalette';
  static const _nounIndicatorKey = 'nounIndicatorVersion';
  static const _bundeslandKey = 'citizenshipTestBundesland';
  static const _textSizeKey = 'textSizePreference';

  final PreferencesClient _client;

  Future<AppSettings> load({required AppLanguage fallbackLanguage}) async {
    final values = await Future.wait([
      _client.readString(_languageKey),
      _client.readString(_themeKey),
      _client.readString(_paletteKey),
      _client.readString(_nounIndicatorKey),
      _client.readString(_bundeslandKey),
      _client.readString(_textSizeKey),
    ]);
    return AppSettings(
      language: values[0] == null
          ? fallbackLanguage
          : AppLanguage.fromCode(values[0]),
      theme: _themeFromName(values[1]),
      palette: _paletteFromName(values[2]),
      nounIndicator: _nounIndicatorFromName(values[3]),
      bundesland: values[4] ?? 'BE',
      textSize: _textSizeFromName(values[5]),
    );
  }

  Future<void> setLanguage(AppLanguage language) {
    return _client.writeString(_languageKey, language.code);
  }

  Future<void> setTheme(ThemePreference theme) {
    return _client.writeString(_themeKey, theme.name);
  }

  Future<void> setPalette(ColorPalette palette) {
    return _client.writeString(_paletteKey, palette.name);
  }

  Future<void> setNounIndicator(NounIndicatorVersion version) {
    return _client.writeString(_nounIndicatorKey, version.name);
  }

  Future<void> setBundesland(String code) {
    return _client.writeString(_bundeslandKey, code);
  }

  Future<void> setTextSize(TextSizePreference textSize) {
    return _client.writeString(_textSizeKey, textSize.name);
  }

  static ThemePreference _themeFromName(String? value) => switch (value) {
    'light' => ThemePreference.light,
    'dark' => ThemePreference.dark,
    _ => ThemePreference.system,
  };

  static ColorPalette _paletteFromName(String? value) => switch (value) {
    'azure' => ColorPalette.azure,
    'lime' => ColorPalette.lime,
    'monochrome' => ColorPalette.monochrome,
    _ => ColorPalette.pink,
  };

  static NounIndicatorVersion _nounIndicatorFromName(String? value) =>
      value == 'v1' ? NounIndicatorVersion.v1 : NounIndicatorVersion.v2;

  static TextSizePreference _textSizeFromName(String? value) => switch (value) {
    'large' => TextSizePreference.large,
    'extraLarge' => TextSizePreference.extraLarge,
    _ => TextSizePreference.standard,
  };
}
