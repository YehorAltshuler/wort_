import 'package:flutter/material.dart';

typedef AdaptiveStatCardBuilder =
    Widget Function(BuildContext context, {required bool fillHeight});

class AdaptiveStatCardRow extends StatelessWidget {
  const AdaptiveStatCardRow({
    required this.firstBuilder,
    required this.secondBuilder,
    this.breakpoint = 600,
    this.spacing = 12,
    super.key,
  });

  final AdaptiveStatCardBuilder firstBuilder;
  final AdaptiveStatCardBuilder secondBuilder;
  final double breakpoint;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < breakpoint;
      Widget item(AdaptiveStatCardBuilder builder) => compact
          ? AspectRatio(
              aspectRatio: 1,
              child: builder(context, fillHeight: true),
            )
          : builder(context, fillHeight: false);
      final row = Row(
        crossAxisAlignment: compact
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.stretch,
        children: [
          Expanded(child: item(firstBuilder)),
          SizedBox(width: spacing),
          Expanded(child: item(secondBuilder)),
        ],
      );
      return compact ? row : IntrinsicHeight(child: row);
    },
  );
}
