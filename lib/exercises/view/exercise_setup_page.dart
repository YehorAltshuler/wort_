import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';

class ExerciseSetupPage extends StatefulWidget {
  const ExerciseSetupPage({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  State<ExerciseSetupPage> createState() => _ExerciseSetupPageState();
}

class _ExerciseSetupPageState extends State<ExerciseSetupPage> {
  String _difficulty = 'easy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sessionSetupTitle)),
      body: ListView(
        padding: AppSpacing.pageInsets,
        children: [
          Text(
            context.l10n.difficultyTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          RadioGroup<String>(
            groupValue: _difficulty,
            onChanged: (value) => setState(() => _difficulty = value!),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'easy',
                  title: Text(context.l10n.difficultyEasy),
                  subtitle: Text(context.l10n.fixedPrepositionEasyDescription),
                ),
                RadioListTile<String>(
                  value: 'hard',
                  title: Text(context.l10n.difficultyHard),
                  subtitle: Text(context.l10n.fixedPrepositionHardDescription),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.startSession,
        onPressed: () => context.pushReplacement(
          AppRoute.exerciseTraining(
            widget.exerciseId,
            difficulty: _difficulty,
          ),
        ),
      ),
    );
  }
}
