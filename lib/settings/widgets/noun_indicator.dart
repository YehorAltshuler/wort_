import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';

class NounIndicator extends ConsumerWidget {
  const NounIndicator({required this.articles, super.key});

  final List<String> articles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (articles.isEmpty) return const SizedBox.shrink();
    final version =
        ref.watch(settingsProvider).value?.nounIndicator ??
        NounIndicatorVersion.v2;
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          for (final article in articles)
            if (version == NounIndicatorVersion.v1)
              _VerticalIndicator(article: article)
            else
              _BadgeIndicator(article: article),
        ],
      ),
    );
  }
}

class _VerticalIndicator extends StatelessWidget {
  const _VerticalIndicator({required this.article});

  final String article;

  @override
  Widget build(BuildContext context) {
    final color = _indicatorColor(context, article);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          article,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _BadgeIndicator extends StatelessWidget {
  const _BadgeIndicator({required this.article});

  final String article;

  @override
  Widget build(BuildContext context) {
    final color = _indicatorColor(context, article);
    return Container(
      constraints: const BoxConstraints(minWidth: 38, minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        article,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

Color _indicatorColor(BuildContext context, String article) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (article) {
    'der' => dark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
    'die' => dark ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
    'das' => dark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
    _ => dark ? const Color(0xFFC4B5FD) : const Color(0xFF7C3AED),
  };
}
