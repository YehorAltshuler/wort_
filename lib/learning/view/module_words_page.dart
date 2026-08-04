import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/collections/widgets/collection_actions.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/word_list_tile.dart';
import 'package:wort_flutter/widgets/word_list_view.dart';

class ModuleWordsPage extends ConsumerWidget {
  const ModuleWordsPage({
    required this.bookId,
    required this.moduleFile,
    required this.initialFilter,
    this.collectionId,
    super.key,
  });

  const ModuleWordsPage.collection({
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
  Widget build(BuildContext context, WidgetRef ref) {
    final words = collectionId == null
        ? ref.watch(
            moduleWordsProvider(
              (bookId: bookId!, moduleFile: moduleFile!),
            ),
          )
        : ref.watch(collectionWordsProvider(collectionId!));
    final filter = CourseWordFilterX.fromName(initialFilter);
    return Scaffold(
      appBar: AppBar(title: Text(_filterLabel(context, filter))),
      body: ResponsiveContent(
        child: words.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.courseLoadError),
          ),
          data: (items) => _WordList(words: filter.apply(items)),
        ),
      ),
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

class _WordList extends StatelessWidget {
  const _WordList({required this.words});

  final List<CourseWord> words;

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) return Center(child: Text(context.l10n.noWords));
    return WordListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      itemCount: words.length,
      itemBuilder: (context, index) => _WordRow(word: words[index]),
    );
  }
}

class _WordRow extends StatelessWidget {
  const _WordRow({required this.word});

  final CourseWord word;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return WordListTile(
      title: word.term,
      subtitle: word.translationsFor(languageCode).join(', '),
      articles: word.article,
      trailing: CollectionActions(wordId: word.id),
      onTap: word.dictionaryId == null
          ? null
          : () => context.push(AppRoute.wordDetails(word.dictionaryId!)),
    );
  }
}
