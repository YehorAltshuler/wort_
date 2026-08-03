import 'package:flutter/material.dart';
import 'package:wort_flutter/theme/app_spacing.dart';

class WordListView extends StatelessWidget {
  const WordListView({
    required this.itemCount,
    required this.itemBuilder,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.sm,
      AppSpacing.xl,
      AppSpacing.xxl,
    ),
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: itemBuilder,
    );
  }
}
