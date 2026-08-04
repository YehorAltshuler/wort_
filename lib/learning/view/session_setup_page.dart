import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/domain/training_exercise.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/selection_card.dart';

class SessionSetupPage extends ConsumerStatefulWidget {
  const SessionSetupPage({
    required this.bookId,
    required this.moduleFile,
    required this.initialFilter,
    super.key,
  });

  final String bookId;
  final String moduleFile;
  final String initialFilter;

  @override
  ConsumerState<SessionSetupPage> createState() => _SessionSetupPageState();
}

class _SessionSetupPageState extends ConsumerState<SessionSetupPage> {
  late CourseWordFilter _filter;
  TrainingDifficulty _difficulty = TrainingDifficulty.easy;

  @override
  void initState() {
    super.initState();
    _filter = CourseWordFilterX.fromName(widget.initialFilter);
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(
      moduleWordsProvider(
        (bookId: widget.bookId, moduleFile: widget.moduleFile),
      ),
    );
    final hasWords = words.maybeWhen(
      data: (items) => _filter.apply(items).isNotEmpty,
      orElse: () => false,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sessionSetupTitle)),
      body: ResponsiveContent(
        child: words.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.courseLoadError),
          ),
          data: (items) {
            final availableFilters = CourseWordFilter.values.where(
              (filter) =>
                  filter == CourseWordFilter.all ||
                  filter.apply(items).isNotEmpty,
            );
            return ListView(
              padding: AppSpacing.pageInsets,
              children: [
                Text(
                  context.l10n.viewWords,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    for (final filter in availableFilters) ...[
                      SelectionCard(
                        title: _filterLabel(context, filter),
                        selected: _filter == filter,
                        onTap: () => setState(() => _filter = filter),
                        leading: _filterIcon(filter),
                        badge: '${filter.apply(items).length}',
                      ),
                      if (filter != availableFilters.last)
                        const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  context.l10n.difficultyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    for (final difficulty in TrainingDifficulty.values) ...[
                      SelectionCard(
                        title: _difficultyLabel(context, difficulty),
                        subtitle: _difficultyDescription(context, difficulty),
                        selected: _difficulty == difficulty,
                        onTap: () => setState(() => _difficulty = difficulty),
                        leading: _difficultyIcon(difficulty),
                      ),
                      if (difficulty != TrainingDifficulty.values.last)
                        const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.startTraining,
        onPressed: hasWords
            ? () => context.pushReplacement(
                AppRoute.session(
                  widget.bookId,
                  widget.moduleFile,
                  type: _filter.name,
                  difficulty: _difficulty.name,
                ),
              )
            : null,
      ),
    );
  }

  String _difficultyLabel(
    BuildContext context,
    TrainingDifficulty difficulty,
  ) => switch (difficulty) {
    TrainingDifficulty.easy => context.l10n.difficultyEasy,
    TrainingDifficulty.medium => context.l10n.difficultyMedium,
    TrainingDifficulty.hard => context.l10n.difficultyHard,
  };

  String _filterLabel(BuildContext context, CourseWordFilter filter) =>
      switch (filter) {
        CourseWordFilter.all => context.l10n.allWords,
        CourseWordFilter.noun => context.l10n.nouns,
        CourseWordFilter.verb => context.l10n.verbs,
        CourseWordFilter.other => context.l10n.otherWords,
      };

  String _difficultyDescription(
    BuildContext context,
    TrainingDifficulty difficulty,
  ) => switch (difficulty) {
    TrainingDifficulty.easy => context.l10n.difficultyEasyDescription,
    TrainingDifficulty.medium => context.l10n.difficultyMediumDescription,
    TrainingDifficulty.hard => context.l10n.difficultyHardDescription,
  };

  IconData _filterIcon(CourseWordFilter filter) => switch (filter) {
    CourseWordFilter.all => Icons.library_books_outlined,
    CourseWordFilter.noun => Icons.sell_outlined,
    CourseWordFilter.verb => Icons.directions_run_outlined,
    CourseWordFilter.other => Icons.category_outlined,
  };

  IconData _difficultyIcon(TrainingDifficulty difficulty) =>
      switch (difficulty) {
        TrainingDifficulty.easy => Icons.sentiment_satisfied_alt_outlined,
        TrainingDifficulty.medium => Icons.psychology_alt_outlined,
        TrainingDifficulty.hard => Icons.local_fire_department_outlined,
      };
}
