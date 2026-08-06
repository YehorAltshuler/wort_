import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/learning/widgets/word_source_overview.dart';
import 'package:wort_flutter/widgets/async_value_view.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
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
        child: AsyncValueView(
          value: words,
          errorMessage: context.l10n.courseLoadError,
          data: (items) => WordSourceOverview(
            words: items,
            progress: progress,
            title: book?.title ?? widget.bookId,
            subtitle: moduleTitle ?? widget.moduleFile,
            icon: Icons.menu_book_outlined,
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
