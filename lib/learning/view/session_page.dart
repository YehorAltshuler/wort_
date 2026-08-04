import 'dart:async';
import 'dart:math';

import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/collections/widgets/collection_actions.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/learning/domain/training_exercise.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/learning/provider/learning_progress_provider.dart';
import 'package:wort_flutter/settings/widgets/noun_indicator.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_answer_chip_group.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';
import 'package:wort_flutter/widgets/training_content_layout.dart';
import 'package:wort_flutter/widgets/training_progress_indicator.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({
    required this.bookId,
    required this.moduleFile,
    required this.type,
    required this.difficulty,
    super.key,
  });

  final String bookId;
  final String moduleFile;
  final String type;
  final String difficulty;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  List<CourseWord>? _queue;
  final List<CourseWord> _mistakes = [];
  final TextEditingController _answerController = TextEditingController();
  int _index = 0;
  int _correct = 0;
  int _wrong = 0;
  bool? _result;
  String? _selectedAnswer;
  TrainingExercise? _currentExercise;
  String? _currentExerciseKey;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeQueue());
  }

  Future<void> _initializeQueue() async {
    final words = await ref.read(
      moduleWordsProvider(
        (bookId: widget.bookId, moduleFile: widget.moduleFile),
      ).future,
    );
    if (mounted) setState(() => _queue = _createQueue(words));
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(
      moduleWordsProvider(
        (bookId: widget.bookId, moduleFile: widget.moduleFile),
      ),
    );
    final session = words.maybeWhen(
      data: (items) {
        final total = _queue?.length ?? 0;
        return (
          total: total,
          correctProgress: total == 0 ? 0.0 : _correct / total,
          incorrectProgress: total == 0 ? 0.0 : _wrong / total,
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
                  '${min(_index + 1, session.total)} / ${session.total}',
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
            final queue = _queue;
            if (queue == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (queue.isEmpty) {
              return Center(child: Text(context.l10n.noWords));
            }
            if (_index >= queue.length) {
              return _CompletionView(
                correct: _correct,
                wrong: _wrong,
                hasMistakes: _mistakes.isNotEmpty,
                onRetry: _retryMistakes,
                onClose: () => context.pop(),
              );
            }
            final word = queue[_index];
            final exercise = _exerciseFor(
              word,
              allWords,
              Localizations.localeOf(context).languageCode,
            );
            final articleExercise =
                word.type == CourseWordType.noun &&
                _difficulty != TrainingDifficulty.easy;
            return _SessionTrainingContent(
              word: word,
              exercise: exercise,
              prompt: _prompt(context),
              showNounIndicator:
                  word.article.isNotEmpty &&
                  (!articleExercise || _result != null),
              result: _result,
              selectedAnswer: _selectedAnswer,
              answerController: _answerController,
              answerBorderColor: _answerBorderColor(context),
              answerStateFor: (option) => _answerState(exercise, option),
              onChoiceSelected: (option) =>
                  _checkAnswer(word, exercise, option),
              onInputChanged: () => setState(() {}),
              onInputSubmitted: (answer) =>
                  _checkAnswer(word, exercise, answer),
            );
          },
        ),
      ),
      bottomNavigationBar: words.maybeWhen(
        data: _buildBottomBar,
        orElse: () => null,
      ),
    );
  }

  Widget? _buildBottomBar(List<CourseWord> allWords) {
    final queue = _queue;
    if (queue == null) return null;
    if (queue.isEmpty || _index >= queue.length) return null;
    final word = queue[_index];
    final exercise = _exerciseFor(
      word,
      allWords,
      Localizations.localeOf(context).languageCode,
    );
    final inputReady =
        exercise is InputExercise && _answerController.text.trim().isNotEmpty;
    return TrainingBottomBar(
      result: _result,
      correctAnswers: exercise.correctAnswers,
      primaryEnabled: _result != null || inputReady,
      primaryLabel: _result == null
          ? exercise is InputExercise
                ? context.l10n.checkAnswer
                : context.l10n.continueAction
          : context.l10n.continueAction,
      secondaryLabel: context.l10n.wordDetailsAction,
      secondaryEnabled: _result != null && word.dictionaryId != null,
      onSecondary: word.dictionaryId == null
          ? null
          : () => context.push(AppRoute.wordDetails(word.dictionaryId!)),
      onPrimary: _result != null
          ? _next
          : () => _checkAnswer(word, exercise, _answerController.text),
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
    if (_result == null) return colors.outlineVariant;
    if (_result == false) return colors.error;
    return TrainingAnswerChip.correctColor(context);
  }

  TrainingAnswerState? _answerState(
    TrainingExercise exercise,
    String option,
  ) {
    if (exercise is! ChoiceExercise) return null;
    if (_result == null) return null;
    if (exercise.check(option)) return TrainingAnswerState.correct;
    if (_selectedAnswer == option) return TrainingAnswerState.incorrect;
    return null;
  }

  TrainingExercise _exerciseFor(
    CourseWord word,
    List<CourseWord> words,
    String languageCode,
  ) {
    final key = '${word.id}:${_difficulty.name}:$languageCode';
    if (_currentExerciseKey != key) {
      _currentExerciseKey = key;
      _currentExercise = createExercise(
        word: word,
        words: words,
        difficulty: _difficulty,
        languageCode: languageCode,
      );
    }
    return _currentExercise!;
  }

  List<CourseWord> _createQueue(List<CourseWord> words) {
    return [...CourseWordFilterX.fromName(widget.type).apply(words)]
      ..shuffle(Random());
  }

  void _checkAnswer(
    CourseWord word,
    TrainingExercise exercise,
    String answer,
  ) {
    if (_result != null || answer.trim().isEmpty) return;
    final correct = exercise.check(answer);
    setState(() {
      _selectedAnswer = answer;
      _result = correct;
      if (correct) {
        _correct++;
      } else {
        _wrong++;
        _mistakes.add(word);
      }
    });
    unawaited(
      ref
          .read(learningProgressProvider.notifier)
          .recordResult(word.id, correct: correct),
    );
  }

  void _next() {
    setState(() {
      _index++;
      _result = null;
      _selectedAnswer = null;
      _currentExercise = null;
      _currentExerciseKey = null;
      _answerController.clear();
    });
  }

  void _retryMistakes() {
    setState(() {
      _queue = [..._mistakes]..shuffle();
      _mistakes.clear();
      _index = 0;
      _correct = 0;
      _wrong = 0;
      _result = null;
      _selectedAnswer = null;
      _currentExercise = null;
      _currentExerciseKey = null;
      _answerController.clear();
    });
  }
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

class _CompletionView extends StatelessWidget {
  const _CompletionView({
    required this.correct,
    required this.wrong,
    required this.hasMistakes,
    required this.onRetry,
    required this.onClose,
  });

  final int correct;
  final int wrong;
  final bool hasMistakes;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events_outlined, size: 72),
            const SizedBox(height: 16),
            Text(
              context.l10n.knowledgeCheckComplete,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text('${context.l10n.correctAnswer}: $correct'),
            Text('${context.l10n.wrongAnswer}: $wrong'),
            const SizedBox(height: 24),
            if (hasMistakes)
              OutlinedButton(
                onPressed: onRetry,
                child: Text(context.l10n.retryMistakes),
              ),
            FilledButton(
              onPressed: onClose,
              child: Text(context.l10n.backToModule),
            ),
          ],
        ),
      ),
    );
  }
}
