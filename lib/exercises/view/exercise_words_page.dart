import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';

class ExerciseWordsPage extends ConsumerWidget {
  const ExerciseWordsPage({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = ref.watch(fixedPrepositionExerciseProvider);
    return Scaffold(
      appBar: AppBar(),
      body: exercise.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(context.l10n.courseLoadError),
        ),
        data: (value) => _ExerciseWordList(exercise: value),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.startKnowledgeCheck,
        onPressed: () => context.push(AppRoute.exerciseSetup(exerciseId)),
      ),
    );
  }
}

class _ExerciseWordList extends StatelessWidget {
  const _ExerciseWordList({required this.exercise});

  final FixedPrepositionExercise exercise;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      itemCount: exercise.words.length + 1,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.catalog.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text('${exercise.words.length} ${context.l10n.wordsCount}'),
              ],
            ),
          );
        }
        final word = exercise.words[index - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                word.pattern,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(word.translationFor(languageCode)),
              const SizedBox(height: 4),
              Text(
                word.example,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
