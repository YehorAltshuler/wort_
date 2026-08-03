import 'package:flutter/material.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';

class TrainingAnswerTile extends StatelessWidget {
  const TrainingAnswerTile({
    required this.label,
    required this.position,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    this.answerState,
    super.key,
  });

  final String label;
  final int position;
  final bool selected;
  final bool enabled;
  final VoidCallback onSelected;
  final TrainingAnswerState? answerState;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final feedbackColor = switch (answerState) {
      TrainingAnswerState.correct => TrainingAnswerChip.correctColor(context),
      TrainingAnswerState.incorrect => colors.error,
      null => null,
    };
    final foregroundColor = feedbackColor ?? colors.onSurface;
    final borderColor =
        feedbackColor ?? (selected ? colors.primary : colors.outlineVariant);
    final backgroundColor = feedbackColor == null
        ? colors.surfaceContainerLow
        : feedbackColor.withValues(alpha: 0.14);

    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      child: ExcludeSemantics(
        child: IgnorePointer(
          ignoring: !enabled,
          child: Card(
            margin: EdgeInsets.zero,
            color: backgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: borderColor,
                width: answerState != null || selected ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              onTap: onSelected,
              minTileHeight: 64,
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: borderColor.withValues(alpha: 0.14),
                foregroundColor: foregroundColor,
                child: Text(String.fromCharCode(65 + position)),
              ),
              title: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
