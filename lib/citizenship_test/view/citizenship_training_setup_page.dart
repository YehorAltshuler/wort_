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
                      border: const OutlineInputBorder(),
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
                  RadioGroup<_TrainingMode>(
                    groupValue: _mode,
                    onChanged: (value) => setState(() => _mode = value!),
                    child: Column(
                      children: [
                        RadioListTile<_TrainingMode>(
                          value: _TrainingMode.sequential,
                          title: Text(context.l10n.lidSequentialMode),
                          subtitle: Text(
                            context.l10n.lidSequentialModeDescription,
                          ),
                        ),
                        RadioListTile<_TrainingMode>(
                          value: _TrainingMode.exam,
                          title: Text(context.l10n.lidExamSimulation),
                          subtitle: Text(
                            context.l10n.lidExamSimulationDescription,
                          ),
                        ),
                        RadioListTile<_TrainingMode>(
                          value: _TrainingMode.favorites,
                          enabled: hasFavorites,
                          title: Text(context.l10n.lidFavoritesMode),
                          subtitle: Text(
                            hasFavorites
                                ? context.l10n.lidFavoritesModeDescription
                                : context.l10n.lidAddFavoritesFirst,
                          ),
                        ),
                      ],
                    ),
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
