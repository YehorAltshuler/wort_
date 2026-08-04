import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:wort_flutter/citizenship_test/widgets/image_answer_grid.dart';
import 'package:wort_flutter/citizenship_test/widgets/question_image.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_answer_tile.dart';
import 'package:wort_flutter/widgets/training_content_layout.dart';

class CitizenshipQuestionExercise extends StatelessWidget {
  const CitizenshipQuestionExercise({
    required this.question,
    required this.selectedAnswer,
    required this.enabled,
    required this.answerKeys,
    required this.answerStateFor,
    required this.onSelected,
    required this.onToggleFavorite,
    this.isFavorite = false,
    this.imageBeforeQuestion = true,
    this.scrollTogether = false,
    super.key,
  });

  final CitizenshipQuestion question;
  final int? selectedAnswer;
  final bool enabled;
  final List<GlobalKey> answerKeys;
  final TrainingAnswerState? Function(int answer) answerStateFor;
  final ValueChanged<int> onSelected;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;
  final bool imageBeforeQuestion;
  final bool scrollTogether;

  static bool usesImageAnswers(CitizenshipQuestion question) {
    if (question.images.length != 4 || question.answers.length != 4) {
      return false;
    }
    for (var index = 0; index < question.answers.length; index++) {
      if (question.answers[index].trim().toLowerCase() != 'bild ${index + 1}') {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final imageAnswers = usesImageAnswers(question);
    final questionImage = CitizenshipQuestionImage(
      questionId: question.id,
      hasImage: question.hasImage,
    );
    return TrainingContentLayout(
      answersBottomPadding: 8,
      scrollTogether: scrollTogether,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(context.l10n.lidQuestionNumber(question.num)),
              const Spacer(),
              IconButton(
                tooltip: context.l10n.lidFavoriteTooltip,
                icon: Icon(isFavorite ? Icons.star : Icons.star_outline),
                onPressed: onToggleFavorite,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!imageAnswers && imageBeforeQuestion) questionImage,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                question.text,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      ),
      answers: imageAnswers
          ? CitizenshipImageAnswerGrid(
              questionId: question.id,
              answers: question.answers,
              correctAnswer: question.correctAnswer,
              selectedAnswer: selectedAnswer,
              enabled: enabled,
              answerKeys: answerKeys,
              onSelected: onSelected,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!imageBeforeQuestion) questionImage,
                for (var answer = 0; answer < question.answers.length; answer++)
                  Padding(
                    key: answerKeys[answer],
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TrainingAnswerTile(
                      label: question.answers[answer],
                      position: answer,
                      selected: selectedAnswer == answer,
                      enabled: enabled,
                      answerState: answerStateFor(answer),
                      onSelected: () => onSelected(answer),
                    ),
                  ),
              ],
            ),
    );
  }
}
