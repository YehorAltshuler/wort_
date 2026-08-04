import 'dart:async';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/image_answer_grid.dart';
import 'package:wort_flutter/citizenship_test/widgets/question_image.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_answer_tile.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';
import 'package:wort_flutter/widgets/training_content_layout.dart';

class CitizenshipExamPage extends ConsumerStatefulWidget {
  const CitizenshipExamPage({this.startNew = false, super.key});

  final bool startNew;

  @override
  ConsumerState<CitizenshipExamPage> createState() =>
      _CitizenshipExamPageState();
}

class _CitizenshipExamPageState extends ConsumerState<CitizenshipExamPage> {
  List<CitizenshipQuestion>? _questions;
  ExamSessionRecord? _session;
  int _index = 0;
  int? _selected;
  bool _saving = false;
  bool _initializing = false;
  final List<GlobalKey> _answerKeys = List.generate(4, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(citizenshipQuestionsProvider);
    final progress = ref.watch(citizenshipProgressProvider);
    final total =
        _questions?.length ?? LebenInDeutschlandExamRules.totalQuestionCount;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.lidExamTitle),
        actions: [
          if (_questions != null) Center(child: Text('${_index + 1} / $total')),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _questions == null ? 0 : (_index + 1) / total,
          ),
        ),
      ),
      body: ResponsiveContent(
        child: questions.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (items) => progress.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('$error')),
            data: (records) => _buildExam(items, records),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildExam(
    List<CitizenshipQuestion> all,
    List<QuestionProgressRecord> progress,
  ) {
    if (_questions == null) {
      if (!_initializing) {
        _initializing = true;
        unawaited(_initializeExam(all));
      }
      return const Center(child: CircularProgressIndicator());
    }
    final questions = _questions!;
    final question = questions[_index];
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
              enabled: _selected == null && !_saving,
              answerKeys: _answerKeys,
              onSelected: (answer) => _selectAnswer(question, answer),
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
                      enabled: _selected == null && !_saving,
                      answerState: _answerState(question, answer),
                      onSelected: () => _selectAnswer(question, answer),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget? _buildBottomBar() {
    final questions = _questions;
    if (questions == null || _index >= questions.length) return null;
    final question = questions[_index];
    final selected = _selected;
    return TrainingBottomBar(
      result: selected == null ? null : selected == question.correctAnswer,
      correctAnswers: [question.answers[question.correctAnswer]],
      primaryEnabled: selected != null && !_saving,
      primaryLabel: _index == questions.length - 1
          ? context.l10n.lidSubmitExam
          : context.l10n.continueAction,
      onPrimary: _saveAndContinue,
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

  Future<void> _selectAnswer(
    CitizenshipQuestion question,
    int answer,
  ) async {
    final session = _session;
    if (session == null || _selected != null) return;
    setState(() {
      _selected = answer;
      _saving = true;
    });
    final repository = ref.read(citizenshipTestRepositoryProvider);
    await repository.saveExamAnswer(
      ExamAnswerRecord(
        sessionId: session.id,
        questionId: question.id,
        selectedAnswer: answer,
        isCorrect: answer == question.correctAnswer,
      ),
    );
    await repository.recordAnswer(
      question: question,
      selectedAnswer: answer,
    );
    ref.invalidate(citizenshipProgressProvider);
    if (mounted) setState(() => _saving = false);
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

  Future<void> _initializeExam(List<CitizenshipQuestion> all) async {
    final repository = ref.read(citizenshipTestRepositoryProvider);
    final state = ref.read(settingsProvider).value?.bundesland ?? 'BE';
    if (widget.startNew) {
      await repository.discardActiveSessions(CitizenshipSessionMode.exam);
    }
    final existing = widget.startNew
        ? null
        : await repository.loadActiveSession(CitizenshipSessionMode.exam);
    final byId = {for (final question in all) question.id: question};
    final questions = existing == null
        ? repository.createExamQuestions(all, state)
        : existing.questionIds
              .map((id) => byId[id])
              .whereType<CitizenshipQuestion>()
              .toList();
    final session = existing ?? await repository.startExam(questions, state);
    if (existing == null) ref.invalidate(citizenshipExamSessionsProvider);
    final answers = await repository.loadExamAnswers(session.id);
    final index = session.currentIndex.clamp(0, questions.length - 1);
    final savedAnswer = answers
        .where((answer) => answer.questionId == questions[index].id)
        .firstOrNull;
    if (!mounted) return;
    setState(() {
      _questions = questions;
      _session = session;
      _index = index;
      _selected = savedAnswer?.selectedAnswer;
      _initializing = false;
    });
  }

  Future<void> _saveAndContinue() async {
    final session = _session;
    if (session == null || _selected == null) return;
    setState(() => _saving = true);
    final repository = ref.read(citizenshipTestRepositoryProvider);
    if (_index == _questions!.length - 1) {
      await _finish();
      return;
    }
    await repository.saveSessionPosition(session, _index + 1);
    if (!mounted) return;
    setState(() {
      _index++;
      _selected = null;
      _saving = false;
    });
  }

  Future<void> _finish() async {
    final session = _session;
    if (session == null || !mounted) return;
    final completed = await ref
        .read(citizenshipTestRepositoryProvider)
        .completeExam(session);
    ref
      ..invalidate(citizenshipExamSessionsProvider)
      ..invalidate(citizenshipProgressProvider);
    if (mounted) context.go(AppRoute.citizenshipResult(completed.id));
  }
}
