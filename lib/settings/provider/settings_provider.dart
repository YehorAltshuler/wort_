import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';

final AsyncNotifierProvider<SettingsNotifier, AppSettings> settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() {
    final systemLanguage = AppLanguage.fromCode(
      PlatformDispatcher.instance.locale.languageCode,
    );
    return ref
        .read(settingsRepositoryProvider)
        .load(fallbackLanguage: systemLanguage);
  }

  Future<void> setLanguage(AppLanguage language) async {
    final current = state.value;
    if (current == null || current.language == language) return;
    state = AsyncData(current.copyWith(language: language));
    try {
      await ref.read(settingsRepositoryProvider).setLanguage(language);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> setNativeLanguage(NativeLanguage language) async {
    final current = state.value;
    if (current == null || current.nativeLanguage == language) return;
    state = AsyncData(current.copyWith(nativeLanguage: language));
    try {
      await ref.read(settingsRepositoryProvider).setNativeLanguage(language);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> setTheme(ThemePreference theme) async {
    final current = state.value;
    if (current == null || current.theme == theme) return;
    state = AsyncData(current.copyWith(theme: theme));
    try {
      await ref.read(settingsRepositoryProvider).setTheme(theme);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> setPalette(ColorPalette palette) async {
    final current = state.value;
    if (current == null || current.palette == palette) return;
    state = AsyncData(current.copyWith(palette: palette));
    try {
      await ref.read(settingsRepositoryProvider).setPalette(palette);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> setNounIndicator(NounIndicatorVersion version) async {
    final current = state.value;
    if (current == null || current.nounIndicator == version) return;
    state = AsyncData(current.copyWith(nounIndicator: version));
    try {
      await ref.read(settingsRepositoryProvider).setNounIndicator(version);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> setBundesland(String code) async {
    final current = state.value;
    if (current == null || current.bundesland == code) return;
    state = AsyncData(current.copyWith(bundesland: code));
    try {
      await ref.read(settingsRepositoryProvider).setBundesland(code);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> setTextSize(TextSizePreference textSize) async {
    final current = state.value;
    if (current == null || current.textSize == textSize) return;
    state = AsyncData(current.copyWith(textSize: textSize));
    try {
      await ref.read(settingsRepositoryProvider).setTextSize(textSize);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
