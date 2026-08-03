import 'dart:math';

import 'package:course_repository/course_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/learning/domain/training_exercise.dart';

void main() {
  const noun = CourseWord(
    id: 'book:module1.json:0',
    type: CourseWordType.noun,
    term: 'Haus',
    article: ['das'],
    translations: {
      'ru': ['дом'],
    },
  );
  const other = CourseWord(
    id: 'book:module1.json:1',
    type: CourseWordType.other,
    term: 'Hallo',
    translations: {
      'ru': ['привет'],
    },
  );

  test('easy exercise asks for a translation', () {
    final exercise =
        createExercise(
              word: noun,
              words: const [noun, other],
              difficulty: TrainingDifficulty.easy,
              languageCode: 'ru',
              random: Random(1),
            )
            as ChoiceExercise;

    expect(exercise.question, 'Haus');
    expect(exercise.options, contains('дом'));
    expect(exercise.check('дом'), isTrue);
  });

  test('medium noun exercise checks the article', () {
    final exercise = createExercise(
      word: noun,
      words: const [noun, other],
      difficulty: TrainingDifficulty.medium,
      languageCode: 'ru',
    );

    expect(exercise.question, 'Haus');
    expect(exercise.check('das'), isTrue);
    expect(exercise.check('die'), isFalse);
  });

  test('hard exercise normalizes typed answers', () {
    final exercise = createExercise(
      word: noun,
      words: const [noun],
      difficulty: TrainingDifficulty.hard,
      languageCode: 'ru',
    );

    expect(exercise.check('  DAS HAUS '), isTrue);
  });
}
