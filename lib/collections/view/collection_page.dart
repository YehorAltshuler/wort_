import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/dictionary/provider/noun_gender_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/word_list_tile.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({required this.collectionId, super.key});

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          collections.value?.byId(collectionId)?.isFavorites ?? false
              ? context.l10n.favoritesTitle
              : collections.value?.byId(collectionId)?.name ?? '',
        ),
        actions: [
          if (!(collections.value?.byId(collectionId)?.isFavorites ?? true))
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
        child: collections.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.collectionsLoadError),
          ),
          data: (items) {
            final collection = items.byId(collectionId);
            if (collection == null || collection.wordIds.isEmpty) {
              return Center(child: Text(context.l10n.collectionEmpty));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: collection.wordIds.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => _SavedWordTile(
                collectionId: collectionId,
                wordId: collection.wordIds[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    if (action == 'delete') {
      await ref.read(collectionsProvider.notifier).deleteList(collectionId);
      if (context.mounted) context.pop();
      return;
    }
    final current = ref.read(collectionsProvider).value?.byId(collectionId);
    if (current == null) return;
    final controller = TextEditingController(text: current.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.rename),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          FilledButton(
            onPressed: () => context.pop(controller.text),
            child: Text(context.l10n.rename),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name != null) {
      await ref
          .read(collectionsProvider.notifier)
          .renameList(collectionId, name);
    }
  }
}

class _SavedWordTile extends ConsumerWidget {
  const _SavedWordTile({required this.collectionId, required this.wordId});

  final String collectionId;
  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final word = ref.watch(savedWordProvider(wordId));
    final genderIndex = ref.watch(nounGenderIndexProvider).value ?? const {};
    return word.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (item) => item == null
          ? const SizedBox.shrink()
          : WordListTile(
              title: item.term,
              subtitle: item.translationFor(
                Localizations.localeOf(context).languageCode,
              ),
              articles: item.articles.isNotEmpty
                  ? item.articles
                  : nounArticles(genderIndex, item.term),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => ref
                    .read(collectionsProvider.notifier)
                    .toggleWord(collectionId, wordId),
              ),
              onTap: item.dictionaryId == null
                  ? null
                  : () =>
                        context.push(AppRoute.wordDetails(item.dictionaryId!)),
            ),
    );
  }
}
