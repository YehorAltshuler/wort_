import 'dart:math';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/citizenship_test/controller/citizenship_training_controller.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';

typedef CitizenshipTrainingRequest = ({
  String filter,
  bool randomOrder,
  String? sessionId,
  bool startNew,
  String stateCode,
});

class CitizenshipTrainingSessionState {
  const CitizenshipTrainingSessionState({
    required this.training,
    this.session,
  });

  final CitizenshipTrainingController training;
  final ExamSessionRecord? session;
}

// The concrete family type is intentionally inferred by Riverpod's builder.
// ignore: specify_nonobvious_property_types
final citizenshipTrainingSessionProvider = AsyncNotifierProvider.autoDispose
    .family<
      CitizenshipTrainingSessionNotifier,
      CitizenshipTrainingSessionState,
      CitizenshipTrainingRequest
    >(CitizenshipTrainingSessionNotifier.new);

class CitizenshipTrainingSessionNotifier
    extends AsyncNotifier<CitizenshipTrainingSessionState> {
  CitizenshipTrainingSessionNotifier(this.request);

  final CitizenshipTrainingRequest request;
  CitizenshipTrainingController? _training;
  ExamSessionRecord? _session;

  @override
  Future<CitizenshipTrainingSessionState> build() async {
    ref.onDispose(() => _training?.dispose());
    final questions = await ref.read(citizenshipQuestionsProvider.future);
    final progress = await ref.read(citizenshipProgressProvider.future);
    return switch (request.filter) {
      'all' => _restoreAllQuestionsSession(questions, progress),
      'examMistakes' => _loadExamMistakes(questions),
      _ => _createSession(_createQueue(questions, progress)),
    };
  }

  Future<void> answer(int answer) async {
    final training = _training;
    final question = training?.currentQuestion;
    if (training == null || question == null) return;
    training.answer(answer);
    _publish();
    final repository = ref.read(citizenshipTestRepositoryProvider);
    await repository.recordAnswer(question: question, selectedAnswer: answer);
    final session = _session;
    if (session != null) {
      await repository.saveExamAnswer(
        ExamAnswerRecord(
          sessionId: session.id,
          questionId: question.id,
          selectedAnswer: answer,
          isCorrect: answer == question.correctAnswer,
        ),
      );
    }
    ref.invalidate(citizenshipProgressProvider);
  }

  Future<void> next() async {
    final training = _training;
    if (training == null) return;
    training.next();
    _publish();
    final session = _session;
    if (session == null) return;
    final repository = ref.read(citizenshipTestRepositoryProvider);
    if (training.isComplete) {
      await repository.completeAllQuestions(session);
    } else {
      await repository.saveSessionPosition(session, training.index);
    }
  }

  Future<void> jumpTo(int index) async {
    final training = _training;
    if (training == null) return;
    training.jumpTo(index);
    _publish();
    final session = _session;
    if (session != null) {
      await ref
          .read(citizenshipTestRepositoryProvider)
          .saveSessionPosition(session, training.index);
    }
  }

  void retryMistakes() {
    _training?.retryMistakes();
    _publish();
  }

  Future<void> toggleFavorite(String questionId) async {
    await ref
        .read(citizenshipTestRepositoryProvider)
        .toggleFavorite(questionId);
    ref.invalidate(citizenshipProgressProvider);
  }

  List<CitizenshipQuestion> _createQueue(
    List<CitizenshipQuestion> questions,
    List<QuestionProgressRecord> progress,
  ) {
    final progressById = {for (final item in progress) item.questionId: item};
    final filtered = questions.where((question) {
      if (!question.isAvailable) return false;
      return switch (request.filter) {
        'general' => question.scope == QuestionScope.general,
        'state' => question.stateCode == request.stateCode,
        'favorites' => progressById[question.id]?.isFavorite == true,
        'mistakes' => (progressById[question.id]?.incorrect ?? 0) > 0,
        _ =>
          question.scope == QuestionScope.general ||
              question.stateCode == request.stateCode,
      };
    }).toList();
    if (request.randomOrder) filtered.shuffle(Random());
    return filtered;
  }

  Future<CitizenshipTrainingSessionState> _restoreAllQuestionsSession(
    List<CitizenshipQuestion> questions,
    List<QuestionProgressRecord> progress,
  ) async {
    final repository = ref.read(citizenshipTestRepositoryProvider);
    if (request.startNew) {
      await repository.discardActiveSessions(
        CitizenshipSessionMode.allQuestions,
      );
    }
    final existing = request.startNew
        ? null
        : await repository.loadActiveSession(
            CitizenshipSessionMode.allQuestions,
          );
    final byId = {for (final question in questions) question.id: question};
    final queue = existing == null
        ? _createQueue(questions, progress)
        : existing.questionIds
              .map((id) => byId[id])
              .whereType<CitizenshipQuestion>()
              .toList();
    final session =
        existing ??
        await repository.startAllQuestions(queue, request.stateCode);
    final savedAnswers = await repository.loadExamAnswers(session.id);
    if (existing == null) ref.invalidate(citizenshipExamSessionsProvider);
    _session = session;
    return _createSession(
      queue,
      initialIndex: session.currentIndex,
      answeredQuestions: {
        for (final answer in savedAnswers) answer.questionId: answer.isCorrect,
      },
      session: session,
    );
  }

  Future<CitizenshipTrainingSessionState> _loadExamMistakes(
    List<CitizenshipQuestion> questions,
  ) async {
    final sessionId = request.sessionId;
    if (sessionId == null) return _createSession(const []);
    final answers = await ref
        .read(citizenshipTestRepositoryProvider)
        .loadExamAnswers(sessionId);
    final mistakeIds = answers
        .where((answer) => !answer.isCorrect)
        .map((answer) => answer.questionId)
        .toSet();
    return _createSession(
      questions.where((question) => mistakeIds.contains(question.id)).toList(),
    );
  }

  CitizenshipTrainingSessionState _createSession(
    List<CitizenshipQuestion> questions, {
    int initialIndex = 0,
    Map<String, bool> answeredQuestions = const {},
    ExamSessionRecord? session,
  }) {
    _training?.dispose();
    _training = CitizenshipTrainingController(
      questions: questions,
      initialIndex: initialIndex,
      answeredQuestions: answeredQuestions,
    );
    _session = session;
    return CitizenshipTrainingSessionState(
      training: _training!,
      session: session,
    );
  }

  void _publish() {
    final training = _training;
    if (training == null) return;
    state = AsyncData(
      CitizenshipTrainingSessionState(
        training: training,
        session: _session,
      ),
    );
  }
}
