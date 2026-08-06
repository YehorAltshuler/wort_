import 'dart:async';

import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/collections/widgets/collection_actions.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/l10n/native_language_scope.dart';
import 'package:wort_flutter/learning/controller/word_training_controller.dart';
import 'package:wort_flutter/learning/domain/training_exercise.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/settings/widgets/noun_indicator.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_answer_chip_group.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';
import 'package:wort_flutter/widgets/training_completion_view.dart';
import 'package:wort_flutter/widgets/training_content_layout.dart';
import 'package:wort_flutter/widgets/training_progress_indicator.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({
    required this.bookId,
    required this.moduleFile,
    required this.type,
    required this.difficulty,
    this.collectionId,
    super.key,
  });

  const SessionPage.collection({
    required this.collectionId,
    required this.type,
    required this.difficulty,
    super.key,
  }) : bookId = null,
       moduleFile = null;

  final String? bookId;
  final String? moduleFile;
  final String? collectionId;
  final String type;
  final String difficulty;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  WordTrainingController? _training;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(_initializeController());
  }

  Future<void> _initializeController() async {
    final words = widget.collectionId == null
        ? await ref.read(
            moduleWordsProvider(
              (bookId: widget.bookId!, moduleFile: widget.moduleFile!),
            ).future,
          )
        : await ref.read(collectionWordsProvider(widget.collectionId!).future);
    if (!mounted) return;
    final training = WordTrainingController(
      words: words,
      filter: CourseWordFilterX.fromName(widget.type),
      difficulty: _difficulty,
      languageCode: context.nativeLanguageCode,
    )..addListener(_onTrainingChanged);
    setState(() => _training = training);
  }

  void _onTrainingChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _training
      ?..removeListener(_onTrainingChanged)
      ..dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.collectionId == null
        ? ref.watch(
            moduleWordsProvider(
              (bookId: widget.bookId!, moduleFile: widget.moduleFile!),
            ),
          )
        : ref.watch(collectionWordsProvider(widget.collectionId!));
    final session = words.maybeWhen(
      data: (items) {
        final training = _training;
        final total = training?.total ?? 0;
        return (
          total: total,
          correctProgress: total == 0 ? 0.0 : training!.correct / total,
          incorrectProgress: total == 0 ? 0.0 : training!.wrong / total,
        );
      },
      orElse: () => (
        total: 0,
        correctProgress: 0.0,
        incorrectProgress: 0.0,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.knowledgeCheckTitle),
        actions: [
          if (session.total > 0)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Center(
                child: Text(
                  '${((_training?.index ?? 0) + 1).clamp(1, session.total)} / ${session.total}',
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: TrainingProgressIndicator(
            correctProgress: session.correctProgress,
            incorrectProgress: session.incorrectProgress,
          ),
        ),
      ),
      body: ResponsiveContent(
        child: words.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(context.l10n.courseLoadError),
          ),
          data: (allWords) {
            final training = _training;
            if (training == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (training.total == 0) {
              return Center(child: Text(context.l10n.noWords));
            }
            if (training.isComplete) {
              return TrainingCompletionView(
                title: context.l10n.knowledgeCheckComplete,
                correct: training.correct,
                incorrect: training.wrong,
                total: training.total,
                secondaryAction: !training.hasMistakes
                    ? null
                    : TrainingCompletionAction(
                        label: context.l10n.retryMistakes,
                        onPressed: () {
                          training.retryMistakes();
                          _answerController.clear();
                        },
                      ),
              );
            }
            final word = training.currentWord!;
            final exercise = training.currentExercise!;
            final articleExercise =
                word.type == CourseWordType.noun &&
                _difficulty != TrainingDifficulty.easy;
            return _SessionTrainingContent(
              word: word,
              exercise: exercise,
              prompt: _prompt(context),
              showNounIndicator:
                  word.article.isNotEmpty &&
                  (!articleExercise || training.result != null),
              result: training.result,
              selectedAnswer: training.selectedAnswer,
              answerController: _answerController,
              answerBorderColor: _answerBorderColor(context),
              answerStateFor: (option) => _answerState(training, option),
              onChoiceSelected: (option) =>
                  _checkAnswer(training, word, option),
              onInputChanged: () => setState(() {}),
              onInputSubmitted: (answer) =>
                  _checkAnswer(training, word, answer),
            );
          },
        ),
      ),
      bottomNavigationBar: words.maybeWhen(
        data: (allWords) {
          final training = _training;
          if (training == null || training.total == 0) return null;
          if (training.isComplete) {
            return BottomActionButton(
              label: context.l10n.backToModule,
              onPressed: () => context.pop(),
            );
          }
          final word = training.currentWord!;
          final currentExercise = training.currentExercise!;
          return _SessionBottomBar(
            word: word,
            exercise: currentExercise,
            result: training.result,
            inputReady: _answerController.text.trim().isNotEmpty,
            onShowDetails: word.dictionaryId == null
                ? null
                : () => context.push(AppRoute.wordDetails(word.dictionaryId!)),
            onNext: () {
              training.next();
              _answerController.clear();
            },
            onCheck: () => _checkAnswer(
              training,
              word,
              _answerController.text,
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }

  TrainingDifficulty get _difficulty => switch (widget.difficulty) {
    'medium' => TrainingDifficulty.medium,
    'hard' => TrainingDifficulty.hard,
    _ => TrainingDifficulty.easy,
  };

  String _prompt(BuildContext context) => switch (_difficulty) {
    TrainingDifficulty.easy => context.l10n.difficultyEasyDescription,
    TrainingDifficulty.medium => context.l10n.difficultyMediumDescription,
    TrainingDifficulty.hard => context.l10n.difficultyHardDescription,
  };

  Color _answerBorderColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (_training?.result == null) return colors.outlineVariant;
    if (_training?.result == false) return colors.error;
    return TrainingAnswerChip.correctColor(context);
  }

  TrainingAnswerState? _answerState(
    WordTrainingController training,
    String option,
  ) {
    final exercise = training.currentExercise;
    if (exercise is! ChoiceExercise) return null;
    if (training.result == null) return null;
    if (exercise.check(option)) return TrainingAnswerState.correct;
    if (training.selectedAnswer == option) return TrainingAnswerState.incorrect;
    return null;
  }

  void _checkAnswer(
    WordTrainingController training,
    CourseWord word,
    String answer,
  ) {
    final correct = training.checkAnswer(answer);
    if (correct == null) return;
    unawaited(
      ref
          .read(learningProgressProvider.notifier)
          .recordResult(word.id, correct: correct),
    );
  }
}

class _SessionBottomBar extends StatelessWidget {
  const _SessionBottomBar({
    required this.word,
    required this.exercise,
    required this.result,
    required this.inputReady,
    required this.onShowDetails,
    required this.onNext,
    required this.onCheck,
  });

  final CourseWord word;
  final TrainingExercise exercise;
  final bool? result;
  final bool inputReady;
  final VoidCallback? onShowDetails;
  final VoidCallback onNext;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) => TrainingBottomBar(
    result: result,
    correctAnswers: exercise.correctAnswers,
    primaryEnabled: result != null || (exercise is InputExercise && inputReady),
    primaryLabel: result == null && exercise is InputExercise
        ? context.l10n.checkAnswer
        : context.l10n.continueAction,
    secondaryLabel: context.l10n.wordDetailsAction,
    secondaryEnabled: result != null && word.dictionaryId != null,
    onSecondary: onShowDetails,
    onPrimary: result != null ? onNext : onCheck,
  );
}

class _SessionTrainingContent extends StatelessWidget {
  const _SessionTrainingContent({
    required this.word,
    required this.exercise,
    required this.prompt,
    required this.showNounIndicator,
    required this.result,
    required this.selectedAnswer,
    required this.answerController,
    required this.answerBorderColor,
    required this.answerStateFor,
    required this.onChoiceSelected,
    required this.onInputChanged,
    required this.onInputSubmitted,
  });

  final CourseWord word;
  final TrainingExercise exercise;
  final String prompt;
  final bool showNounIndicator;
  final bool? result;
  final String? selectedAnswer;
  final TextEditingController answerController;
  final Color answerBorderColor;
  final TrainingAnswerState? Function(String option) answerStateFor;
  final ValueChanged<String> onChoiceSelected;
  final VoidCallback onInputChanged;
  final ValueChanged<String> onInputSubmitted;

  @override
  Widget build(BuildContext context) => TrainingContentLayout(
    header: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                prompt,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            CollectionActions(wordId: word.id),
          ],
        ),
        const SizedBox(height: 14),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: answerBorderColor,
              width: result == null ? 1 : 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showNounIndicator) ...[
                  NounIndicator(articles: word.article),
                  const SizedBox(width: 13),
                ],
                Flexible(
                  child: Text(
                    exercise.question,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    answers: exercise is ChoiceExercise
        ? TrainingAnswerChipGroup(
            options: (exercise as ChoiceExercise).options,
            selectedValue: selectedAnswer,
            enabled: result == null,
            answerStateFor: answerStateFor,
            onSelected: onChoiceSelected,
          )
        : TextField(
            controller: answerController,
            enabled: result == null,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onChanged: (_) => onInputChanged(),
            onSubmitted: onInputSubmitted,
          ),
  );
}
