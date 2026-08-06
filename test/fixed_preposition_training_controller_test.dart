import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/exercises/controller/fixed_preposition_training_controller.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';

void main() {
  const words = [
    FixedPrepositionVerb(
      id: '1',
      verb: 'warten',
      preposition: 'auf',
      grammaticalCase: 'Akkusativ',
      translations: {
        'en': ['wait for'],
      },
      example: 'Ich warte auf den Bus.',
    ),
    FixedPrepositionVerb(
      id: '2',
      verb: 'sprechen',
      preposition: 'mit',
      grammaticalCase: 'Dativ',
      translations: {
        'en': ['speak with'],
      },
      example: 'Ich spreche mit dem Lehrer.',
    ),
  ];
  const exercise = FixedPrepositionExercise(
    catalog: ExerciseCatalogItem(
      id: 'fixed',
      title: 'Fixed prepositions',
      descriptions: {},
    ),
    words: words,
  );

  test('tracks answers and retries only mistakes', () {
    final controller = FixedPrepositionTrainingController(
      exercise: exercise,
      progress: const LearningProgress(),
      filter: FixedPrepositionFilter.all,
      random: Random(1),
    );
    addTearDown(controller.dispose);

    final first = controller.currentWord!;
    controller
      ..selectFirstAnswer(first.translationFor('en'))
      ..selectCaseAnswer(first.grammaticalCase);
    expect(
      controller.check(
        correctFirst: first.translationFor('en'),
        grammaticalCase: first.grammaticalCase,
      ),
      isTrue,
    );
    controller.next();

    final second = controller.currentWord!;
    controller
      ..selectFirstAnswer('wrong')
      ..selectCaseAnswer(second.grammaticalCase);
    expect(
      controller.check(
        correctFirst: second.translationFor('en'),
        grammaticalCase: second.grammaticalCase,
      ),
      isFalse,
    );
    controller.next();

    expect(controller.isComplete, isTrue);
    expect(controller.correct, 1);
    expect(controller.wrong, 1);
    expect(controller.mistakes, [second]);

    controller.retryMistakes();
    expect(controller.total, 1);
    expect(controller.currentWord, second);
    expect(controller.correct, 0);
    expect(controller.wrong, 0);
    expect(controller.result, isNull);
  });

  test('filters queue from stored progress', () {
    final controller = FixedPrepositionTrainingController(
      exercise: exercise,
      progress: LearningProgress(
        incorrectWordIds: {words.first.progressId},
      ),
      filter: FixedPrepositionFilter.incorrect,
      random: Random(1),
    );
    addTearDown(controller.dispose);

    expect(controller.queue, [words.first]);
  });

  test('builds cloze text without UI context', () {
    final controller = FixedPrepositionTrainingController(
      exercise: exercise,
      progress: const LearningProgress(),
      filter: FixedPrepositionFilter.all,
      random: Random(1),
    );
    addTearDown(controller.dispose);

    expect(controller.cloze(words.first), 'Ich warte ... den Bus.');
  });
}
