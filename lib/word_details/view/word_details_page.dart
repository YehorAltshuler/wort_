import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wort_flutter/collections/widgets/collection_actions.dart';
import 'package:wort_flutter/dictionary/provider/noun_gender_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/widgets/noun_indicator.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/word_details/provider/word_details_provider.dart';

class WordDetailsPage extends ConsumerWidget {
  const WordDetailsPage({required this.lexemeId, super.key});

  final String lexemeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(wordDetailsProvider(lexemeId));
    final genderIndex = ref.watch(nounGenderIndexProvider).value ?? const {};
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.dictionaryTitle),
        actions: [CollectionActions(wordId: 'lexicon:$lexemeId')],
      ),
      body: ResponsiveContent(
        child: details.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.wordLoadError),
          ),
          data: (lexeme) => lexeme == null
              ? Center(child: Text(context.l10n.wordNotFound))
              : _WordDetailsView(
                  lexeme: lexeme,
                  articles: nounArticles(genderIndex, lexeme.lemma),
                ),
        ),
      ),
    );
  }
}

class _WordDetailsView extends StatelessWidget {
  const _WordDetailsView({required this.lexeme, required this.articles});

  final Lexeme lexeme;
  final List<String> articles;

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
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.huge,
      ),
      children: [
        _WordHeader(lexeme: lexeme, articles: articles),
        if (senses.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          _DetailsSection(
            title: context.l10n.meaningsTitle,
            icon: Icons.format_list_numbered_rounded,
            child: Column(
              children: [
                for (var index = 0; index < senses.length; index++)
                  _SenseRow(
                    index: index,
                    sense: senses[index],
                    languageCode: languageCode,
                    showDivider: index < senses.length - 1,
                  ),
              ],
            ),
          ),
        ],
        if (lexeme.forms.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          _DetailsSection(
            title: context.l10n.formsTitle,
            icon: Icons.account_tree_outlined,
            child: Column(
              children: [
                for (final (index, form) in lexeme.forms.entries.indexed)
                  _FormRow(
                    label: form.key,
                    value: form.value.join(', '),
                    showDivider: index < lexeme.forms.length - 1,
                  ),
              ],
            ),
          ),
        ],
        if (etymology != null && etymology.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          _DetailsSection(
            title: context.l10n.etymologyTitle,
            icon: Icons.history_edu_outlined,
            child: SelectableText(etymology),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        _SourceSection(lemma: lexeme.lemma),
      ],
    );
  }

  static String partOfSpeech(BuildContext context, PartOfSpeech value) =>
      switch (value) {
        PartOfSpeech.noun => context.l10n.noun,
        PartOfSpeech.verb => context.l10n.verb,
        PartOfSpeech.other => context.l10n.otherPartOfSpeech,
      };
}

class _WordHeader extends StatelessWidget {
  const _WordHeader({required this.lexeme, required this.articles});

  final Lexeme lexeme;
  final List<String> articles;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (articles.isNotEmpty) ...[
                  NounIndicator(articles: articles),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: SelectableText(
                    lexeme.lemma,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _WordDetailsView.partOfSpeech(context, lexeme.partOfSpeech),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (lexeme.pronunciation.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.record_voice_over_outlined,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: SelectableText(
                      '/${lexeme.pronunciation.join('/ · /')}/',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 21),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    ),
  );
}

class _SenseRow extends StatelessWidget {
  const _SenseRow({
    required this.index,
    required this.sense,
    required this.languageCode,
    required this.showDivider,
  });

  final int index;
  final LexicalSense sense;
  final String languageCode;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final definition =
        sense.definitions[languageCode] ??
        sense.definitions['de'] ??
        sense.translations[languageCode]?.join(', ');
    if (definition == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      definition,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (sense.examples.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        sense.examples.first,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    required this.label,
    required this.value,
    required this.showDivider,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 3,
              child: SelectableText(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      if (showDivider) const Divider(height: 1),
    ],
  );
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({required this.lemma});

  final String lemma;

  @override
  Widget build(BuildContext context) => _DetailsSection(
    title: context.l10n.dictionarySources,
    icon: Icons.menu_book_outlined,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _SourceButton(
              label: 'Wiktionary',
              uri: Uri.https('de.wiktionary.org', '/wiki/$lemma'),
            ),
            _SourceButton(
              label: 'DWDS',
              uri: Uri.https('www.dwds.de', '/wb/$lemma'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          context.l10n.wiktionaryAttribution,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({required this.label, required this.uri});

  final String label;
  final Uri uri;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () => _open(context),
    icon: const Icon(Icons.open_in_new_rounded, size: 18),
    label: Text(label),
  );

  Future<void> _open(BuildContext context) async {
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      opened = false;
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.externalLinkError)));
    }
  }
}
