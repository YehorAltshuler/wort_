import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/domain/bundesland.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/settings/widgets/settings_section.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/selection_bottom_sheet.dart';
import 'package:wort_flutter/widgets/selection_card.dart';
import 'package:wort_flutter/widgets/training_setup_scaffold.dart';

enum _TrainingMode { sequential, exam, favorites }

class CitizenshipTrainingSetupPage extends ConsumerStatefulWidget {
  const CitizenshipTrainingSetupPage({super.key});

  @override
  ConsumerState<CitizenshipTrainingSetupPage> createState() =>
      _CitizenshipTrainingSetupPageState();
}

class _CitizenshipTrainingSetupPageState
    extends ConsumerState<CitizenshipTrainingSetupPage> {
  _TrainingMode _mode = _TrainingMode.sequential;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final progress = ref.watch(citizenshipProgressProvider).value ?? const [];
    final hasFavorites = progress.any((item) => item.isFavorite);
    return TrainingSetupScaffold(
      title: context.l10n.lidTrainingSetupTitle,
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: ResponsiveContent.insets(
                context,
                AppSpacing.pageInsets,
              ),
              children: [
                SettingsSection(
                  title: context.l10n.lidFederalState,
                  children: [
                    SettingsRow(
                      icon: Icons.location_on_outlined,
                      title: context.l10n.lidSelectFederalState,
                      subtitle: Text(
                        bundeslaender
                            .firstWhere(
                              (state) => state.code == settings.bundesland,
                            )
                            .name,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () async {
                        final selected = await showSelectionBottomSheet<String>(
                          context: context,
                          title: context.l10n.lidSelectFederalState,
                          values: [
                            for (final state in bundeslaender) state.code,
                          ],
                          label: (code) => bundeslaender
                              .firstWhere((state) => state.code == code)
                              .name,
                          selectedValue: settings.bundesland,
                        );
                        if (selected != null) {
                          unawaited(
                            ref
                                .read(settingsProvider.notifier)
                                .setBundesland(selected),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SettingsSection(
                  title: context.l10n.lidMode,
                  children: [
                    SelectionCard(
                      title: context.l10n.lidSequentialMode,
                      subtitle: context.l10n.lidSequentialModeDescription,
                      selected: _mode == _TrainingMode.sequential,
                      onTap: () => setState(
                        () => _mode = _TrainingMode.sequential,
                      ),
                      leading: Icons.format_list_numbered_rounded,
                    ),
                    SelectionCard(
                      title: context.l10n.lidExamSimulation,
                      subtitle: context.l10n.lidExamSimulationDescription,
                      selected: _mode == _TrainingMode.exam,
                      onTap: () => setState(() => _mode = _TrainingMode.exam),
                      leading: Icons.assignment_outlined,
                    ),
                    SelectionCard(
                      title: context.l10n.lidFavoritesMode,
                      subtitle: hasFavorites
                          ? context.l10n.lidFavoritesModeDescription
                          : context.l10n.lidAddFavoritesFirst,
                      selected: _mode == _TrainingMode.favorites,
                      enabled: hasFavorites,
                      onTap: () => setState(
                        () => _mode = _TrainingMode.favorites,
                      ),
                      leading: Icons.favorite_outline_rounded,
                    ),
                  ],
                ),
              ],
            ),
      actionLabel: _mode == _TrainingMode.exam
          ? context.l10n.lidStartExam
          : context.l10n.startTraining,
      onAction: settings == null
          ? null
          : () => context.pushReplacement(
              switch (_mode) {
                _TrainingMode.exam =>
                  '${AppRoute.citizenshipExam}?startNew=true',
                _TrainingMode.favorites =>
                  '${AppRoute.citizenshipTraining}'
                      '?filter=favorites&random=false',
                _TrainingMode.sequential =>
                  '${AppRoute.citizenshipTraining}'
                      '?filter=all&random=false&startNew=true',
              },
            ),
    );
  }
}
