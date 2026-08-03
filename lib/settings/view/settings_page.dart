import 'dart:async';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/platform/apk_download.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/settings/widgets/noun_indicator.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/section_header.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final questions = ref.watch(citizenshipQuestionsProvider);
    final metadata = ref.watch(citizenshipSyncMetadataProvider).value;
    final sync = ref.watch(citizenshipSyncControllerProvider);
    if (settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: AppSpacing.pageInsets,
      children: [
        _SettingsSection(
          title: context.l10n.generalSettingsSection,
          children: [
            _SettingsRow(
              icon: Icons.language,
              title: context.l10n.languageTitle,
              subtitle: Text(_languageLabel(context, settings.language)),
              onTap: () async {
                final language = await _selectOption(
                  context,
                  AppLanguage.values,
                  (value) => _languageLabel(context, value),
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
              _SettingsRow(
                icon: Icons.android,
                title: context.l10n.downloadAndroidTitle,
                subtitle: Text(context.l10n.downloadAndroidSubtitle),
                onTap: downloadApk,
                trailing: const Icon(Icons.open_in_new_rounded),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        _SettingsSection(
          title: context.l10n.appearanceSettingsSection,
          children: [
            _SettingsRow(
              icon: Icons.palette_outlined,
              iconColor: _paletteColor(settings.palette),
              title: context.l10n.paletteTitle,
              subtitle: Text(_paletteLabel(context, settings.palette)),
              onTap: () async {
                final palette = await _selectOption(
                  context,
                  ColorPalette.values,
                  (value) => _paletteLabel(context, value),
                );
                if (palette != null) {
                  await ref.read(settingsProvider.notifier).setPalette(palette);
                }
              },
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            _SettingsRow(
              icon: Icons.contrast,
              title: context.l10n.themeTitle,
              subtitle: Text(_themeLabel(context, settings.theme)),
              onTap: () async {
                final theme = await _selectOption(
                  context,
                  ThemePreference.values,
                  (value) => _themeLabel(context, value),
                );
                if (theme != null) {
                  await ref.read(settingsProvider.notifier).setTheme(theme);
                }
              },
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            _SettingsRow(
              icon: Icons.article_outlined,
              title: context.l10n.nounIndicatorTitle,
              subtitle: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: NounIndicator(articles: ['die']),
              ),
              onTap: () async {
                final version = await _selectOption(
                  context,
                  NounIndicatorVersion.values,
                  (value) => _nounIndicatorLabel(context, value),
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
        _SettingsSection(
          title: context.l10n.lidSettingsSection,
          children: [
            _SettingsRow(
              icon: Icons.sync,
              title: context.l10n.lidCatalogTitle,
              subtitle: Text(
                _catalogStatus(
                  context,
                  metadata: metadata,
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
            _SettingsRow(
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
    List<T> values,
    String Function(T value) label,
  ) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final value in values)
              ListTile(
                title: Text(label(value)),
                onTap: () => Navigator.pop(sheetContext, value),
              ),
          ],
        ),
      ),
    );
  }

  String _themeLabel(BuildContext context, ThemePreference theme) {
    return switch (theme) {
      ThemePreference.system => context.l10n.themeSystem,
      ThemePreference.light => context.l10n.themeLight,
      ThemePreference.dark => context.l10n.themeDark,
    };
  }

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
  }) {
    if (checking) return context.l10n.lidCatalogChecking;
    if (metadata?.lastError != null) {
      return context.l10n.lidCatalogCheckFailed;
    }
    final checkedAt = metadata?.lastSuccessfulCheckAt;
    if (checkedAt == null) return context.l10n.lidCatalogStatusUnknown;
    if (DateTime.now().difference(checkedAt) <=
        CitizenshipTestRepository.refreshInterval) {
      return context.l10n.lidCatalogUpToDate;
    }
    return context.l10n.lidCatalogCheckRecommended;
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
          final metadata = dialogRef
              .watch(citizenshipSyncMetadataProvider)
              .value;
          final sync = dialogRef.watch(citizenshipSyncControllerProvider);
          return AlertDialog(
            icon: Icon(
              sync.isLoading ? Icons.sync : Icons.cloud_done_outlined,
            ),
            title: Text(context.l10n.lidCatalogTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _catalogStatus(
                    context,
                    metadata: metadata,
                    checking: sync.isLoading,
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.lidCatalogQuestions(
                    metadata?.questionCount ?? questionCount,
                  ),
                ),
                Text(
                  context.l10n.lidCatalogLastChecked(
                    _date(metadata?.lastSuccessfulCheckAt),
                  ),
                ),
                Text(
                  context.l10n.lidCatalogLastUpdated(
                    _date(metadata?.lastSuccessfulUpdateAt),
                  ),
                ),
                if (metadata?.lastError case final error?) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.l10n.lidCatalogUsingLocal,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    error,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (sync.isLoading) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: sync.isLoading
                    ? null
                    : () => Navigator.pop(dialogContext),
                child: Text(context.l10n.cancel),
              ),
              FilledButton.icon(
                onPressed: sync.isLoading
                    ? null
                    : () => _checkCatalog(
                        context,
                        dialogContext,
                        dialogRef,
                      ),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.lidCatalogCheckAction),
              ),
            ],
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

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget subtitle;
  final Widget trailing;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final effectiveColor = iconColor ?? colors.primary;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: effectiveColor),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: DefaultTextStyle(
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: colors.onSurfaceVariant),
        child: subtitle,
      ),
      trailing: trailing,
    );
  }
}
