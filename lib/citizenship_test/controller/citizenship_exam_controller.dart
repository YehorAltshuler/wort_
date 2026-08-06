import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/foundation.dart';

class CitizenshipExamController extends ChangeNotifier {
  CitizenshipExamController({
    required List<CitizenshipQuestion> questions,
    int initialIndex = 0,
    int? selectedAnswer,
  }) : _questions = List.unmodifiable(questions),
       _index = questions.isEmpty
           ? 0
           : initialIndex.clamp(0, questions.length - 1),
       _selectedAnswer = selectedAnswer;

  final List<CitizenshipQuestion> _questions;
  int _index;
  int? _selectedAnswer;
  bool _saving = false;

  List<CitizenshipQuestion> get questions => _questions;
  int get index => _index;
  int get total => _questions.length;
  int? get selectedAnswer => _selectedAnswer;
  bool get saving => _saving;
  bool get isEmpty => _questions.isEmpty;
  bool get isLastQuestion => !isEmpty && _index == _questions.length - 1;
  bool get canSelectAnswer => !isEmpty && _selectedAnswer == null && !_saving;
  bool get canContinue => _selectedAnswer != null && !_saving;
  CitizenshipQuestion? get currentQuestion =>
      isEmpty ? null : _questions[_index];

  bool selectAnswer(int answer) {
    if (!canSelectAnswer) return false;
    _selectedAnswer = answer;
    notifyListeners();
    return true;
  }

  void setSaving({required bool value}) {
    if (_saving == value) return;
    _saving = value;
    notifyListeners();
  }

  bool advance() {
    if (!canContinue || isLastQuestion) return false;
    _index++;
    _selectedAnswer = null;
    notifyListeners();
    return true;
  }
}
