import 'package:collections_repository/collections_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';

class CollectionActions extends ConsumerWidget {
  const CollectionActions({required this.wordId, super.key});

  static const _newCollection = '__new_collection__';

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider).value ?? const [];
    final favorites = collections.byId(WordCollection.favoritesId);
    final favorite = favorites?.contains(wordId) ?? false;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: favorite
              ? context.l10n.removeFromFavorites
              : context.l10n.addToFavorites,
          onPressed: () => ref
              .read(collectionsProvider.notifier)
              .toggleWord(WordCollection.favoritesId, wordId),
          icon: Icon(favorite ? Icons.bookmark : Icons.bookmark_outline),
        ),
        PopupMenuButton<String>(
          tooltip: context.l10n.addToCollections,
          icon: const Icon(Icons.folder_outlined),
          onSelected: (id) async {
            if (id == _newCollection) {
              await _createCollection(context, ref);
              return;
            }
            await ref.read(collectionsProvider.notifier).toggleWord(id, wordId);
          },
          itemBuilder: (context) => [
            for (final collection in collections)
              if (!collection.isFavorites)
                CheckedPopupMenuItem(
                  value: collection.id,
                  checked: collection.contains(wordId),
                  child: Text(collection.name),
                ),
            if (collections.any((collection) => !collection.isFavorites))
              const PopupMenuDivider(),
            PopupMenuItem(
              value: _newCollection,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.create_new_folder_outlined),
                title: Text(context.l10n.newList),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _createCollection(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.newList),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: dialogContext.l10n.listName),
          onSubmitted: (value) => Navigator.pop(dialogContext, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(dialogContext.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(dialogContext.l10n.create),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty) return;
    await ref
        .read(collectionsProvider.notifier)
        .createListWithWord(name, wordId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.addedToList(name.trim())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
