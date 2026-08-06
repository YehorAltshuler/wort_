import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/exercises/controller/fixed_preposition_training_controller.dart';
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
  FixedPrepositionTrainingController? _controller;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeController());
  }

  Future<void> _initializeController() async {
    final exercise = await ref.read(fixedPrepositionExerciseProvider.future);
    final progress = await ref.read(learningProgressProvider.future);
    if (!mounted) return;
    final controller = FixedPrepositionTrainingController(
      exercise: exercise,
      progress: progress,
      filter: FixedPrepositionFilterX.fromName(widget.filter),
    )..addListener(_onControllerChanged);
    setState(() => _controller = controller);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller
      ?..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
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
        final controller = _controller;
        if (controller == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (controller.isComplete) {
          return Scaffold(
            appBar: AppBar(),
            body: ResponsiveContent(
              child: TrainingCompletionView(
                title: context.l10n.knowledgeCheckComplete,
                correct: controller.correct,
                incorrect: controller.wrong,
                total: controller.total,
                secondaryAction: !controller.hasMistakes
                    ? null
                    : TrainingCompletionAction(
                        label: context.l10n.retryMistakes,
                        onPressed: controller.retryMistakes,
                      ),
              ),
            ),
            bottomNavigationBar: BottomActionButton(
              label: context.l10n.finishAction,
              onPressed: () => context.pop(),
            ),
          );
        }
        final word = controller.currentWord!;
        final hard = widget.difficulty == 'hard';
        final languageCode = context.nativeLanguageCode;
        final firstOptions = controller.firstOptions(
          word: word,
          hard: hard,
          languageCode: languageCode,
        );
        final correctFirst = hard
            ? word.preposition
            : word.translationFor(languageCode);
        return _ExerciseTrainingScaffold(
          word: word,
          hard: hard,
          index: controller.index,
          total: controller.total,
          correct: controller.correct,
          wrong: controller.wrong,
          firstOptions: firstOptions,
          correctFirst: correctFirst,
          firstAnswer: controller.firstAnswer,
          caseAnswer: controller.caseAnswer,
          result: controller.result,
          cloze: controller.cloze(word),
          answerStateFor:
              ({
                required selectedAnswer,
                required option,
                required correctAnswer,
              }) => _answerState(
                result: controller.result,
                selectedAnswer: selectedAnswer,
                option: option,
                correctAnswer: correctAnswer,
              ),
          onFirstSelected: controller.selectFirstAnswer,
          onCaseSelected: controller.selectCaseAnswer,
          onPrimary: controller.result == null
              ? () => _check(controller, word, correctFirst)
              : controller.next,
        );
      },
    );
  }

  void _check(
    FixedPrepositionTrainingController controller,
    FixedPrepositionVerb word,
    String correctFirst,
  ) {
    final result = controller.check(
      correctFirst: correctFirst,
      grammaticalCase: word.grammaticalCase,
    );
    unawaited(
      ref
          .read(learningProgressProvider.notifier)
          .recordResult(word.progressId, correct: result),
    );
  }

  TrainingAnswerState? _answerState({
    required bool? result,
    required String? selectedAnswer,
    required String option,
    required String correctAnswer,
  }) {
    if (result == null) return null;
    if (option == correctAnswer) return TrainingAnswerState.correct;
    if (option == selectedAnswer) return TrainingAnswerState.incorrect;
    return null;
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
