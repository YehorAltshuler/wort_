import 'dart:math';

import 'package:course_repository/course_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/learning/controller/word_training_controller.dart';
import 'package:wort_flutter/learning/domain/training_exercise.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';

void main() {
  const words = [
    CourseWord(
      id: 'noun',
      type: CourseWordType.noun,
      term: 'Haus',
      article: ['das'],
      translations: {
        'en': ['house'],
      },
    ),
    CourseWord(
      id: 'verb',
      type: CourseWordType.verb,
      term: 'gehen',
      translations: {
        'en': ['go'],
      },
    ),
  ];

  test('filters words and tracks a completed session', () {
    final controller = WordTrainingController(
      words: words,
      filter: CourseWordFilter.noun,
      difficulty: TrainingDifficulty.easy,
      languageCode: 'en',
      random: Random(1),
    );
    addTearDown(controller.dispose);

    expect(controller.total, 1);
    expect(controller.currentWord, words.first);
    expect(controller.currentExercise!.question, 'Haus');
    expect(controller.checkAnswer('house'), isTrue);
    expect(controller.correct, 1);

    controller.next();
    expect(controller.isComplete, isTrue);
  });

  test('retries only incorrectly answered words', () {
    final controller = WordTrainingController(
      words: words,
      filter: CourseWordFilter.all,
      difficulty: TrainingDifficulty.hard,
      languageCode: 'en',
      random: Random(2),
    );
    addTearDown(controller.dispose);

    final mistakenWord = controller.currentWord!;
    expect(controller.checkAnswer('wrong'), isFalse);
    controller.next();
    final second = controller.currentWord!;
    expect(
      controller.checkAnswer(controller.currentExercise!.correctAnswers.first),
      isTrue,
    );
    controller.next();

    expect(controller.isComplete, isTrue);
    controller.retryMistakes();
    expect(controller.total, 1);
    expect(controller.currentWord, mistakenWord);
    expect(controller.correct, 0);
    expect(controller.wrong, 0);
    expect(second, isNot(mistakenWord));
  });
}
