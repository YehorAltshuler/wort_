import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/widgets/collection_actions.dart';
import 'package:wort_flutter/dictionary/provider/dictionary_provider.dart';
import 'package:wort_flutter/dictionary/provider/noun_gender_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/word_list_tile.dart';
import 'package:wort_flutter/widgets/word_list_view.dart';

const _telescopeOutline = IconData(62915, fontFamily: 'Ionicons');

class DictionaryPage extends ConsumerWidget {
  const DictionaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dictionaryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.md,
          ),
          child: TextField(
            autocorrect: false,
            textInputAction: TextInputAction.search,
            onChanged: ref.read(dictionaryProvider.notifier).queryChanged,
            decoration: InputDecoration(
              hintText: context.l10n.dictionaryHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(child: _SearchResults(state: state)),
      ],
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.state});

  final DictionaryState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.error != null) {
      return Center(child: Text(context.l10n.dictionaryLoadError));
    }
    final genderIndex = ref.watch(nounGenderIndexProvider).value ?? const {};
    if (!state.hasSearched) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _telescopeOutline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.dictionaryPrompt,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }
    if (state.results.isEmpty && !state.isLoading) {
      return Center(child: Text(context.l10n.dictionaryEmpty));
    }

    return WordListView(
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final lexeme = state.results[index];
        return WordListTile(
          title: lexeme.lemma,
          subtitle: _partOfSpeechLabel(context, lexeme.partOfSpeech),
          articles: nounArticles(genderIndex, lexeme.lemma),
          trailing: CollectionActions(wordId: 'lexicon:${lexeme.id}'),
          onTap: () async {
            await context.push<void>(AppRoute.wordDetails(lexeme.id));
          },
        );
      },
    );
  }

  String _partOfSpeechLabel(
    BuildContext context,
    PartOfSpeech partOfSpeech,
  ) => switch (partOfSpeech) {
    PartOfSpeech.noun => context.l10n.noun,
    PartOfSpeech.verb => context.l10n.verb,
    PartOfSpeech.other => context.l10n.otherPartOfSpeech,
  };
}
