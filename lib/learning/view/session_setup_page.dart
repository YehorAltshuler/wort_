import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/domain/training_exercise.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/settings/widgets/settings_section.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/async_value_view.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/selection_card.dart';
import 'package:wort_flutter/widgets/training_setup_scaffold.dart';

class SessionSetupPage extends ConsumerStatefulWidget {
  const SessionSetupPage({
    required this.bookId,
    required this.moduleFile,
    required this.initialFilter,
    this.collectionId,
    super.key,
  });

  const SessionSetupPage.collection({
    required this.collectionId,
    required this.initialFilter,
    super.key,
  }) : bookId = null,
       moduleFile = null;

  final String? bookId;
  final String? moduleFile;
  final String? collectionId;
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
    final words = widget.collectionId == null
        ? ref.watch(
            moduleWordsProvider(
              (bookId: widget.bookId!, moduleFile: widget.moduleFile!),
            ),
          )
        : ref.watch(collectionWordsProvider(widget.collectionId!));
    final hasWords = words.maybeWhen(
      data: (items) => _filter.apply(items).isNotEmpty,
      orElse: () => false,
    );
    return TrainingSetupScaffold(
      title: context.l10n.sessionSetupTitle,
      body: AsyncValueView(
        value: words,
        errorMessage: context.l10n.courseLoadError,
        data: (items) {
          final availableFilters = CourseWordFilter.values.where(
            (filter) =>
                filter == CourseWordFilter.all ||
                filter.apply(items).isNotEmpty,
          );
          return ListView(
            padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
            children: [
              SettingsSection(
                title: context.l10n.viewWords,
                children: [
                  for (final filter in availableFilters)
                    SelectionCard(
                      title: _filterLabel(context, filter),
                      selected: _filter == filter,
                      onTap: () => setState(() => _filter = filter),
                      leading: _filterIcon(filter),
                      badge: '${filter.apply(items).length}',
                    ),
                ],
              ),
              const SizedBox(height: 28),
              SettingsSection(
                title: context.l10n.difficultyTitle,
                children: [
                  for (final difficulty in TrainingDifficulty.values)
                    SelectionCard(
                      title: _difficultyLabel(context, difficulty),
                      subtitle: _difficultyDescription(context, difficulty),
                      selected: _difficulty == difficulty,
                      onTap: () => setState(() => _difficulty = difficulty),
                      leading: _difficultyIcon(difficulty),
                    ),
                ],
              ),
            ],
          );
        },
      ),
      actionLabel: context.l10n.startTraining,
      onAction: hasWords
          ? () => context.pushReplacement(
              widget.collectionId == null
                  ? AppRoute.session(
                      widget.bookId!,
                      widget.moduleFile!,
                      type: _filter.name,
                      difficulty: _difficulty.name,
                    )
                  : AppRoute.collectionSession(
                      widget.collectionId!,
                      type: _filter.name,
                      difficulty: _difficulty.name,
                    ),
            )
          : null,
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
    CourseWordFilter.all => Icons.layers_outlined,
    CourseWordFilter.noun => Icons.category_outlined,
    CourseWordFilter.verb => Icons.bolt_outlined,
    CourseWordFilter.other => Icons.extension_outlined,
  };

  IconData _difficultyIcon(TrainingDifficulty difficulty) =>
      switch (difficulty) {
        TrainingDifficulty.easy => Icons.sentiment_satisfied_alt_outlined,
        TrainingDifficulty.medium => Icons.psychology_alt_outlined,
        TrainingDifficulty.hard => Icons.local_fire_department_outlined,
      };
}
