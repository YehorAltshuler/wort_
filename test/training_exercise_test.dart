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

  test('LID vocabulary choices show only one semicolon-separated meaning', () {
    const lidWord = CourseWord(
      id: 'leben-in-deutschland:module0.json:0',
      type: CourseWordType.other,
      term: 'abhängig',
      translations: {
        'ru': ['зависимый; подвластный'],
      },
    );
    const lidOther = CourseWord(
      id: 'leben-in-deutschland:module0.json:1',
      type: CourseWordType.other,
      term: 'Armee',
      translations: {
        'ru': ['армия; войско'],
      },
    );

    final exercise =
        createExercise(
              word: lidWord,
              words: const [lidWord, lidOther],
              difficulty: TrainingDifficulty.easy,
              languageCode: 'ru',
              random: Random(1),
            )
            as ChoiceExercise;

    expect(exercise.options, contains('зависимый'));
    expect(exercise.options, contains('армия'));
    expect(exercise.options.every((option) => !option.contains(';')), isTrue);
    expect(exercise.check('зависимый'), isTrue);
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
