import 'dart:math';

import 'package:course_repository/course_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:wort_flutter/learning/domain/training_exercise.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';

class WordTrainingController extends ChangeNotifier {
  WordTrainingController({
    required List<CourseWord> words,
    required CourseWordFilter filter,
    required this.difficulty,
    required this.languageCode,
    Random? random,
  }) : _allWords = words,
       _random = random ?? Random(),
       _queue = [...filter.apply(words)] {
    _queue.shuffle(_random);
  }

  final List<CourseWord> _allWords;
  final Random _random;
  final TrainingDifficulty difficulty;
  final String languageCode;
  List<CourseWord> _queue;
  final List<CourseWord> _mistakes = [];
  int _index = 0;
  int _correct = 0;
  int _wrong = 0;
  bool? _result;
  String? _selectedAnswer;
  TrainingExercise? _exercise;
  String? _exerciseWordId;

  int get index => _index;
  int get total => _queue.length;
  int get correct => _correct;
  int get wrong => _wrong;
  bool? get result => _result;
  String? get selectedAnswer => _selectedAnswer;
  bool get isComplete => _index >= _queue.length;
  bool get hasMistakes => _mistakes.isNotEmpty;
  CourseWord? get currentWord =>
      isComplete || _queue.isEmpty ? null : _queue[_index];

  TrainingExercise? get currentExercise {
    final word = currentWord;
    if (word == null) return null;
    if (_exerciseWordId != word.id) {
      _exerciseWordId = word.id;
      _exercise = createExercise(
        word: word,
        words: _allWords,
        difficulty: difficulty,
        languageCode: languageCode,
        random: _random,
      );
    }
    return _exercise;
  }

  bool? checkAnswer(String answer) {
    final word = currentWord;
    final exercise = currentExercise;
    if (_result != null || word == null || exercise == null) return null;
    if (answer.trim().isEmpty) return null;
    _selectedAnswer = answer;
    _result = exercise.check(answer);
    if (_result!) {
      _correct++;
    } else {
      _wrong++;
      _mistakes.add(word);
    }
    notifyListeners();
    return _result;
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

  void _resetAnswer() {
    _result = null;
    _selectedAnswer = null;
    _exercise = null;
    _exerciseWordId = null;
  }
}
