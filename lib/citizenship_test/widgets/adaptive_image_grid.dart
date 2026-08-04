import 'package:flutter/material.dart';

class CitizenshipAdaptiveImageGrid extends StatelessWidget {
  const CitizenshipAdaptiveImageGrid({
    required this.itemCount,
    required this.itemBuilder,
    required this.childAspectRatio,
    this.spacing = 10,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double childAspectRatio;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columnCount(constraints.maxWidth),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    ),
  );

  int _columnCount(double width) {
    if (itemCount <= 1) return 1;
    if (width >= 600 && itemCount == 4) return 4;
    return 2;
  }
}
