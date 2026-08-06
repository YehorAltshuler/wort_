import 'package:flutter/material.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/platform/apk_download.dart';
import 'package:wort_flutter/settings/widgets/noun_indicator.dart';
import 'package:wort_flutter/settings/widgets/settings_section.dart';
import 'package:wort_flutter/widgets/selection_bottom_sheet.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({
    required this.settings,
    required this.onLanguageChanged,
    required this.onNativeLanguageChanged,
    super.key,
  });

  final AppSettings settings;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<NativeLanguage> onNativeLanguageChanged;

  @override
  Widget build(BuildContext context) => SettingsSection(
    title: context.l10n.generalSettingsSection,
    children: [
      SettingsRow(
        icon: Icons.language,
        title: context.l10n.languageTitle,
        subtitle: Text(_languageLabel(context, settings.language)),
        onTap: () async {
          final value = await _selectOption(
            context,
            context.l10n.languageTitle,
            AppLanguage.values,
            (value) => _languageLabel(context, value),
            settings.language,
          );
          if (value != null) onLanguageChanged(value);
        },
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
      SettingsRow(
        icon: Icons.translate_rounded,
        title: context.l10n.nativeLanguageTitle,
        subtitle: Text(
          _nativeLanguageLabel(context, settings.nativeLanguage),
        ),
        onTap: () async {
          final value = await _selectOption(
            context,
            context.l10n.nativeLanguageTitle,
            NativeLanguage.values,
            (value) => _nativeLanguageLabel(context, value),
            settings.nativeLanguage,
          );
          if (value != null) onNativeLanguageChanged(value);
        },
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
      if (supportsApkDownload)
        SettingsRow(
          icon: Icons.android,
          title: context.l10n.downloadAndroidTitle,
          subtitle: Text(context.l10n.downloadAndroidSubtitle),
          onTap: downloadApk,
          trailing: const Icon(Icons.open_in_new_rounded),
        ),
    ],
  );
}

class AppearanceSettingsSection extends StatelessWidget {
  const AppearanceSettingsSection({
    required this.settings,
    required this.onPaletteChanged,
    required this.onThemeChanged,
    required this.onTextSizeChanged,
    required this.onNounIndicatorChanged,
    super.key,
  });

  final AppSettings settings;
  final ValueChanged<ColorPalette> onPaletteChanged;
  final ValueChanged<ThemePreference> onThemeChanged;
  final ValueChanged<TextSizePreference> onTextSizeChanged;
  final ValueChanged<NounIndicatorVersion> onNounIndicatorChanged;

  @override
  Widget build(BuildContext context) => SettingsSection(
    title: context.l10n.appearanceSettingsSection,
    children: [
      SettingsRow(
        icon: Icons.palette_outlined,
        iconColor: _paletteColor(settings.palette),
        title: context.l10n.paletteTitle,
        subtitle: Text(_paletteLabel(context, settings.palette)),
        onTap: () async {
          final value = await _selectOption(
            context,
            context.l10n.paletteTitle,
            ColorPalette.values,
            (value) => _paletteLabel(context, value),
            settings.palette,
          );
          if (value != null) onPaletteChanged(value);
        },
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
      SettingsRow(
        icon: Icons.contrast,
        title: context.l10n.themeTitle,
        subtitle: Text(_themeLabel(context, settings.theme)),
        onTap: () async {
          final value = await _selectOption(
            context,
            context.l10n.themeTitle,
            ThemePreference.values,
            (value) => _themeLabel(context, value),
            settings.theme,
          );
          if (value != null) onThemeChanged(value);
        },
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
      SettingsRow(
        icon: Icons.format_size_rounded,
        title: context.l10n.textSizeTitle,
        subtitle: Text(_textSizeLabel(context, settings.textSize)),
        onTap: () async {
          final value = await _selectOption(
            context,
            context.l10n.textSizeTitle,
            TextSizePreference.values,
            (value) => _textSizeLabel(context, value),
            settings.textSize,
          );
          if (value != null) onTextSizeChanged(value);
        },
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
      SettingsRow(
        icon: Icons.article_outlined,
        title: context.l10n.nounIndicatorTitle,
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: NounIndicator(articles: ['die']),
        ),
        onTap: () async {
          final value = await _selectOption(
            context,
            context.l10n.nounIndicatorTitle,
            NounIndicatorVersion.values,
            (value) => _nounIndicatorLabel(context, value),
            settings.nounIndicator,
          );
          if (value != null) onNounIndicatorChanged(value);
        },
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    ],
  );
}

class ContentSettingsSection extends StatelessWidget {
  const ContentSettingsSection({
    required this.status,
    required this.onCatalogTap,
    super.key,
  });

  final String status;
  final VoidCallback onCatalogTap;

  @override
  Widget build(BuildContext context) => SettingsSection(
    title: context.l10n.contentSettingsSection,
    children: [
      SettingsRow(
        icon: Icons.cloud_sync_outlined,
        title: context.l10n.contentCatalogTitle,
        subtitle: Text(status),
        onTap: onCatalogTap,
      ),
    ],
  );
}

class LidSettingsSection extends StatelessWidget {
  const LidSettingsSection({
    required this.catalogStatus,
    required this.onCatalogTap,
    required this.onResetProgress,
    super.key,
  });

  final String catalogStatus;
  final VoidCallback onCatalogTap;
  final VoidCallback onResetProgress;

  @override
  Widget build(BuildContext context) => SettingsSection(
    title: context.l10n.lidSettingsSection,
    children: [
      SettingsRow(
        icon: Icons.cloud_sync_outlined,
        title: context.l10n.lidCatalogTitle,
        subtitle: Text(catalogStatus),
        onTap: onCatalogTap,
      ),
      SettingsRow(
        icon: Icons.restart_alt,
        title: context.l10n.lidResetProgress,
        subtitle: Text(context.l10n.lidResetProgressMessage),
        onTap: onResetProgress,
      ),
    ],
  );
}

Future<T?> _selectOption<T>(
  BuildContext context,
  String title,
  List<T> values,
  String Function(T value) label,
  T selectedValue,
) => showSelectionBottomSheet<T>(
  context: context,
  title: title,
  values: values,
  label: label,
  selectedValue: selectedValue,
);

String _languageLabel(BuildContext context, AppLanguage language) =>
    switch (language) {
      AppLanguage.russian => context.l10n.languageRussian,
      AppLanguage.english => context.l10n.languageEnglish,
      AppLanguage.german => context.l10n.languageGerman,
      AppLanguage.arabic => context.l10n.languageArabic,
    };

String _nativeLanguageLabel(BuildContext context, NativeLanguage language) =>
    switch (language) {
      NativeLanguage.russian => context.l10n.languageRussian,
      NativeLanguage.english => context.l10n.languageEnglish,
      NativeLanguage.arabic => context.l10n.languageArabic,
    };

String _themeLabel(BuildContext context, ThemePreference theme) =>
    switch (theme) {
      ThemePreference.system => context.l10n.themeSystem,
      ThemePreference.light => context.l10n.themeLight,
      ThemePreference.dark => context.l10n.themeDark,
    };

String _textSizeLabel(
  BuildContext context,
  TextSizePreference preference,
) => switch (preference) {
  TextSizePreference.standard => context.l10n.textSizeStandard,
  TextSizePreference.large => context.l10n.textSizeLarge,
  TextSizePreference.extraLarge => context.l10n.textSizeExtraLarge,
};

String _paletteLabel(BuildContext context, ColorPalette palette) =>
    switch (palette) {
      ColorPalette.pink => context.l10n.palettePink,
      ColorPalette.azure => context.l10n.paletteAzure,
      ColorPalette.lime => context.l10n.paletteLime,
      ColorPalette.monochrome => context.l10n.paletteMonochrome,
    };

String _nounIndicatorLabel(
  BuildContext context,
  NounIndicatorVersion version,
) => switch (version) {
  NounIndicatorVersion.v1 => context.l10n.nounIndicatorV1,
  NounIndicatorVersion.v2 => context.l10n.nounIndicatorV2,
};

Color _paletteColor(ColorPalette palette) => switch (palette) {
  ColorPalette.pink => const Color(0xFFC8409A),
  ColorPalette.azure => const Color(0xFF278ED6),
  ColorPalette.lime => const Color(0xFF84B82B),
  ColorPalette.monochrome => const Color(0xFF555555),
};
