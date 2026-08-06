import 'dart:math';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/citizenship_test/controller/citizenship_training_controller.dart';

void main() {
  final questions = [
    _question('q1', correctAnswer: 0),
    _question('q2', correctAnswer: 1),
    _question('q3', correctAnswer: 2),
  ];

  test('tracks answers and replaces the result when an answer changes', () {
    final controller = CitizenshipTrainingController(questions: questions);

    expect(controller.answer(3), isFalse);
    expect(controller.incorrect, 1);
    expect(controller.mistakes, [questions.first]);

    expect(controller.answer(0), isTrue);
    expect(controller.correct, 1);
    expect(controller.incorrect, 0);
    expect(controller.mistakes, isEmpty);
  });

  test('restores progress and retries only mistakes', () {
    final controller = CitizenshipTrainingController(
      questions: questions,
      initialIndex: 2,
      answeredQuestions: const {'q1': true, 'q2': false},
    );

    expect(controller.index, 2);
    expect(controller.correct, 1);
    expect(controller.incorrect, 1);

    controller.retryMistakes(Random(1));

    expect(controller.questions, [questions[1]]);
    expect(controller.index, 0);
    expect(controller.correct, 0);
    expect(controller.incorrect, 0);
  });
}

CitizenshipQuestion _question(String id, {required int correctAnswer}) =>
    CitizenshipQuestion.fromRecord(
      QuestionRecord(
        id: id,
        num: id.substring(1),
        question: id,
        answers: const ['a', 'b', 'c', 'd'],
        correctAnswer: correctAnswer,
        sortOrder: int.parse(id.substring(1)),
        scope: QuestionScope.general,
      ),
    );
