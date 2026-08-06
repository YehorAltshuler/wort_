import 'dart:async';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/citizenship_test/controller/citizenship_exam_controller.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';

typedef CitizenshipExamRequest = ({bool startNew, String stateCode});

class CitizenshipExamSessionState {
  const CitizenshipExamSessionState({
    required this.session,
    required this.exam,
  });

  final ExamSessionRecord session;
  final CitizenshipExamController exam;
}

// The concrete family type is intentionally inferred by Riverpod's builder.
// ignore: specify_nonobvious_property_types
final citizenshipExamSessionProvider = AsyncNotifierProvider.autoDispose
    .family<
      CitizenshipExamSessionNotifier,
      CitizenshipExamSessionState,
      CitizenshipExamRequest
    >(CitizenshipExamSessionNotifier.new);

class CitizenshipExamSessionNotifier
    extends AsyncNotifier<CitizenshipExamSessionState> {
  CitizenshipExamSessionNotifier(this.request);

  final CitizenshipExamRequest request;
  CitizenshipExamController? _exam;
  ExamSessionRecord? _session;

  @override
  Future<CitizenshipExamSessionState> build() async {
    ref.onDispose(() => _exam?.dispose());
    final questions = await ref.read(citizenshipQuestionsProvider.future);
    final repository = ref.read(citizenshipTestRepositoryProvider);
    if (request.startNew) {
      await repository.discardActiveSessions(CitizenshipSessionMode.exam);
    }
    final existing = request.startNew
        ? null
        : await repository.loadActiveSession(CitizenshipSessionMode.exam);
    final byId = {for (final question in questions) question.id: question};
    final examQuestions = existing == null
        ? repository.createExamQuestions(questions, request.stateCode)
        : existing.questionIds
              .map((id) => byId[id])
              .whereType<CitizenshipQuestion>()
              .toList();
    final session =
        existing ??
        await repository.startExam(examQuestions, request.stateCode);
    if (existing == null) ref.invalidate(citizenshipExamSessionsProvider);
    final answers = await repository.loadExamAnswers(session.id);
    final index = examQuestions.isEmpty
        ? 0
        : session.currentIndex.clamp(0, examQuestions.length - 1);
    final savedAnswer = examQuestions.isEmpty
        ? null
        : answers
              .where(
                (answer) => answer.questionId == examQuestions[index].id,
              )
              .firstOrNull;
    _session = session;
    _exam?.dispose();
    _exam = CitizenshipExamController(
      questions: examQuestions,
      initialIndex: index,
      selectedAnswer: savedAnswer?.selectedAnswer,
    );
    return CitizenshipExamSessionState(session: session, exam: _exam!);
  }

  Future<void> selectAnswer(int answer) async {
    final exam = _exam;
    final session = _session;
    final question = exam?.currentQuestion;
    if (exam == null || session == null || question == null) return;
    if (!exam.selectAnswer(answer)) return;
    exam.setSaving(value: true);
    _publish();
    try {
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
    } finally {
      exam.setSaving(value: false);
      _publish();
    }
  }

  Future<String?> continueExam() async {
    final exam = _exam;
    final session = _session;
    if (exam == null || session == null || !exam.canContinue) return null;
    exam.setSaving(value: true);
    _publish();
    try {
      final repository = ref.read(citizenshipTestRepositoryProvider);
      if (exam.isLastQuestion) {
        final completed = await repository.completeExam(session);
        ref
          ..invalidate(citizenshipExamSessionsProvider)
          ..invalidate(citizenshipProgressProvider);
        return completed.id;
      }
      await repository.saveSessionPosition(session, exam.index + 1);
      exam
        ..setSaving(value: false)
        ..advance();
      _publish();
      return null;
    } finally {
      if (exam.saving) {
        exam.setSaving(value: false);
        _publish();
      }
    }
  }

  Future<void> toggleFavorite(String questionId) async {
    await ref
        .read(citizenshipTestRepositoryProvider)
        .toggleFavorite(questionId);
    ref.invalidate(citizenshipProgressProvider);
  }

  void _publish() {
    final exam = _exam;
    final session = _session;
    if (exam == null || session == null) return;
    state = AsyncData(
      CitizenshipExamSessionState(session: session, exam: exam),
    );
  }
}
