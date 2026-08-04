import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/domain/bundesland.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/selection_card.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.lidTrainingSetupTitle)),
      body: ResponsiveContent(
        child: settings == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: AppSpacing.pageInsets,
                children: [
                  Text(
                    context.l10n.lidFederalState,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: settings.bundesland,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelText: context.l10n.lidSelectFederalState,
                    ),
                    items: [
                      for (final state in bundeslaender)
                        DropdownMenuItem(
                          value: state.code,
                          child: Text(state.name),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        unawaited(
                          ref
                              .read(settingsProvider.notifier)
                              .setBundesland(value),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  Text(
                    context.l10n.lidMode,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Column(
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
                      const SizedBox(height: AppSpacing.sm),
                      SelectionCard(
                        title: context.l10n.lidExamSimulation,
                        subtitle: context.l10n.lidExamSimulationDescription,
                        selected: _mode == _TrainingMode.exam,
                        onTap: () => setState(() => _mode = _TrainingMode.exam),
                        leading: Icons.assignment_outlined,
                      ),
                      const SizedBox(height: AppSpacing.sm),
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
      ),
      bottomNavigationBar: BottomActionButton(
        label: _mode == _TrainingMode.exam
            ? context.l10n.lidStartExam
            : context.l10n.startTraining,
        onPressed: settings == null
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
      ),
    );
  }
}
