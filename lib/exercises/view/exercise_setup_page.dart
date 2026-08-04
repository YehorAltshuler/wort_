import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/selection_card.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sessionSetupTitle)),
      body: ResponsiveContent(
        child: ListView(
          padding: AppSpacing.pageInsets,
          children: [
            Text(
              context.l10n.difficultyTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SelectionCard(
              title: context.l10n.difficultyEasy,
              subtitle: context.l10n.fixedPrepositionEasyDescription,
              selected: _difficulty == 'easy',
              onTap: () => setState(() => _difficulty = 'easy'),
              leading: Icons.sentiment_satisfied_alt_outlined,
            ),
            const SizedBox(height: AppSpacing.sm),
            SelectionCard(
              title: context.l10n.difficultyHard,
              subtitle: context.l10n.fixedPrepositionHardDescription,
              selected: _difficulty == 'hard',
              onTap: () => setState(() => _difficulty = 'hard'),
              leading: Icons.local_fire_department_outlined,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.startSession,
        onPressed: () => context.pushReplacement(
          AppRoute.exerciseTraining(
            widget.exerciseId,
            difficulty: _difficulty,
            filter: widget.initialFilter,
          ),
        ),
      ),
    );
  }
}
