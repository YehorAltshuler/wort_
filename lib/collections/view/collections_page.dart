import 'package:collections_repository/collections_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/dashboard_block.dart';
import 'package:wort_flutter/widgets/section_header.dart';
import 'package:wort_flutter/widgets/text_input_dialog.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    final progress =
        ref.watch(learningProgressProvider).value ?? const LearningProgress();
    return ListView(
      padding: AppSpacing.pageInsets,
      children: [
        collections.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text(context.l10n.collectionsLoadError),
          data: (items) => _CollectionBlocks(
            items: items,
            progress: progress,
            onCreate: () => _createList(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _createList(BuildContext context, WidgetRef ref) async {
    final name = await showTextInputDialog(
      context: context,
      title: context.l10n.newList,
      hintText: context.l10n.listName,
      cancelLabel: context.l10n.cancel,
      actionLabel: context.l10n.create,
    );
    if (name != null) {
      await ref.read(collectionsProvider.notifier).createList(name);
    }
  }
}

class _CollectionBlocks extends StatelessWidget {
  const _CollectionBlocks({
    required this.items,
    required this.progress,
    required this.onCreate,
  });

  final List<WordCollection> items;
  final LearningProgress progress;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final favorites = items.where((item) => item.isFavorites).firstOrNull;
    final lists = items.where((item) => !item.isFavorites).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: context.l10n.favoritesTitle),
        if (favorites != null)
          DashboardBlock(
            icon: Icons.bookmark,
            title: context.l10n.favoritesTitle,
            subtitle: _progressLabel(context, favorites),
            progress: _progressValue(favorites),
            onTap: () => context.push(AppRoute.collection(favorites.id)),
          ),
        const SizedBox(height: AppSpacing.xxxl),
        SectionHeader(
          title: context.l10n.customLists,
          trailing: Text('${lists.length}'),
        ),
        DashboardBlockGrid(
          children: [
            for (final list in lists)
              DashboardBlock(
                icon: Icons.folder_outlined,
                title: list.name,
                subtitle: _progressLabel(context, list),
                progress: _progressValue(list),
                onTap: () => context.push(AppRoute.collection(list.id)),
              ),
            DashboardAddBlock(label: context.l10n.newList, onTap: onCreate),
          ],
        ),
      ],
    );
  }

  double _progressValue(WordCollection collection) {
    if (collection.wordIds.isEmpty) return 0;
    return progress.testedCount(collection.wordIds) / collection.wordIds.length;
  }

  String _progressLabel(BuildContext context, WordCollection collection) {
    final confirmed = progress.testedCount(collection.wordIds);
    return '${collection.wordIds.length} ${context.l10n.wordsCount} · '
        '$confirmed ${context.l10n.confirmedByTest}';
  }
}
