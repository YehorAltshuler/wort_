import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:wort_flutter/collections/widgets/collection_actions.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/word_details/provider/word_details_provider.dart';

class WordDetailsPage extends ConsumerWidget {
  const WordDetailsPage({required this.lexemeId, super.key});

  final String lexemeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(wordDetailsProvider(lexemeId));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.dictionaryTitle),
        actions: [CollectionActions(wordId: 'lexicon:$lexemeId')],
      ),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(context.l10n.wordLoadError),
        ),
        data: (lexeme) => lexeme == null
            ? Center(child: Text(context.l10n.wordNotFound))
            : _WordDetailsView(lexeme: lexeme),
      ),
    );
  }
}

class _WordDetailsView extends StatelessWidget {
  const _WordDetailsView({required this.lexeme});

  final Lexeme lexeme;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final localized = lexeme.localizations[languageCode];
    final senses = localized?.senses.isNotEmpty ?? false
        ? localized!.senses
        : lexeme.senses;
    final etymology = localized?.etymology ?? lexeme.etymology;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.huge,
      ),
      children: [
        Text(lexeme.lemma, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 6),
        Text(
          '${_partOfSpeech(context, lexeme.partOfSpeech)} · '
          '${context.l10n.frequencyRank(lexeme.frequencyRank)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (lexeme.pronunciation.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            lexeme.pronunciation.join(' · '),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
        if (senses.isNotEmpty) ...[
          const SizedBox(height: 28),
          Text(
            context.l10n.meaningsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < senses.length; index++)
            _SenseTile(
              index: index,
              sense: senses[index],
              languageCode: languageCode,
            ),
        ],
        if (lexeme.forms.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            context.l10n.formsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final form in lexeme.forms.entries)
                    ListTile(
                      dense: true,
                      title: Text(form.key),
                      trailing: SizedBox(
                        width: 180,
                        child: Text(
                          form.value.join(', '),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        if (etymology != null && etymology.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            context.l10n.etymologyTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(etymology),
        ],
      ],
    );
  }

  static String _partOfSpeech(BuildContext context, PartOfSpeech value) =>
      switch (value) {
        PartOfSpeech.noun => context.l10n.noun,
        PartOfSpeech.verb => context.l10n.verb,
        PartOfSpeech.other => context.l10n.otherPartOfSpeech,
      };
}

class _SenseTile extends StatelessWidget {
  const _SenseTile({
    required this.index,
    required this.sense,
    required this.languageCode,
  });

  final int index;
  final LexicalSense sense;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final definition =
        sense.definitions[languageCode] ??
        sense.definitions['de'] ??
        sense.translations[languageCode]?.join(', ');
    if (definition == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. $definition'),
            if (sense.examples.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                sense.examples.first,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
