import 'package:flutter/material.dart';
import 'package:wort_flutter/theme/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.xxs,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
