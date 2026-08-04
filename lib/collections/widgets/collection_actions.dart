import 'package:collections_repository/collections_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/selection_bottom_sheet.dart';
import 'package:wort_flutter/widgets/text_input_dialog.dart';

class CollectionActions extends ConsumerWidget {
  const CollectionActions({required this.wordId, super.key});

  static const _newCollection = '__new_collection__';

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider).value ?? const [];
    final selected = collections.where((item) => item.contains(wordId)).length;
    return IconButton(
      tooltip: context.l10n.addToCollections,
      onPressed: () => _showCollections(context, ref),
      icon: Badge(
        isLabelVisible: selected > 0,
        label: Text('$selected'),
        child: Icon(
          selected > 0 ? Icons.folder_special : Icons.folder_outlined,
        ),
      ),
    );
  }

  Future<void> _showCollections(BuildContext context, WidgetRef ref) async {
    final result = await showAppBottomSheet<String>(
      context: context,
      title: context.l10n.addToCollections,
      builder: (sheetContext) => _CollectionPicker(
        wordId: wordId,
        onCreate: () => Navigator.pop(sheetContext, _newCollection),
      ),
    );
    if (result == _newCollection && context.mounted) {
      await _createCollection(context, ref);
    }
  }

  Future<void> _createCollection(BuildContext context, WidgetRef ref) async {
    final name = await showTextInputDialog(
      context: context,
      title: context.l10n.newList,
      hintText: context.l10n.listName,
      cancelLabel: context.l10n.cancel,
      actionLabel: context.l10n.create,
    );
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

class _CollectionPicker extends ConsumerWidget {
  const _CollectionPicker({required this.wordId, required this.onCreate});

  final String wordId;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    return collections.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(context.l10n.collectionsLoadError),
      ),
      data: (items) {
        final favorites = items.byId(WordCollection.favoritesId);
        final lists = items.where((item) => !item.isFavorites);
        final ordered = [?favorites, ...lists];
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            for (final collection in ordered) ...[
              _CollectionOption(
                collection: collection,
                selected: collection.contains(wordId),
                onTap: () => ref
                    .read(collectionsProvider.notifier)
                    .toggleWord(collection.id, wordId),
              ),
              const SizedBox(height: 6),
            ],
            const SizedBox(height: 4),
            Material(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                minTileHeight: 56,
                leading: Icon(
                  Icons.create_new_folder_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  context.l10n.newList,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: const Icon(Icons.add_rounded),
                onTap: onCreate,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CollectionOption extends StatelessWidget {
  const _CollectionOption({
    required this.collection,
    required this.selected,
    required this.onTap,
  });

  final WordCollection collection;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected ? colors.secondaryContainer : colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minTileHeight: 56,
        leading: Icon(
          collection.isFavorites ? Icons.bookmark_rounded : Icons.folder,
          color: selected ? colors.primary : colors.onSurfaceVariant,
        ),
        title: Text(
          collection.isFavorites
              ? context.l10n.favoritesTitle
              : collection.name,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        trailing: Icon(
          selected
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: selected ? colors.primary : colors.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
