import 'dart:math';

import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/foundation.dart';

class CitizenshipTrainingController extends ChangeNotifier {
  CitizenshipTrainingController({
    required List<CitizenshipQuestion> questions,
    Map<String, bool> answeredQuestions = const {},
    int initialIndex = 0,
  }) : _questions = List.of(questions),
       _answers = Map.of(answeredQuestions),
       _index = initialIndex.clamp(0, questions.length) {
    _rebuildResults();
  }

  List<CitizenshipQuestion> _questions;
  final Map<String, bool> _answers;
  final List<CitizenshipQuestion> _mistakes = [];
  int _index;
  int? _selectedAnswer;
  int _correct = 0;
  int _incorrect = 0;

  List<CitizenshipQuestion> get questions => List.unmodifiable(_questions);
  List<CitizenshipQuestion> get mistakes => List.unmodifiable(_mistakes);
  int get index => _index;
  int? get selectedAnswer => _selectedAnswer;
  int get correct => _correct;
  int get incorrect => _incorrect;
  int get total => _questions.length;
  bool get isComplete => _index >= _questions.length;
  bool get hasMistakes => _mistakes.isNotEmpty;
  CitizenshipQuestion? get currentQuestion =>
      isComplete || _questions.isEmpty ? null : _questions[_index];

  bool answer(int answer) {
    final question = currentQuestion;
    if (question == null) return false;
    final isCorrect = answer == question.correctAnswer;
    _selectedAnswer = answer;
    _answers[question.id] = isCorrect;
    _rebuildResults();
    notifyListeners();
    return isCorrect;
  }

  void next() {
    if (!isComplete) _index++;
    _selectedAnswer = null;
    notifyListeners();
  }

  void jumpTo(int index) {
    if (index < 0 || index >= _questions.length) return;
    _index = index;
    _selectedAnswer = null;
    notifyListeners();
  }

  void retryMistakes([Random? random]) {
    _questions = List.of(_mistakes)..shuffle(random);
    _answers.clear();
    _index = 0;
    _selectedAnswer = null;
    _rebuildResults();
    notifyListeners();
  }

  void _rebuildResults() {
    _correct = _answers.values.where((value) => value).length;
    _incorrect = _answers.values.where((value) => !value).length;
    _mistakes
      ..clear()
      ..addAll(
        _questions.where((question) => _answers[question.id] == false),
      );
  }
}
