import 'dart:async';
import 'dart:math';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/image_answer_grid.dart';
import 'package:wort_flutter/citizenship_test/widgets/question_image.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_answer_tile.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';
import 'package:wort_flutter/widgets/training_content_layout.dart';
import 'package:wort_flutter/widgets/training_progress_indicator.dart';

class CitizenshipTrainingPage extends ConsumerStatefulWidget {
  const CitizenshipTrainingPage({
    required this.filter,
    required this.randomOrder,
    this.sessionId,
    super.key,
  });

  final String filter;
  final bool randomOrder;
  final String? sessionId;

  @override
  ConsumerState<CitizenshipTrainingPage> createState() =>
      _CitizenshipTrainingPageState();
}

class _CitizenshipTrainingPageState
    extends ConsumerState<CitizenshipTrainingPage> {
  List<CitizenshipQuestion>? _queue;
  ExamSessionRecord? _session;
  bool _loadingSession = false;
  final List<CitizenshipQuestion> _mistakes = [];
  final List<GlobalKey> _answerKeys = List.generate(4, (_) => GlobalKey());
  int _index = 0;
  int? _selected;
  int _correct = 0;
  int _wrong = 0;

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(citizenshipQuestionsProvider);
    final progress = ref.watch(citizenshipProgressProvider);
    if (_queue == null &&
        widget.filter != 'all' &&
        widget.filter != 'examMistakes') {
      switch ((questions, progress)) {
        case (AsyncData(value: final items), AsyncData(value: final records)):
          _queue = _createQueue(items, records);
        default:
          break;
      }
    }
    final total = _queue?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.lidTrainingTitle),
        actions: [
          if (widget.filter == 'all' && total > 0)
            IconButton(
              tooltip: context.l10n.lidQuestionList,
              icon: const Icon(Icons.format_list_numbered),
              onPressed: _showQuestionList,
            ),
          if (total > 0)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Center(child: Text('${_index + 1} / $total')),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: TrainingProgressIndicator(
            correctProgress: total == 0 ? 0 : _correct / total,
            incorrectProgress: total == 0 ? 0 : _wrong / total,
          ),
        ),
      ),
      body: questions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (items) => progress.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (records) => _buildSession(items, records),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSession(
    List<CitizenshipQuestion> all,
    List<QuestionProgressRecord> progress,
  ) {
    if (_queue == null &&
        (widget.filter == 'all' || widget.filter == 'examMistakes')) {
      if (!_loadingSession) {
        _loadingSession = true;
        unawaited(
          widget.filter == 'all'
              ? _restoreAllQuestionsSession(all, progress)
              : _restoreExamMistakes(all),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }
    _queue ??= _createQueue(all, progress);
    final queue = _queue!;
    if (queue.isEmpty) {
      return Center(child: Text(context.l10n.lidNoQuestions));
    }
    if (_index >= queue.length) {
      return _TrainingComplete(
        total: queue.length,
        mistakes: _mistakes.length,
        onRetry: _mistakes.isEmpty ? null : _retryMistakes,
      );
    }
    final question = queue[_index];
    final usesImageAnswers = _usesImageAnswers(question);
    final currentProgress = progress
        .where((item) => item.questionId == question.id)
        .firstOrNull;
    return TrainingContentLayout(
      answersBottomPadding: 8,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(context.l10n.lidQuestionNumber(question.num)),
              const Spacer(),
              IconButton(
                tooltip: context.l10n.lidFavoriteTooltip,
                icon: Icon(
                  currentProgress?.isFavorite == true
                      ? Icons.star
                      : Icons.star_outline,
                ),
                onPressed: () async {
                  await ref
                      .read(citizenshipTestRepositoryProvider)
                      .toggleFavorite(question.id);
                  ref.invalidate(citizenshipProgressProvider);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                question.text,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      ),
      answers: usesImageAnswers
          ? CitizenshipImageAnswerGrid(
              questionId: question.id,
              answers: question.answers,
              correctAnswer: question.correctAnswer,
              selectedAnswer: _selected,
              enabled: _selected == null,
              answerKeys: _answerKeys,
              onSelected: (answer) => _answer(question, answer),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CitizenshipQuestionImage(
                  questionId: question.id,
                  hasImage: question.hasImage,
                ),
                for (var answer = 0; answer < question.answers.length; answer++)
                  Padding(
                    key: _answerKeys[answer],
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TrainingAnswerTile(
                      label: question.answers[answer],
                      position: answer,
                      selected: _selected == answer,
                      enabled: _selected == null,
                      answerState: _answerState(question, answer),
                      onSelected: () => _answer(question, answer),
                    ),
                  ),
              ],
            ),
    );
  }

  bool _usesImageAnswers(CitizenshipQuestion question) {
    if (question.images.length != 4 || question.answers.length != 4) {
      return false;
    }
    for (var index = 0; index < question.answers.length; index++) {
      if (question.answers[index].trim().toLowerCase() != 'bild ${index + 1}') {
        return false;
      }
    }
    return true;
  }

  Widget? _buildBottomBar() {
    final queue = _queue;
    if (queue == null || queue.isEmpty || _index >= queue.length) return null;
    final question = queue[_index];
    final selected = _selected;
    return TrainingBottomBar(
      result: selected == null ? null : selected == question.correctAnswer,
      correctAnswers: [question.answers[question.correctAnswer]],
      primaryEnabled: selected != null,
      primaryLabel: _index == queue.length - 1
          ? 'Abschließen'
          : 'Nächste Frage',
      onPrimary: _next,
    );
  }

  TrainingAnswerState? _answerState(
    CitizenshipQuestion question,
    int answer,
  ) {
    if (_selected == null) return null;
    if (answer == question.correctAnswer) return TrainingAnswerState.correct;
    if (answer == _selected) return TrainingAnswerState.incorrect;
    return null;
  }

  List<CitizenshipQuestion> _createQueue(
    List<CitizenshipQuestion> questions,
    List<QuestionProgressRecord> progress,
  ) {
    final state = ref.read(settingsProvider).value?.bundesland ?? 'BE';
    final progressById = {for (final item in progress) item.questionId: item};
    final filtered = questions.where((question) {
      if (!question.isAvailable) return false;
      return switch (widget.filter) {
        'general' => question.scope == QuestionScope.general,
        'state' => question.stateCode == state,
        'favorites' => progressById[question.id]?.isFavorite == true,
        'mistakes' => (progressById[question.id]?.incorrect ?? 0) > 0,
        _ =>
          question.scope == QuestionScope.general ||
              question.stateCode == state,
      };
    }).toList();
    if (widget.randomOrder) filtered.shuffle(Random());
    return filtered;
  }

  void _answer(CitizenshipQuestion question, int answer) {
    setState(() {
      _selected = answer;
      if (answer == question.correctAnswer) {
        _correct++;
      } else {
        _wrong++;
        _mistakes.add(question);
      }
    });
    unawaited(
      ref
          .read(citizenshipTestRepositoryProvider)
          .recordAnswer(question: question, selectedAnswer: answer),
    );
    unawaited(_keepAnswerVisible(answer));
  }

  Future<void> _keepAnswerVisible(int answer) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final answerContext = _answerKeys[answer].currentContext;
    if (!mounted || answerContext == null || !answerContext.mounted) return;
    await Scrollable.ensureVisible(
      answerContext,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );
  }

  void _next() {
    final nextIndex = _index + 1;
    setState(() {
      _index = nextIndex;
      _selected = null;
    });
    final session = _session;
    if (session != null) {
      if (nextIndex >= session.questionIds.length) {
        unawaited(
          ref
              .read(citizenshipTestRepositoryProvider)
              .completeAllQuestions(session),
        );
      } else {
        unawaited(
          ref
              .read(citizenshipTestRepositoryProvider)
              .saveSessionPosition(session, nextIndex),
        );
      }
    }
  }

  Future<void> _restoreAllQuestionsSession(
    List<CitizenshipQuestion> all,
    List<QuestionProgressRecord> progress,
  ) async {
    final repository = ref.read(citizenshipTestRepositoryProvider);
    final existing = await repository.loadActiveSession(
      CitizenshipSessionMode.allQuestions,
    );
    final byId = {for (final question in all) question.id: question};
    final state = ref.read(settingsProvider).value?.bundesland ?? 'BE';
    final queue = existing == null
        ? _createQueue(all, progress)
        : existing.questionIds
              .map((id) => byId[id])
              .whereType<CitizenshipQuestion>()
              .toList();
    final session =
        existing ?? await repository.startAllQuestions(queue, state);
    if (existing == null) ref.invalidate(citizenshipExamSessionsProvider);
    if (!mounted) return;
    setState(() {
      _session = session;
      _queue = queue;
      _index = session.currentIndex.clamp(0, queue.length);
      _loadingSession = false;
    });
  }

  Future<void> _restoreExamMistakes(List<CitizenshipQuestion> all) async {
    final sessionId = widget.sessionId;
    if (sessionId == null) {
      if (mounted) setState(() => _queue = []);
      return;
    }
    final answers = await ref
        .read(citizenshipTestRepositoryProvider)
        .loadExamAnswers(sessionId);
    final mistakeIds = answers
        .where((answer) => !answer.isCorrect)
        .map((answer) => answer.questionId)
        .toSet();
    final queue = all
        .where((question) => mistakeIds.contains(question.id))
        .toList();
    if (!mounted) return;
    setState(() {
      _queue = queue;
      _loadingSession = false;
    });
  }

  Future<void> _showQuestionList() async {
    final queue = _queue;
    if (queue == null || queue.isEmpty) return;
    final progress = ref.read(citizenshipProgressProvider).value ?? const [];
    final progressById = {
      for (final item in progress) item.questionId: item,
    };
    final selected = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.75,
          child: ListView.builder(
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final status = progressById[queue[index].id];
              final answered = status?.lastSelectedAnswer != null;
              final color = !answered
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : status!.isMastered
                  ? TrainingAnswerChip.correctColor(context)
                  : Theme.of(context).colorScheme.error;
              return ListTile(
                selected: index == _index,
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.16),
                  foregroundColor: color,
                  child: Text('${index + 1}'),
                ),
                title: Text(queue[index].text, maxLines: 2),
                trailing: answered
                    ? Icon(
                        status!.isMastered ? Icons.check_circle : Icons.cancel,
                        color: color,
                      )
                    : const Icon(Icons.radio_button_unchecked),
                onTap: () => Navigator.pop(context, index),
              );
            },
          ),
        ),
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _index = selected;
      _selected = null;
    });
    final session = _session;
    if (session != null) {
      await ref
          .read(citizenshipTestRepositoryProvider)
          .saveSessionPosition(session, selected);
    }
  }

  void _retryMistakes() => setState(() {
    _queue = [..._mistakes]..shuffle();
    _mistakes.clear();
    _index = 0;
    _selected = null;
    _correct = 0;
    _wrong = 0;
  });
}

class _TrainingComplete extends StatelessWidget {
  const _TrainingComplete({
    required this.total,
    required this.mistakes,
    required this.onRetry,
  });
  final int total;
  final int mistakes;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 72),
          const SizedBox(height: 16),
          Text(
            context.l10n.lidTrainingComplete,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(context.l10n.lidTrainingSummary(total, mistakes)),
          if (onRetry != null)
            OutlinedButton(
              onPressed: onRetry,
              child: Text(context.l10n.retryMistakes),
            ),
        ],
      ),
    ),
  );
}
