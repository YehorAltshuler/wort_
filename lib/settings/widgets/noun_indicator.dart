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
    final palette = _indicatorPalette(context, article);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 28,
          decoration: BoxDecoration(
            color: palette.foreground,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _indicatorLabel(article),
          style: TextStyle(
            color: palette.foreground,
            fontWeight: FontWeight.w700,
          ),
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
    final palette = _indicatorPalette(context, article);
    return Container(
      constraints: BoxConstraints(
        minWidth: article == 'plural' ? 34 : 38,
        minHeight: 28,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _indicatorLabel(article),
        style: TextStyle(
          color: palette.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

({Color foreground, Color background}) _indicatorPalette(
  BuildContext context,
  String article,
) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch ((dark, article)) {
    (false, 'der') => (
      foreground: const Color(0xFF3F729B),
      background: const Color(0xFFE5EFF7),
    ),
    (false, 'die') => (
      foreground: const Color(0xFFB23689),
      background: const Color(0xFFF8E5F2),
    ),
    (false, 'das') => (
      foreground: const Color(0xFF4F815B),
      background: const Color(0xFFE7F1E9),
    ),
    (false, 'plural') => (
      foreground: const Color(0xFF997126),
      background: const Color(0xFFF6EEDC),
    ),
    (true, 'der') => (
      foreground: const Color(0xFF83B3D8),
      background: const Color(0xFF182A38),
    ),
    (true, 'die') => (
      foreground: const Color(0xFFEC75CB),
      background: const Color(0xFF35172E),
    ),
    (true, 'das') => (
      foreground: const Color(0xFF87BE91),
      background: const Color(0xFF1C3021),
    ),
    (true, 'plural') => (
      foreground: const Color(0xFFD8B466),
      background: const Color(0xFF332A17),
    ),
    _ => (
      foreground: Theme.of(context).colorScheme.onSurfaceVariant,
      background: Theme.of(context).colorScheme.surfaceContainerHighest,
    ),
  };
}

String _indicatorLabel(String article) => article == 'plural' ? 'Pl.' : article;
