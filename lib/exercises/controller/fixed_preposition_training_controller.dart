import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';

class FixedPrepositionTrainingController extends ChangeNotifier {
  FixedPrepositionTrainingController({
    required FixedPrepositionExercise exercise,
    required LearningProgress progress,
    required FixedPrepositionFilter filter,
    Random? random,
  }) : _exercise = exercise,
       _random = random ?? Random(),
       _queue = _filteredWords(exercise.words, progress, filter) {
    _queue.shuffle(_random);
  }

  final FixedPrepositionExercise _exercise;
  final Random _random;
  List<FixedPrepositionVerb> _queue;
  final List<FixedPrepositionVerb> _mistakes = [];
  int _index = 0;
  String? _firstAnswer;
  String? _caseAnswer;
  bool? _result;
  List<String>? _firstOptions;
  String? _firstOptionsKey;
  int _correct = 0;
  int _wrong = 0;

  List<FixedPrepositionVerb> get queue => List.unmodifiable(_queue);
  List<FixedPrepositionVerb> get mistakes => List.unmodifiable(_mistakes);
  int get index => _index;
  int get total => _queue.length;
  int get correct => _correct;
  int get wrong => _wrong;
  String? get firstAnswer => _firstAnswer;
  String? get caseAnswer => _caseAnswer;
  bool? get result => _result;
  bool get isComplete => _index >= _queue.length;
  bool get hasMistakes => _mistakes.isNotEmpty;
  FixedPrepositionVerb? get currentWord =>
      isComplete || _queue.isEmpty ? null : _queue[_index];

  void selectFirstAnswer(String value) {
    if (_result != null) return;
    _firstAnswer = value;
    notifyListeners();
  }

  void selectCaseAnswer(String value) {
    if (_result != null) return;
    _caseAnswer = value;
    notifyListeners();
  }

  bool check({required String correctFirst, required String grammaticalCase}) {
    if (_result != null) return _result!;
    _result = _firstAnswer == correctFirst && _caseAnswer == grammaticalCase;
    if (_result!) {
      _correct++;
    } else {
      _wrong++;
      final word = currentWord;
      if (word != null && !_mistakes.contains(word)) _mistakes.add(word);
    }
    notifyListeners();
    return _result!;
  }

  void next() {
    if (_result == null) return;
    _index++;
    _resetAnswer();
    notifyListeners();
  }

  void retryMistakes() {
    _queue = [..._mistakes]..shuffle(_random);
    _mistakes.clear();
    _index = 0;
    _correct = 0;
    _wrong = 0;
    _resetAnswer();
    notifyListeners();
  }

  List<String> firstOptions({
    required FixedPrepositionVerb word,
    required bool hard,
    required String languageCode,
  }) {
    final key = '${word.id}:$hard:$languageCode';
    if (_firstOptionsKey != key) {
      _firstOptionsKey = key;
      _firstOptions = hard
          ? _options(
              word.preposition,
              _exercise.words.map((item) => item.preposition),
            )
          : _options(
              word.translationFor(languageCode),
              _exercise.words.map(
                (item) => item.translationFor(languageCode),
              ),
            );
    }
    return List.unmodifiable(_firstOptions!);
  }

  String cloze(FixedPrepositionVerb word) {
    const contractions = {'bei': 'beim', 'von': 'vom', 'zu': 'zum'};
    final contraction = contractions[word.preposition];
    if (contraction != null && word.example.contains(contraction)) {
      return word.example.replaceFirst(contraction, '... dem');
    }
    return word.example.replaceFirst(
      RegExp(
        '\\b${RegExp.escape(word.preposition)}\\b',
        caseSensitive: false,
      ),
      '...',
    );
  }

  void _resetAnswer() {
    _firstAnswer = null;
    _caseAnswer = null;
    _result = null;
    _firstOptions = null;
    _firstOptionsKey = null;
  }

  List<String> _options(String correct, Iterable<String> alternatives) {
    final wrong = alternatives
        .where((value) => value != correct)
        .toSet()
        .take(3);
    return [correct, ...wrong]..shuffle(_random);
  }

  static List<FixedPrepositionVerb> _filteredWords(
    List<FixedPrepositionVerb> words,
    LearningProgress progress,
    FixedPrepositionFilter filter,
  ) => switch (filter) {
    FixedPrepositionFilter.all => [...words],
    FixedPrepositionFilter.correct =>
      words.where((word) => progress.isTested(word.progressId)).toList(),
    FixedPrepositionFilter.incorrect =>
      words.where((word) => progress.isIncorrect(word.progressId)).toList(),
  };
}
