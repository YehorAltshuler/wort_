import 'dart:math';

import 'package:course_repository/course_repository.dart';

enum TrainingDifficulty { easy, medium, hard }

sealed class TrainingExercise {
  const TrainingExercise({
    required this.question,
    required this.correctAnswers,
  });

  final String question;
  final List<String> correctAnswers;

  bool check(String answer) => correctAnswers.any(
    (value) => value.trim().toLowerCase() == answer.trim().toLowerCase(),
  );
}

class ChoiceExercise extends TrainingExercise {
  const ChoiceExercise({
    required super.question,
    required super.correctAnswers,
    required this.options,
  });

  final List<String> options;
}

class InputExercise extends TrainingExercise {
  const InputExercise({required super.question, required super.correctAnswers});
}

TrainingExercise createExercise({
  required CourseWord word,
  required List<CourseWord> words,
  required TrainingDifficulty difficulty,
  required String languageCode,
  Random? random,
}) {
  final translations = word.translationsFor(languageCode);
  final translation = _singleTranslation(word, translations) ?? word.term;
  if (difficulty == TrainingDifficulty.hard) {
    final answer = word.type == CourseWordType.noun && word.article.isNotEmpty
        ? '${word.article.join('/')} ${word.term}'
        : word.term;
    return InputExercise(
      question: translation,
      correctAnswers: [answer],
    );
  }
  if (difficulty == TrainingDifficulty.medium) {
    if (word.type == CourseWordType.noun && word.article.isNotEmpty) {
      return ChoiceExercise(
        question: word.term,
        correctAnswers: word.article,
        options: const ['der', 'die', 'das'],
      );
    }
    return _choice(
      question: translation,
      answers: [word.term],
      wrongAnswers: words
          .where((item) => item.type == word.type && item.id != word.id)
          .map((item) => item.term),
      random: random,
    );
  }
  return _choice(
    question: word.term,
    answers: [translation],
    wrongAnswers: words
        .where((item) => item.type == word.type && item.id != word.id)
        .map(
          (item) =>
              _singleTranslation(item, item.translationsFor(languageCode)) ??
              '',
        ),
    random: random,
  );
}

String? _singleTranslation(CourseWord word, List<String> translations) {
  final translation = translations.firstOrNull;
  if (translation == null || !word.id.startsWith('leben-in-deutschland:')) {
    return translation;
  }
  return translation.split(';').first.trim();
}

ChoiceExercise _choice({
  required String question,
  required List<String> answers,
  required Iterable<String> wrongAnswers,
  Random? random,
}) {
  final correct = answers.first;
  final wrong = wrongAnswers
      .where((value) => value.isNotEmpty && value != correct)
      .toSet()
      .toList()
    ..shuffle(random);
  final options = [correct, ...wrong.take(3)]..shuffle(random);
  return ChoiceExercise(
    question: question,
    correctAnswers: answers,
    options: options,
  );
}
