import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/l10n/native_language_scope.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_answer_chip_group.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';
import 'package:wort_flutter/widgets/training_completion_view.dart';
import 'package:wort_flutter/widgets/training_content_layout.dart';
import 'package:wort_flutter/widgets/training_progress_indicator.dart';

class ExerciseTrainingPage extends ConsumerStatefulWidget {
  const ExerciseTrainingPage({
    required this.exerciseId,
    required this.difficulty,
    required this.filter,
    super.key,
  });

  final String exerciseId;
  final String difficulty;
  final String filter;

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
  final List<FixedPrepositionVerb> _mistakes = [];

  @override
  void initState() {
    super.initState();
    unawaited(_initializeQueue());
  }

  Future<void> _initializeQueue() async {
    final exercise = await ref.read(fixedPrepositionExerciseProvider.future);
    final progress = await ref.read(learningProgressProvider.future);
    if (mounted) {
      final filter = FixedPrepositionFilterX.fromName(widget.filter);
      final words = switch (filter) {
        FixedPrepositionFilter.all => exercise.words,
        FixedPrepositionFilter.correct =>
          exercise.words
              .where((word) => progress.isTested(word.progressId))
              .toList(),
        FixedPrepositionFilter.incorrect =>
          exercise.words
              .where((word) => progress.isIncorrect(word.progressId))
              .toList(),
      };
      setState(() => _queue = [...words]..shuffle(Random()));
    }
  }

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
      data: (exercise) {
        final queue = _queue;
        if (queue == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (_index >= queue.length) {
          return Scaffold(
            appBar: AppBar(),
            body: ResponsiveContent(
              child: TrainingCompletionView(
                title: context.l10n.knowledgeCheckComplete,
                correct: _correct,
                incorrect: _wrong,
                total: queue.length,
                secondaryAction: _mistakes.isEmpty
                    ? null
                    : TrainingCompletionAction(
                        label: context.l10n.retryMistakes,
                        onPressed: _retryMistakes,
                      ),
              ),
            ),
            bottomNavigationBar: BottomActionButton(
              label: context.l10n.finishAction,
              onPressed: () => context.pop(),
            ),
          );
        }
        final word = queue[_index];
        final hard = widget.difficulty == 'hard';
        final firstOptions = _firstOptionsFor(exercise, word, hard);
        final correctFirst = hard
            ? word.preposition
            : word.translationFor(
                context.nativeLanguageCode,
              );
        return _ExerciseTrainingScaffold(
          word: word,
          hard: hard,
          index: _index,
          total: queue.length,
          correct: _correct,
          wrong: _wrong,
          firstOptions: firstOptions,
          correctFirst: correctFirst,
          firstAnswer: _firstAnswer,
          caseAnswer: _caseAnswer,
          result: _result,
          cloze: _cloze(word),
          answerStateFor: _answerState,
          onFirstSelected: (value) => setState(() => _firstAnswer = value),
          onCaseSelected: (value) => setState(() => _caseAnswer = value),
          onPrimary: _result == null ? () => _check(word, hard) : _next,
        );
      },
    );
  }

  void _check(FixedPrepositionVerb word, bool hard) {
    final languageCode = context.nativeLanguageCode;
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
        if (!_mistakes.contains(word)) _mistakes.add(word);
      }
    });
    unawaited(
      ref
          .read(learningProgressProvider.notifier)
          .recordResult(word.progressId, correct: _result!),
    );
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
    final languageCode = context.nativeLanguageCode;
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

  void _retryMistakes() => setState(() {
    _queue = [..._mistakes]..shuffle(Random());
    _mistakes.clear();
    _index = 0;
    _correct = 0;
    _wrong = 0;
    _firstAnswer = null;
    _caseAnswer = null;
    _result = null;
    _firstOptions = null;
    _firstOptionsKey = null;
  });

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

class _ExerciseTrainingScaffold extends StatelessWidget {
  const _ExerciseTrainingScaffold({
    required this.word,
    required this.hard,
    required this.index,
    required this.total,
    required this.correct,
    required this.wrong,
    required this.firstOptions,
    required this.correctFirst,
    required this.firstAnswer,
    required this.caseAnswer,
    required this.result,
    required this.cloze,
    required this.answerStateFor,
    required this.onFirstSelected,
    required this.onCaseSelected,
    required this.onPrimary,
  });

  final FixedPrepositionVerb word;
  final bool hard;
  final int index;
  final int total;
  final int correct;
  final int wrong;
  final List<String> firstOptions;
  final String correctFirst;
  final String? firstAnswer;
  final String? caseAnswer;
  final bool? result;
  final String cloze;
  final TrainingAnswerState? Function({
    required String? selectedAnswer,
    required String option,
    required String correctAnswer,
  })
  answerStateFor;
  final ValueChanged<String> onFirstSelected;
  final ValueChanged<String> onCaseSelected;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    final ready = firstAnswer != null && caseAnswer != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.exercisesTitle),
        actions: [
          Center(child: Text('${index + 1} / $total')),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: TrainingProgressIndicator(
            correctProgress: correct / total,
            incorrectProgress: wrong / total,
          ),
        ),
      ),
      body: ResponsiveContent(
        child: TrainingContentLayout(
          header: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ExerciseSectionLabel(
                hard
                    ? context.l10n.fixedPrepositionPrompt
                    : context.l10n.chooseTranslationAndCase,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    hard ? cloze : word.example,
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
              _ExerciseSectionLabel(
                hard ? context.l10n.preposition : context.l10n.translationTitle,
              ),
              const SizedBox(height: 8),
              TrainingAnswerChipGroup(
                options: firstOptions,
                selectedValue: firstAnswer,
                enabled: result == null,
                answerStateFor: (option) => answerStateFor(
                  selectedAnswer: firstAnswer,
                  option: option,
                  correctAnswer: correctFirst,
                ),
                onSelected: onFirstSelected,
              ),
              const SizedBox(height: 20),
              _ExerciseSectionLabel(
                context.l10n.grammaticalCase,
              ),
              const SizedBox(height: 8),
              TrainingAnswerChipGroup(
                options: const ['Akkusativ', 'Dativ'],
                selectedValue: caseAnswer,
                enabled: result == null,
                answerStateFor: (option) => answerStateFor(
                  selectedAnswer: caseAnswer,
                  option: option,
                  correctAnswer: word.grammaticalCase,
                ),
                onSelected: onCaseSelected,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TrainingBottomBar(
        result: result,
        correctAnswers: [correctFirst, word.grammaticalCase],
        primaryLabel: result == null
            ? context.l10n.checkAnswer
            : context.l10n.continueAction,
        primaryEnabled: result != null || ready,
        onPrimary: onPrimary,
      ),
    );
  }
}

class _ExerciseSectionLabel extends StatelessWidget {
  const _ExerciseSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
