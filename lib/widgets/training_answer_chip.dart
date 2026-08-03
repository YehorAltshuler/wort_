import 'package:flutter/material.dart';

enum TrainingAnswerState { correct, incorrect }

class TrainingAnswerChip extends StatelessWidget {
  const TrainingAnswerChip({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    this.answerState,
    super.key,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onSelected;
  final TrainingAnswerState? answerState;

  static Color correctColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.green.shade300
        : Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final feedbackColor = switch (answerState) {
      TrainingAnswerState.correct => correctColor(context),
      TrainingAnswerState.incorrect => colors.error,
      null => null,
    };
    final backgroundColor = feedbackColor == null
        ? colors.surface
        : feedbackColor.withValues(alpha: 0.14);
    final foregroundColor = feedbackColor ?? colors.onSurface;
    final borderColor =
        feedbackColor ?? (selected ? colors.primary : colors.outlineVariant);

    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      child: ExcludeSemantics(
        child: IgnorePointer(
          ignoring: !enabled,
          child: ChoiceChip(
            label: Text(label),
            labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            showCheckmark: false,
            backgroundColor: backgroundColor,
            selectedColor: backgroundColor,
            side: BorderSide(
              color: borderColor,
              width: answerState != null || selected ? 2 : 1,
            ),
            selected: selected,
            onSelected: (_) => onSelected(),
          ),
        ),
      ),
    );
  }
}
