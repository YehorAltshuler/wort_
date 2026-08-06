import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/citizenship_test/controller/citizenship_exam_controller.dart';

void main() {
  test('restores position and selected answer', () {
    final controller = CitizenshipExamController(
      questions: [_question('1'), _question('2')],
      initialIndex: 1,
      selectedAnswer: 2,
    );

    expect(controller.index, 1);
    expect(controller.selectedAnswer, 2);
    expect(controller.isLastQuestion, isTrue);
    expect(controller.canContinue, isTrue);
  });

  test('accepts one answer and advances after saving', () {
    final controller = CitizenshipExamController(
      questions: [_question('1'), _question('2')],
    );

    expect(controller.selectAnswer(1), isTrue);
    expect(controller.selectAnswer(2), isFalse);
    controller.setSaving(value: true);
    expect(controller.canContinue, isFalse);

    controller.setSaving(value: false);
    expect(controller.advance(), isTrue);
    expect(controller.index, 1);
    expect(controller.selectedAnswer, isNull);
  });

  test('handles an empty question set', () {
    final controller = CitizenshipExamController(
      questions: const [],
      initialIndex: 10,
    );

    expect(controller.isEmpty, isTrue);
    expect(controller.currentQuestion, isNull);
    expect(controller.selectAnswer(0), isFalse);
    expect(controller.advance(), isFalse);
  });
}

CitizenshipQuestion _question(String id) => CitizenshipQuestion.fromRecord(
  QuestionRecord(
    id: id,
    num: id,
    question: id,
    answers: const ['a', 'b', 'c', 'd'],
    correctAnswer: 0,
    sortOrder: int.parse(id),
    scope: QuestionScope.general,
  ),
);
