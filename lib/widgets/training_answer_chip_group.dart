import 'package:flutter/material.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';

class TrainingAnswerChipGroup extends StatelessWidget {
  const TrainingAnswerChipGroup({
    required this.options,
    required this.selectedValue,
    required this.enabled,
    required this.answerStateFor,
    required this.onSelected,
    this.bottomPadding = 0,
    super.key,
  });

  final List<String> options;
  final String? selectedValue;
  final bool enabled;
  final TrainingAnswerState? Function(String option) answerStateFor;
  final ValueChanged<String> onSelected;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final option in options)
            TrainingAnswerChip(
              key: ValueKey(option),
              label: option,
              selected: selectedValue == option,
              enabled: enabled,
              answerState: answerStateFor(option),
              onSelected: () => onSelected(option),
            ),
        ],
      ),
    );
  }
}
