import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/widgets/settings_section.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/selection_card.dart';
import 'package:wort_flutter/widgets/training_setup_scaffold.dart';

class ExerciseSetupPage extends StatefulWidget {
  const ExerciseSetupPage({
    required this.exerciseId,
    required this.initialFilter,
    super.key,
  });

  final String exerciseId;
  final String initialFilter;

  @override
  State<ExerciseSetupPage> createState() => _ExerciseSetupPageState();
}

class _ExerciseSetupPageState extends State<ExerciseSetupPage> {
  String _difficulty = 'easy';

  @override
  Widget build(BuildContext context) {
    return TrainingSetupScaffold(
      title: context.l10n.sessionSetupTitle,
      body: ListView(
        padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
        children: [
          SettingsSection(
            title: context.l10n.difficultyTitle,
            children: [
              SelectionCard(
                title: context.l10n.difficultyEasy,
                subtitle: context.l10n.fixedPrepositionEasyDescription,
                selected: _difficulty == 'easy',
                onTap: () => setState(() => _difficulty = 'easy'),
                leading: Icons.sentiment_satisfied_alt_outlined,
              ),
              SelectionCard(
                title: context.l10n.difficultyHard,
                subtitle: context.l10n.fixedPrepositionHardDescription,
                selected: _difficulty == 'hard',
                onTap: () => setState(() => _difficulty = 'hard'),
                leading: Icons.local_fire_department_outlined,
              ),
            ],
          ),
        ],
      ),
      actionLabel: context.l10n.startSession,
      onAction: () => context.pushReplacement(
        AppRoute.exerciseTraining(
          widget.exerciseId,
          difficulty: _difficulty,
          filter: widget.initialFilter,
        ),
      ),
    );
  }
}
