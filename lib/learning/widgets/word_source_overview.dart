import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class WordSourceOverview extends StatelessWidget {
  const WordSourceOverview({
    required this.words,
    required this.progress,
    required this.title,
    required this.icon,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onViewWords,
    this.subtitle,
    super.key,
  });

  final List<CourseWord> words;
  final LearningProgress progress;
  final String title;
  final String? subtitle;
  final IconData icon;
  final CourseWordFilter selectedFilter;
  final ValueChanged<CourseWordFilter> onFilterSelected;
  final VoidCallback onViewWords;

  @override
  Widget build(BuildContext context) {
    final filters = CourseWordFilter.values
        .where(
          (filter) =>
              filter == CourseWordFilter.all || filter.apply(words).isNotEmpty,
        )
        .toList(growable: false);
    return ListView(
      padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
      children: [
        _SourceContextCard(title: title, subtitle: subtitle, icon: icon),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 600;
            final cards = [
              for (final filter in filters)
                _WordProgressCard(
                  filter: filter,
                  words: words,
                  progress: progress,
                  selected: filter == selectedFilter,
                  fillHeight: compact,
                  onTap: () => onFilterSelected(filter),
                ),
            ];
            if (compact) {
              return GridView.count(
                crossAxisCount: filters.length < 2 ? filters.length : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: cards,
              );
            }
            final cardWidth =
                (constraints.maxWidth - 12 * (cards.length - 1)) / cards.length;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final card in cards)
                  SizedBox(width: cardWidth, child: card),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        Center(
          child: TextButton.icon(
            onPressed: onViewWords,
            icon: const Icon(Icons.list),
            label: Text(context.l10n.viewWords),
          ),
        ),
      ],
    );
  }
}

class _SourceContextCard extends StatelessWidget {
  const _SourceContextCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Theme.of(context).colorScheme.primaryContainer,
    elevation: 0,
    child: Padding(
      padding: AppSpacing.pageInsets,
      child: Row(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle case final subtitle?) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _WordProgressCard extends StatelessWidget {
  const _WordProgressCard({
    required this.filter,
    required this.words,
    required this.progress,
    required this.selected,
    required this.fillHeight,
    required this.onTap,
  });

  final CourseWordFilter filter;
  final List<CourseWord> words;
  final LearningProgress progress;
  final bool selected;
  final bool fillHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filtered = filter.apply(words);
    final tested = progress.testedCount(filtered.map((word) => word.id));
    return ProgressStatCard(
      icon: switch (filter) {
        CourseWordFilter.all => Icons.layers_outlined,
        CourseWordFilter.noun => Icons.category_outlined,
        CourseWordFilter.verb => Icons.bolt_outlined,
        CourseWordFilter.other => Icons.extension_outlined,
      },
      label: switch (filter) {
        CourseWordFilter.all => context.l10n.allWords,
        CourseWordFilter.noun => context.l10n.nouns,
        CourseWordFilter.verb => context.l10n.verbs,
        CourseWordFilter.other => context.l10n.otherWords,
      },
      progress: filtered.isEmpty ? 0 : tested / filtered.length,
      progressLabel: '$tested / ${filtered.length} ${context.l10n.wordsCount}',
      selected: selected,
      fillHeight: fillHeight,
      onTap: onTap,
    );
  }
}
