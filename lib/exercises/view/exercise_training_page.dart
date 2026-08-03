import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_answer_chip_group.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';
import 'package:wort_flutter/widgets/training_content_layout.dart';
import 'package:wort_flutter/widgets/training_progress_indicator.dart';

class ExerciseTrainingPage extends ConsumerStatefulWidget {
  const ExerciseTrainingPage({
    required this.exerciseId,
    required this.difficulty,
    super.key,
  });

  final String exerciseId;
  final String difficulty;

  @override
  ConsumerState<ExerciseTrainingPage> createState() =>
      _ExerciseTrainingPageState();
}

class _ExerciseTrainingPageState extends ConsumerState<ExerciseTrainingPage> {
  List<FixedPrepositionVerb>? _queue;
  int _index = 0;
  String? _firstAnswer;
  String? _caseAnswer;
  bool? _result;
  List<String>? _firstOptions;
  String? _firstOptionsKey;
  int _correct = 0;
  int _wrong = 0;

  @override
  Widget build(BuildContext context) {
    final exercise = ref.watch(fixedPrepositionExerciseProvider);
    return exercise.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text(context.l10n.courseLoadError)),
      ),
      data: _buildTraining,
    );
  }

  Widget _buildTraining(FixedPrepositionExercise exercise) {
    _queue ??= [...exercise.words]..shuffle(Random());
    if (_index >= _queue!.length) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            context.l10n.knowledgeCheckComplete,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      );
    }
    final word = _queue![_index];
    final hard = widget.difficulty == 'hard';
    final firstOptions = _firstOptionsFor(exercise, word, hard);
    final correctFirst = hard
        ? word.preposition
        : word.translationFor(Localizations.localeOf(context).languageCode);
    final ready = _firstAnswer != null && _caseAnswer != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.exercisesTitle),
        actions: [
          Center(child: Text('${_index + 1} / ${_queue!.length}')),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: TrainingProgressIndicator(
            correctProgress: _correct / _queue!.length,
            incorrectProgress: _wrong / _queue!.length,
          ),
        ),
      ),
      body: TrainingContentLayout(
        header: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              hard
                  ? context.l10n.fixedPrepositionPrompt
                  : context.l10n.chooseTranslationAndCase,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  hard ? _cloze(word) : word.example,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ],
        ),
        answers: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              hard ? context.l10n.preposition : context.l10n.translationTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TrainingAnswerChipGroup(
              options: firstOptions,
              selectedValue: _firstAnswer,
              enabled: _result == null,
              answerStateFor: (option) => _answerState(
                selectedAnswer: _firstAnswer,
                option: option,
                correctAnswer: correctFirst,
              ),
              onSelected: (option) => setState(() => _firstAnswer = option),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.grammaticalCase,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TrainingAnswerChipGroup(
              options: const ['Akkusativ', 'Dativ'],
              selectedValue: _caseAnswer,
              enabled: _result == null,
              answerStateFor: (option) => _answerState(
                selectedAnswer: _caseAnswer,
                option: option,
                correctAnswer: word.grammaticalCase,
              ),
              onSelected: (option) => setState(() => _caseAnswer = option),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TrainingBottomBar(
        result: _result,
        correctAnswers: [correctFirst, word.grammaticalCase],
        primaryLabel: _result == null
            ? context.l10n.checkAnswer
            : context.l10n.continueAction,
        primaryEnabled: _result != null || ready,
        onPrimary: _result == null ? () => _check(word, hard) : _next,
      ),
    );
  }

  void _check(FixedPrepositionVerb word, bool hard) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final correctFirst = hard
        ? word.preposition
        : word.translationFor(languageCode);
    setState(() {
      _result =
          _firstAnswer == correctFirst && _caseAnswer == word.grammaticalCase;
      if (_result!) {
        _correct++;
      } else {
        _wrong++;
      }
    });
  }

  TrainingAnswerState? _answerState({
    required String? selectedAnswer,
    required String option,
    required String correctAnswer,
  }) {
    if (_result == null) return null;
    if (option == correctAnswer) return TrainingAnswerState.correct;
    if (option == selectedAnswer) return TrainingAnswerState.incorrect;
    return null;
  }

  List<String> _firstOptionsFor(
    FixedPrepositionExercise exercise,
    FixedPrepositionVerb word,
    bool hard,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final key = '${word.verb}:$hard:$languageCode';
    if (_firstOptionsKey != key) {
      _firstOptionsKey = key;
      _firstOptions = hard
          ? _options(
              word.preposition,
              exercise.words.map((item) => item.preposition),
            )
          : _options(
              word.translationFor(languageCode),
              exercise.words.map(
                (item) => item.translationFor(languageCode),
              ),
            );
    }
    return _firstOptions!;
  }

  void _next() {
    setState(() {
      _index++;
      _firstAnswer = null;
      _caseAnswer = null;
      _result = null;
      _firstOptions = null;
      _firstOptionsKey = null;
    });
  }

  List<String> _options(String correct, Iterable<String> alternatives) {
    final wrong = alternatives
        .where((value) => value != correct)
        .toSet()
        .take(3);
    return [correct, ...wrong]..shuffle(Random());
  }

  String _cloze(FixedPrepositionVerb word) {
    const contractions = {'bei': 'beim', 'von': 'vom', 'zu': 'zum'};
    final contraction = contractions[word.preposition];
    if (contraction != null && word.example.contains(contraction)) {
      return word.example.replaceFirst(contraction, '... dem');
    }
    return word.example.replaceFirst(
      RegExp('\\b${RegExp.escape(word.preposition)}\\b', caseSensitive: false),
      '...',
    );
  }
}
