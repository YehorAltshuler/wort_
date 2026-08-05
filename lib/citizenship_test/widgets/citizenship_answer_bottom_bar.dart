import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';

class CitizenshipAnswerBottomBar extends StatelessWidget {
  const CitizenshipAnswerBottomBar({
    required this.question,
    required this.selectedAnswer,
    required this.primaryEnabled,
    required this.primaryLabel,
    required this.onPrimary,
    super.key,
  });

  final CitizenshipQuestion question;
  final int? selectedAnswer;
  final bool primaryEnabled;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) => TrainingBottomBar(
    result: selectedAnswer == null
        ? null
        : selectedAnswer == question.correctAnswer,
    correctAnswers: [question.answers[question.correctAnswer]],
    primaryEnabled: primaryEnabled,
    primaryLabel: primaryLabel,
    onPrimary: onPrimary,
  );
}
