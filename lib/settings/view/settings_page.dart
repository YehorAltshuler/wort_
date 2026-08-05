import 'dart:async';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/content/content_provider.dart';
import 'package:wort_flutter/content/content_repository.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/platform/apk_download.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/settings/widgets/noun_indicator.dart';
import 'package:wort_flutter/settings/widgets/settings_section.dart';
import 'package:wort_flutter/settings/widgets/sync_catalog_dialog.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/selection_bottom_sheet.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final questions = ref.watch(citizenshipQuestionsProvider);
    final metadataState = ref.watch(citizenshipSyncMetadataProvider);
    final metadata = metadataState.value;
    final metadataError = metadataState.hasError ? metadataState.error : null;
    final sync = ref.watch(citizenshipSyncControllerProvider);
    final contentMetadataState = ref.watch(contentMetadataProvider);
    final contentMetadata = contentMetadataState.value;
    final contentSync = ref.watch(contentSyncControllerProvider);
    if (settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: AppSpacing.pageInsets,
      children: [
        SettingsSection(
          title: context.l10n.generalSettingsSection,
          children: [
            SettingsRow(
              icon: Icons.language,
              title: context.l10n.languageTitle,
              subtitle: Text(_languageLabel(context, settings.language)),
              onTap: () async {
                final language = await _selectOption(
                  context,
                  context.l10n.languageTitle,
                  AppLanguage.values,
                  (value) => _languageLabel(context, value),
                  settings.language,
                );
                if (language != null) {
                  await ref
                      .read(settingsProvider.notifier)
                      .setLanguage(language);
                }
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
        ),
        const SizedBox(height: AppSpacing.xxl),
        SettingsSection(
          title: context.l10n.appearanceSettingsSection,
          children: [
            SettingsRow(
              icon: Icons.palette_outlined,
              iconColor: _paletteColor(settings.palette),
              title: context.l10n.paletteTitle,
              subtitle: Text(_paletteLabel(context, settings.palette)),
              onTap: () async {
                final palette = await _selectOption(
                  context,
                  context.l10n.paletteTitle,
                  ColorPalette.values,
                  (value) => _paletteLabel(context, value),
                  settings.palette,
                );
                if (palette != null) {
                  await ref.read(settingsProvider.notifier).setPalette(palette);
                }
              },
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            SettingsRow(
              icon: Icons.contrast,
              title: context.l10n.themeTitle,
              subtitle: Text(_themeLabel(context, settings.theme)),
              onTap: () async {
                final theme = await _selectOption(
                  context,
                  context.l10n.themeTitle,
                  ThemePreference.values,
                  (value) => _themeLabel(context, value),
                  settings.theme,
                );
                if (theme != null) {
                  await ref.read(settingsProvider.notifier).setTheme(theme);
                }
              },
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            SettingsRow(
              icon: Icons.format_size_rounded,
              title: context.l10n.textSizeTitle,
              subtitle: Text(_textSizeLabel(context, settings.textSize)),
              onTap: () async {
                final textSize = await _selectOption(
                  context,
                  context.l10n.textSizeTitle,
                  TextSizePreference.values,
                  (value) => _textSizeLabel(context, value),
                  settings.textSize,
                );
                if (textSize != null) {
                  await ref
                      .read(settingsProvider.notifier)
                      .setTextSize(textSize);
                }
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
                final version = await _selectOption(
                  context,
                  context.l10n.nounIndicatorTitle,
                  NounIndicatorVersion.values,
                  (value) => _nounIndicatorLabel(context, value),
                  settings.nounIndicator,
                );
                if (version != null) {
                  await ref
                      .read(settingsProvider.notifier)
                      .setNounIndicator(version);
                }
              },
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        SettingsSection(
          title: context.l10n.contentSettingsSection,
          children: [
            SettingsRow(
              icon: Icons.cloud_sync_outlined,
              title: context.l10n.contentCatalogTitle,
              subtitle: Text(
                _contentCatalogStatus(
                  context,
                  metadata: contentMetadata,
                  metadataError: contentMetadataState.hasError
                      ? contentMetadataState.error
                      : null,
                  checking: contentSync.isLoading,
                ),
              ),
              onTap: () => _showContentCatalogDialog(context, ref),
              trailing: contentSync.isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        SettingsSection(
          title: context.l10n.lidSettingsSection,
          children: [
            SettingsRow(
              icon: Icons.sync,
              title: context.l10n.lidCatalogTitle,
              subtitle: Text(
                _catalogStatus(
                  context,
                  metadata: metadata,
                  metadataError: metadataError,
                  checking: sync.isLoading,
                ),
              ),
              onTap: () => _showCatalogDialog(
                context,
                ref,
                questionCount:
                    metadata?.questionCount ?? questions.value?.length ?? 0,
              ),
              trailing: sync.isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
            ),
            SettingsRow(
              icon: Icons.restart_alt,
              title: context.l10n.lidResetProgress,
              subtitle: Text(context.l10n.lidResetProgressMessage),
              onTap: () => _resetCitizenshipProgress(context, ref),
              trailing: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  String _languageLabel(BuildContext context, AppLanguage language) {
    return switch (language) {
      AppLanguage.russian => context.l10n.languageRussian,
      AppLanguage.english => context.l10n.languageEnglish,
      AppLanguage.arabic => context.l10n.languageArabic,
    };
  }

  Future<T?> _selectOption<T>(
    BuildContext context,
    String title,
    List<T> values,
    String Function(T value) label,
    T selectedValue,
  ) {
    return showSelectionBottomSheet<T>(
      context: context,
      title: title,
      values: values,
      label: label,
      selectedValue: selectedValue,
    );
  }

  String _themeLabel(BuildContext context, ThemePreference theme) {
    return switch (theme) {
      ThemePreference.system => context.l10n.themeSystem,
      ThemePreference.light => context.l10n.themeLight,
      ThemePreference.dark => context.l10n.themeDark,
    };
  }

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

  String _date(DateTime? value) =>
      value == null ? '—' : DateFormat.yMd().add_Hm().format(value.toLocal());

  String _catalogStatus(
    BuildContext context, {
    required SyncMetadataRecord? metadata,
    required bool checking,
    Object? metadataError,
  }) {
    if (checking) return context.l10n.lidCatalogChecking;
    if (metadataError != null || metadata?.lastError != null) {
      return context.l10n.lidCatalogCheckFailed;
    }
    final checkedAt = metadata?.lastSuccessfulCheckAt;
    if (checkedAt == null) {
      return metadata?.lastSuccessfulUpdateAt == null
          ? context.l10n.lidCatalogStatusUnknown
          : context.l10n.lidCatalogInstalledNotChecked;
    }
    if (DateTime.now().difference(checkedAt) <=
        CitizenshipTestRepository.refreshInterval) {
      return context.l10n.lidCatalogUpToDate;
    }
    return context.l10n.lidCatalogCheckRecommended;
  }

  String _contentCatalogStatus(
    BuildContext context, {
    required ContentSyncMetadata? metadata,
    required bool checking,
    Object? metadataError,
  }) {
    if (checking) return context.l10n.contentCatalogChecking;
    if (metadataError != null || metadata?.lastError != null) {
      return context.l10n.contentCatalogCheckFailed;
    }
    return metadata?.version == null
        ? context.l10n.contentCatalogBundled
        : context.l10n.contentCatalogVersion(metadata!.version!);
  }

  Future<void> _showContentCatalogDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, dialogRef, child) {
          final metadataState = dialogRef.watch(contentMetadataProvider);
          final metadata = metadataState.value;
          final metadataError = metadataState.hasError
              ? metadataState.error
              : null;
          final displayedError =
              metadata?.lastError ?? metadataError?.toString();
          final sync = dialogRef.watch(contentSyncControllerProvider);
          return SyncCatalogDialog(
            title: context.l10n.contentCatalogTitle,
            status: _contentCatalogStatus(
              context,
              metadata: metadata,
              metadataError: metadataError,
              checking: sync.isLoading,
            ),
            details: [
              Text(
                context.l10n.lidCatalogLastChecked(
                  _date(metadata?.lastCheckedAt),
                ),
              ),
              Text(
                context.l10n.lidCatalogLastUpdated(
                  _date(metadata?.lastUpdatedAt),
                ),
              ),
            ],
            isLoading: sync.isLoading,
            cancelLabel: context.l10n.cancel,
            checkLabel: context.l10n.lidCatalogCheckAction,
            errorMessage: context.l10n.contentCatalogCheckError,
            errorDetails: displayedError,
            onCheck: () => _checkContent(context, dialogContext, dialogRef),
          );
        },
      ),
    );
  }

  Future<void> _showCatalogDialog(
    BuildContext context,
    WidgetRef ref, {
    required int questionCount,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, dialogRef, child) {
          final metadataState = dialogRef.watch(
            citizenshipSyncMetadataProvider,
          );
          final metadata = metadataState.value;
          final metadataError = metadataState.hasError
              ? metadataState.error
              : null;
          final displayedError =
              metadata?.lastError ?? metadataError?.toString();
          final sync = dialogRef.watch(citizenshipSyncControllerProvider);
          return SyncCatalogDialog(
            title: context.l10n.lidCatalogTitle,
            status: _catalogStatus(
              context,
              metadata: metadata,
              metadataError: metadataError,
              checking: sync.isLoading,
            ),
            details: [
              Text(
                context.l10n.lidCatalogQuestions(
                  metadata?.questionCount ?? questionCount,
                ),
              ),
              Text(
                context.l10n.lidCatalogLastChecked(
                  _date(metadata?.lastCheckAttemptAt),
                ),
              ),
              Text(
                context.l10n.lidCatalogLastUpdated(
                  _date(metadata?.lastSuccessfulUpdateAt),
                ),
              ),
            ],
            isLoading: sync.isLoading,
            cancelLabel: context.l10n.cancel,
            checkLabel: context.l10n.lidCatalogCheckAction,
            errorMessage: context.l10n.lidCatalogUsingLocal,
            errorDetails: displayedError,
            onCheck: () => _checkCatalog(context, dialogContext, dialogRef),
          );
        },
      ),
    );
  }

  Future<void> _checkCatalog(
    BuildContext pageContext,
    BuildContext dialogContext,
    WidgetRef ref,
  ) async {
    await ref
        .read(citizenshipSyncControllerProvider.notifier)
        .synchronize(manual: true);
    final state = ref.read(citizenshipSyncControllerProvider);
    if (!dialogContext.mounted) return;
    Navigator.pop(dialogContext);
    if (!pageContext.mounted) return;
    final message = state.hasError
        ? pageContext.l10n.lidCatalogCheckError
        : _syncResultMessage(pageContext, state.value);
    ScaffoldMessenger.of(pageContext).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _syncResultMessage(BuildContext context, SyncResult? result) =>
      switch (result?.outcome) {
        SyncOutcome.updated => context.l10n.lidCatalogUpdated,
        SyncOutcome.partiallyUpdated => context.l10n.lidCatalogPartiallyUpdated(
          result!.missingImages,
        ),
        SyncOutcome.notModified => context.l10n.lidCatalogNoChanges,
        SyncOutcome.skipped || null => context.l10n.lidCatalogUpToDate,
      };

  Future<void> _checkContent(
    BuildContext pageContext,
    BuildContext dialogContext,
    WidgetRef ref,
  ) async {
    await ref
        .read(contentSyncControllerProvider.notifier)
        .synchronize(manual: true);
    final state = ref.read(contentSyncControllerProvider);
    if (!dialogContext.mounted) return;
    Navigator.pop(dialogContext);
    if (!pageContext.mounted) return;
    final message = state.hasError
        ? pageContext.l10n.contentCatalogCheckError
        : switch (state.value?.outcome) {
            ContentSyncOutcome.updated =>
              pageContext.l10n.contentCatalogUpdated,
            ContentSyncOutcome.notModified ||
            ContentSyncOutcome.skipped ||
            null => pageContext.l10n.contentCatalogNoChanges,
          };
    ScaffoldMessenger.of(pageContext).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _resetCitizenshipProgress(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.restart_alt),
        title: Text(dialogContext.l10n.lidResetProgressTitle),
        content: Text(dialogContext.l10n.lidResetProgressMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.l10n.lidResetProgress),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(citizenshipTestRepositoryProvider).resetAnswerProgress();
    ref.invalidate(citizenshipProgressProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.lidProgressReset),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
