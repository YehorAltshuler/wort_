import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/adaptive_stat_card_row.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/overall_progress_card.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class ExerciseWordsPage extends ConsumerStatefulWidget {
  const ExerciseWordsPage({required this.exerciseId, super.key});

  final String exerciseId;

  @override
  ConsumerState<ExerciseWordsPage> createState() => _ExerciseWordsPageState();
}

class _ExerciseWordsPageState extends ConsumerState<ExerciseWordsPage> {
  FixedPrepositionFilter _selectedFilter = FixedPrepositionFilter.all;

  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(fixedPrepositionExerciseProvider);
    final progress =
        ref.watch(learningProgressProvider).value ?? const LearningProgress();
    final selectedWords = exercise.value == null
        ? const <FixedPrepositionVerb>[]
        : _filterExerciseWords(
            exercise.value!.words,
            _selectedFilter,
            progress,
          );
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.learningProgress)),
      body: ResponsiveContent(
        child: exercise.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.courseLoadError),
          ),
          data: (value) => _ExerciseOverview(
            exercise: value,
            progress: progress,
            selectedFilter: _selectedFilter,
            onFilterSelected: (filter) =>
                setState(() => _selectedFilter = filter),
            onViewWords: () => context.push(
              AppRoute.exerciseWordList(
                widget.exerciseId,
                filter: _selectedFilter.name,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.configureTraining,
        onPressed: selectedWords.isEmpty
            ? null
            : () => context.push(
                AppRoute.exerciseSetup(
                  widget.exerciseId,
                  filter: _selectedFilter.name,
                ),
              ),
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
        child: exercise.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.courseLoadError),
          ),
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
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onViewWords,
  });

  final FixedPrepositionExercise exercise;
  final LearningProgress progress;
  final FixedPrepositionFilter selectedFilter;
  final ValueChanged<FixedPrepositionFilter> onFilterSelected;
  final VoidCallback onViewWords;

  @override
  Widget build(BuildContext context) {
    final correct = progress.testedCount(
      exercise.words.map((word) => word.progressId),
    );
    final incorrect = progress.incorrectCount(
      exercise.words.map((word) => word.progressId),
    );
    final total = exercise.words.length;
    return ListView(
      padding: AppSpacing.pageInsets,
      children: [
        Card(
          margin: EdgeInsets.zero,
          color: Theme.of(context).colorScheme.primaryContainer,
          elevation: 0,
          child: Padding(
            padding: AppSpacing.pageInsets,
            child: Row(
              children: [
                Icon(
                  Icons.route_outlined,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    exercise.catalog.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OverallProgressCard(
          key: const ValueKey('exercise-all-stat'),
          title: context.l10n.allWords,
          progressLabel: '$correct / $total ${context.l10n.wordsCount}',
          progress: total == 0 ? 0 : correct / total,
          selected: selectedFilter == FixedPrepositionFilter.all,
          onTap: () => onFilterSelected(FixedPrepositionFilter.all),
        ),
        const SizedBox(height: 12),
        AdaptiveStatCardRow(
          firstBuilder: (context, {required fillHeight}) =>
              _ExerciseProgressCard(
                filter: FixedPrepositionFilter.correct,
                count: correct,
                total: total,
                selected: selectedFilter == FixedPrepositionFilter.correct,
                fillHeight: fillHeight,
                onTap: () => onFilterSelected(FixedPrepositionFilter.correct),
              ),
          secondBuilder: (context, {required fillHeight}) =>
              _ExerciseProgressCard(
                filter: FixedPrepositionFilter.incorrect,
                count: incorrect,
                total: total,
                selected: selectedFilter == FixedPrepositionFilter.incorrect,
                fillHeight: fillHeight,
                onTap: () => onFilterSelected(FixedPrepositionFilter.incorrect),
              ),
        ),
        const SizedBox(height: 14),
        Center(
          child: TextButton.icon(
            onPressed: onViewWords,
            icon: const Icon(Icons.list),
            label: Text(context.l10n.viewWords),
          ),
        ),
      ],
    );
  }
}

class _ExerciseProgressCard extends StatelessWidget {
  const _ExerciseProgressCard({
    required this.filter,
    required this.count,
    required this.total,
    required this.selected,
    required this.fillHeight,
    required this.onTap,
  });

  final FixedPrepositionFilter filter;
  final int count;
  final int total;
  final bool selected;
  final bool fillHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ProgressStatCard(
      key: ValueKey('exercise-${filter.name}-stat'),
      icon: switch (filter) {
        FixedPrepositionFilter.all => Icons.layers_outlined,
        FixedPrepositionFilter.correct => Icons.check_circle_outline,
        FixedPrepositionFilter.incorrect => Icons.cancel_outlined,
      },
      label: switch (filter) {
        FixedPrepositionFilter.all => context.l10n.allWords,
        FixedPrepositionFilter.correct => context.l10n.lidCorrectAnswers,
        FixedPrepositionFilter.incorrect => context.l10n.lidIncorrect,
      },
      progress: total == 0 ? 0 : count / total,
      progressLabel: '$count',
      selected: selected,
      fillHeight: fillHeight,
      onTap: onTap,
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
    final languageCode = Localizations.localeOf(context).languageCode;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xxl,
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
