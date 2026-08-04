import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class ModulePage extends ConsumerStatefulWidget {
  const ModulePage({required this.bookId, required this.moduleFile, super.key});

  final String bookId;
  final String moduleFile;

  @override
  ConsumerState<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends ConsumerState<ModulePage> {
  CourseWordFilter _selectedFilter = CourseWordFilter.all;

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(
      moduleWordsProvider(
        (bookId: widget.bookId, moduleFile: widget.moduleFile),
      ),
    );
    final progress =
        ref.watch(learningProgressProvider).value ?? const LearningProgress();
    final book = ref
        .watch(booksProvider)
        .value
        ?.where((book) => book.id == widget.bookId)
        .firstOrNull;
    final moduleTitle = book?.modules
        .where((module) => module.file == widget.moduleFile)
        .firstOrNull
        ?.title;
    final hasSelectedWords = words.maybeWhen(
      data: (items) => _selectedFilter.apply(items).isNotEmpty,
      orElse: () => false,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.learningProgress)),
      body: ResponsiveContent(
        child: words.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.courseLoadError),
          ),
          data: (items) => _Overview(
            words: items,
            progress: progress,
            bookTitle: book?.title ?? widget.bookId,
            moduleTitle: moduleTitle ?? widget.moduleFile,
            selectedFilter: _selectedFilter,
            onFilterSelected: (filter) {
              setState(() => _selectedFilter = filter);
            },
            onViewWords: () => context.push(
              AppRoute.moduleWords(
                widget.bookId,
                widget.moduleFile,
                type: _selectedFilter.name,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.configureTraining,
        onPressed: hasSelectedWords
            ? () => context.push(
                AppRoute.sessionSetup(
                  widget.bookId,
                  widget.moduleFile,
                  type: _selectedFilter.name,
                ),
              )
            : null,
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({
    required this.words,
    required this.progress,
    required this.bookTitle,
    required this.moduleTitle,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onViewWords,
  });

  final List<CourseWord> words;
  final LearningProgress progress;
  final String bookTitle;
  final String moduleTitle;
  final CourseWordFilter selectedFilter;
  final ValueChanged<CourseWordFilter> onFilterSelected;
  final VoidCallback onViewWords;

  @override
  Widget build(BuildContext context) {
    const filters = CourseWordFilter.values;
    return ListView(
      padding: AppSpacing.pageInsets,
      children: [
        _ModuleContextCard(
          bookTitle: bookTitle,
          moduleTitle: moduleTitle,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width < 600 ? 2 : 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            for (final filter in filters)
              _ProgressCard(
                label: _filterLabel(context, filter),
                filter: filter,
                words: words,
                progress: progress,
                selected: filter == selectedFilter,
                onTap: () => onFilterSelected(filter),
              ),
          ],
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

  String _filterLabel(BuildContext context, CourseWordFilter filter) =>
      switch (filter) {
        CourseWordFilter.all => context.l10n.allWords,
        CourseWordFilter.noun => context.l10n.nouns,
        CourseWordFilter.verb => context.l10n.verbs,
        CourseWordFilter.other => context.l10n.otherWords,
      };
}

class _ModuleContextCard extends StatelessWidget {
  const _ModuleContextCard({
    required this.bookTitle,
    required this.moduleTitle,
  });

  final String bookTitle;
  final String moduleTitle;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Theme.of(context).colorScheme.primaryContainer,
    elevation: 0,
    child: Padding(
      padding: AppSpacing.pageInsets,
      child: Row(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  moduleTitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.label,
    required this.filter,
    required this.words,
    required this.progress,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final CourseWordFilter filter;
  final List<CourseWord> words;
  final LearningProgress progress;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filtered = filter.apply(words);
    final tested = progress.testedCount(filtered.map((word) => word.id));
    final ratio = filtered.isEmpty ? 0.0 : tested / filtered.length;
    return ProgressStatCard(
      icon: _icon(filter),
      label: label,
      progress: ratio,
      progressLabel: '$tested / ${filtered.length} ${context.l10n.wordsCount}',
      selected: selected,
      onTap: onTap,
    );
  }

  IconData _icon(CourseWordFilter value) => switch (value) {
    CourseWordFilter.all => Icons.layers_outlined,
    CourseWordFilter.noun => Icons.category_outlined,
    CourseWordFilter.verb => Icons.bolt_outlined,
    CourseWordFilter.other => Icons.extension_outlined,
  };
}
