import 'dart:async';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/content/content_provider.dart';
import 'package:wort_flutter/content/content_repository.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/settings/widgets/settings_page_sections.dart';
import 'package:wort_flutter/settings/widgets/sync_catalog_dialog.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

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
      padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
      children: [
        GeneralSettingsSection(
          settings: settings,
          onLanguageChanged: (language) =>
              ref.read(settingsProvider.notifier).setLanguage(language),
          onNativeLanguageChanged: (language) =>
              ref.read(settingsProvider.notifier).setNativeLanguage(language),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppearanceSettingsSection(
          settings: settings,
          onPaletteChanged: (palette) =>
              ref.read(settingsProvider.notifier).setPalette(palette),
          onThemeChanged: (theme) =>
              ref.read(settingsProvider.notifier).setTheme(theme),
          onTextSizeChanged: (textSize) =>
              ref.read(settingsProvider.notifier).setTextSize(textSize),
          onNounIndicatorChanged: (version) =>
              ref.read(settingsProvider.notifier).setNounIndicator(version),
        ),
        const SizedBox(height: AppSpacing.xxl),
        ContentSettingsSection(
          status: _contentCatalogStatus(
            context,
            metadata: contentMetadata,
            metadataError: contentMetadataState.hasError
                ? contentMetadataState.error
                : null,
            checking: contentSync.isLoading,
          ),
          onCatalogTap: () => _showContentCatalogDialog(context, ref),
        ),
        const SizedBox(height: AppSpacing.xxl),
        LidSettingsSection(
          catalogStatus: _catalogStatus(
            context,
            metadata: metadata,
            metadataError: metadataError,
            checking: sync.isLoading,
          ),
          onCatalogTap: () => _showCatalogDialog(
            context,
            ref,
            questionCount:
                metadata?.questionCount ?? questions.value?.length ?? 0,
          ),
          onResetProgress: () => _resetCitizenshipProgress(context, ref),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

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
