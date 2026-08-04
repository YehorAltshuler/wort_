import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/learning/widgets/word_source_overview.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/text_input_dialog.dart';

class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({required this.collectionId, super.key});

  final String collectionId;

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  CourseWordFilter _selectedFilter = CourseWordFilter.all;

  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(collectionsProvider);
    final words = ref.watch(collectionWordsProvider(widget.collectionId));
    final progress =
        ref.watch(learningProgressProvider).value ?? const LearningProgress();
    final collection = collections.value?.byId(widget.collectionId);
    final hasSelectedWords = words.maybeWhen(
      data: (items) => _selectedFilter.apply(items).isNotEmpty,
      orElse: () => false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          collection?.isFavorites ?? false
              ? context.l10n.favoritesTitle
              : collection?.name ?? '',
        ),
        actions: [
          if (!(collection?.isFavorites ?? true))
            PopupMenuButton<String>(
              onSelected: (action) => _handleAction(context, ref, action),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'rename',
                  child: Text(context.l10n.rename),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(context.l10n.delete),
                ),
              ],
            ),
        ],
      ),
      body: ResponsiveContent(
        child: words.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.collectionsLoadError),
          ),
          data: (items) {
            if (collection == null || items.isEmpty) {
              return Center(child: Text(context.l10n.collectionEmpty));
            }
            return WordSourceOverview(
              words: items,
              progress: progress,
              title: collection.isFavorites
                  ? context.l10n.favoritesTitle
                  : collection.name,
              icon: collection.isFavorites
                  ? Icons.bookmark
                  : Icons.folder_outlined,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) =>
                  setState(() => _selectedFilter = filter),
              onViewWords: () => context.push(
                AppRoute.collectionWords(
                  widget.collectionId,
                  type: _selectedFilter.name,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.configureTraining,
        onPressed: hasSelectedWords
            ? () => context.push(
                AppRoute.collectionSetup(
                  widget.collectionId,
                  type: _selectedFilter.name,
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    if (action == 'delete') {
      await ref
          .read(collectionsProvider.notifier)
          .deleteList(widget.collectionId);
      if (context.mounted) context.pop();
      return;
    }
    final current = ref
        .read(collectionsProvider)
        .value
        ?.byId(widget.collectionId);
    if (current == null) return;
    final name = await showTextInputDialog(
      context: context,
      title: context.l10n.rename,
      initialText: current.name,
      actionLabel: context.l10n.rename,
    );
    if (name != null) {
      await ref
          .read(collectionsProvider.notifier)
          .renameList(widget.collectionId, name);
    }
  }
}
