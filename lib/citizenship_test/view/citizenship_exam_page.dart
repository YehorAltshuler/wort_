import 'dart:async';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/citizenship_question_exercise.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_bottom_bar.dart';

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
  Object? _initializationError;
  final List<GlobalKey> _answerKeys = List.generate(4, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    unawaited(_loadExam());
  }

  Future<void> _loadExam() async {
    try {
      final questions = await ref.read(citizenshipQuestionsProvider.future);
      await _initializeExam(questions);
    } on Object catch (error) {
      if (mounted) setState(() => _initializationError = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(citizenshipProgressProvider);
    final initializationError = _initializationError;
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
        child: initializationError != null
            ? Center(child: Text('$initializationError'))
            : progress.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Center(child: Text('$error')),
                data: (records) {
                  final questions = _questions;
                  if (questions == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final question = questions[_index];
                  final currentProgress = records
                      .where((item) => item.questionId == question.id)
                      .firstOrNull;
                  return CitizenshipQuestionExercise(
                    question: question,
                    selectedAnswer: _selected,
                    enabled: _selected == null && !_saving,
                    answerKeys: _answerKeys,
                    answerStateFor: (answer) => _answerState(question, answer),
                    onSelected: (answer) => _selectAnswer(question, answer),
                    onToggleFavorite: () => _toggleFavorite(question.id),
                    isFavorite: currentProgress?.isFavorite == true,
                    imageBeforeQuestion: false,
                  );
                },
              ),
      ),
      bottomNavigationBar: _buildBottomBar(),
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

  Future<void> _toggleFavorite(String questionId) async {
    await ref
        .read(citizenshipTestRepositoryProvider)
        .toggleFavorite(questionId);
    ref.invalidate(citizenshipProgressProvider);
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
