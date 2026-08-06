import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/l10n/native_language_scope.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/async_value_view.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_statistics_view.dart';

class ExerciseWordsPage extends ConsumerWidget {
  const ExerciseWordsPage({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = ref.watch(fixedPrepositionExerciseProvider);
    final progress = ref.watch(learningProgressProvider);
    final ready = exercise.hasValue && progress.hasValue;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.learningProgress)),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: exercise,
          errorMessage: context.l10n.courseLoadError,
          data: (value) => AsyncValueView(
            value: progress,
            errorMessage: context.l10n.courseLoadError,
            data: (records) => _ExerciseOverview(
              exercise: value,
              progress: records,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.configureTraining,
        onPressed: ready
            ? () => context.push(
                AppRoute.exerciseSetup(
                  exerciseId,
                  filter: FixedPrepositionFilter.all.name,
                ),
              )
            : null,
      ),
    );
  }
}

class ExerciseWordListPage extends ConsumerWidget {
  const ExerciseWordListPage({required this.filter, super.key});

  final String filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = FixedPrepositionFilterX.fromName(filter);
    final exercise = ref.watch(fixedPrepositionExerciseProvider);
    final progress =
        ref.watch(learningProgressProvider).value ?? const LearningProgress();
    return Scaffold(
      appBar: AppBar(title: Text(_filterLabel(context, selectedFilter))),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: exercise,
          errorMessage: context.l10n.courseLoadError,
          data: (value) => _ExerciseWordList(
            exercise: value,
            words: _filterExerciseWords(value.words, selectedFilter, progress),
          ),
        ),
      ),
    );
  }

  String _filterLabel(
    BuildContext context,
    FixedPrepositionFilter value,
  ) => switch (value) {
    FixedPrepositionFilter.all => 'Verben mit festen Präpositionen',
    FixedPrepositionFilter.correct => context.l10n.lidCorrectAnswers,
    FixedPrepositionFilter.incorrect => context.l10n.lidIncorrect,
  };
}

class _ExerciseOverview extends StatelessWidget {
  const _ExerciseOverview({
    required this.exercise,
    required this.progress,
  });

  final FixedPrepositionExercise exercise;
  final LearningProgress progress;

  @override
  Widget build(BuildContext context) {
    final correct = progress.testedCount(
      exercise.words.map((word) => word.progressId),
    );
    final incorrect = progress.incorrectCount(
      exercise.words.map((word) => word.progressId),
    );
    final total = exercise.words.length;
    final answered = correct + incorrect;
    return TrainingStatisticsView(
      title: exercise.catalog.title,
      total: total,
      answered: answered,
      correct: correct,
      incorrect: incorrect,
      keyPrefix: 'exercise',
    );
  }
}

List<FixedPrepositionVerb> _filterExerciseWords(
  List<FixedPrepositionVerb> words,
  FixedPrepositionFilter filter,
  LearningProgress progress,
) => switch (filter) {
  FixedPrepositionFilter.all => words,
  FixedPrepositionFilter.correct =>
    words.where((word) => progress.isTested(word.progressId)).toList(),
  FixedPrepositionFilter.incorrect =>
    words.where((word) => progress.isIncorrect(word.progressId)).toList(),
};

class _ExerciseWordList extends StatelessWidget {
  const _ExerciseWordList({required this.exercise, required this.words});

  final FixedPrepositionExercise exercise;
  final List<FixedPrepositionVerb> words;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.nativeLanguageCode;
    return ListView.separated(
      padding: ResponsiveContent.insets(
        context,
        const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
      ),
      itemCount: words.length + 1,
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
                Text('${words.length} ${context.l10n.wordsCount}'),
              ],
            ),
          );
        }
        final word = words[index - 1];
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
              Text(word.example, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      },
    );
  }
}
