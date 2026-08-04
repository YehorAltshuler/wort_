import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/question_image.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

FutureProvider<({ExamSessionRecord session, List<ExamAnswerRecord> answers})>
_examResultProvider(String sessionId) => FutureProvider((ref) async {
  final repository = ref.watch(citizenshipTestRepositoryProvider);
  final sessions = await repository.loadExamSessions();
  final session = sessions.firstWhere((item) => item.id == sessionId);
  return (
    session: session,
    answers: await repository.loadExamAnswers(sessionId),
  );
});

class CitizenshipResultPage extends ConsumerWidget {
  const CitizenshipResultPage({required this.sessionId, super.key});
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(_examResultProvider(sessionId));
    final questions = ref.watch(citizenshipQuestionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.lidExamResult)),
      body: ResponsiveContent(
        child: result.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (data) => questions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('$error')),
            data: (items) => _ResultContent(
              session: data.session,
              answers: data.answers,
              questions: items,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultContent extends StatelessWidget {
  const _ResultContent({
    required this.session,
    required this.answers,
    required this.questions,
  });
  final ExamSessionRecord session;
  final List<ExamAnswerRecord> answers;
  final List<CitizenshipQuestion> questions;

  @override
  Widget build(BuildContext context) {
    final byId = {for (final question in questions) question.id: question};
    final mistakes = answers.where((answer) => !answer.isCorrect).toList();
    final correct = session.correctCount ?? 0;
    return ListView(
      padding: AppSpacing.pageInsets,
      children: [
        Icon(
          session.passedCitizenship == true
              ? Icons.emoji_events_outlined
              : Icons.replay_outlined,
          size: 72,
        ),
        const SizedBox(height: 12),
        Text(
          '$correct / ${LebenInDeutschlandExamRules.totalQuestionCount}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          session.passedLifeInGermany == true
              ? context.l10n.lidTestPassed
              : context.l10n.lidTestFailed,
          textAlign: TextAlign.center,
        ),
        Text(
          session.passedCitizenship == true
              ? context.l10n.lidCitizenshipPassed
              : context.l10n.lidCitizenshipFailed,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => context.go(AppRoute.citizenshipTest),
          child: Text(context.l10n.lidBackToOverview),
        ),
        if (mistakes.isNotEmpty) ...[
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.push(
              AppRoute.citizenshipExamMistakes(session.id),
            ),
            icon: const Icon(Icons.replay),
            label: Text(context.l10n.retryMistakes),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.lidViewMistakes,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          for (final answer in mistakes)
            if (byId[answer.questionId] case final question?)
              _MistakeCard(question: question, answer: answer),
        ],
      ],
    );
  }
}

class _MistakeCard extends StatelessWidget {
  const _MistakeCard({required this.question, required this.answer});
  final CitizenshipQuestion question;
  final ExamAnswerRecord answer;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(top: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CitizenshipQuestionImage(
            questionId: question.id,
            hasImage: question.hasImage,
          ),
          Text(question.text, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            context.l10n.lidYourAnswer(question.answers[answer.selectedAnswer]),
          ),
          Text(
            context.l10n.lidCorrectAnswerValue(
              question.answers[question.correctAnswer],
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    ),
  );
}
