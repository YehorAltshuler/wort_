import 'package:flutter/material.dart';

class TrainingProgressIndicator extends StatelessWidget {
  const TrainingProgressIndicator({
    required this.correctProgress,
    required this.incorrectProgress,
    super.key,
  });

  final double correctProgress;
  final double incorrectProgress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final correct = correctProgress.clamp(0.0, 1.0);
    final incorrect = incorrectProgress.clamp(0.0, 1.0 - correct);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: ColoredBox(
        color: colors.surfaceContainerHighest,
        child: SizedBox(
          height: 4,
          child: TweenAnimationBuilder<Offset>(
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeOutCubic,
            tween: Tween(
              begin: Offset.zero,
              end: Offset(correct, incorrect),
            ),
            builder: (context, progress, child) => LayoutBuilder(
              builder: (context, constraints) {
                final correctWidth = constraints.maxWidth * progress.dx;
                final incorrectWidth = constraints.maxWidth * progress.dy;
                return Stack(
                  children: [
                    PositionedDirectional(
                      start: 0,
                      width: correctWidth,
                      top: 0,
                      bottom: 0,
                      child: ColoredBox(color: colors.primary),
                    ),
                    PositionedDirectional(
                      start: correctWidth,
                      width: incorrectWidth,
                      top: 0,
                      bottom: 0,
                      child: ColoredBox(
                        color: colors.primary.withValues(alpha: 0.32),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
