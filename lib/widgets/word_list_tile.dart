import 'package:flutter/material.dart';
import 'package:wort_flutter/settings/widgets/noun_indicator.dart';

class WordListTile extends StatelessWidget {
  const WordListTile({
    required this.title,
    required this.subtitle,
    this.articles = const [],
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<String> articles;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            if (articles.isNotEmpty) ...[
              NounIndicator(articles: articles),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
