import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_exam_session_provider.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/citizenship_answer_bottom_bar.dart';
import 'package:wort_flutter/citizenship_test/widgets/citizenship_question_exercise.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/widgets/async_value_view.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';

class CitizenshipExamPage extends ConsumerStatefulWidget {
  const CitizenshipExamPage({this.startNew = false, super.key});

  final bool startNew;

  @override
  ConsumerState<CitizenshipExamPage> createState() =>
      _CitizenshipExamPageState();
}

class _CitizenshipExamPageState extends ConsumerState<CitizenshipExamPage> {
  final List<GlobalKey> _answerKeys = List.generate(4, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final request = (
      startNew: widget.startNew,
      stateCode: ref.watch(settingsProvider).value?.bundesland ?? 'BE',
    );
    final sessionValue = ref.watch(citizenshipExamSessionProvider(request));
    final progress = ref.watch(citizenshipProgressProvider);
    final exam = sessionValue.value?.exam;
    final total = exam?.total ?? LebenInDeutschlandExamRules.totalQuestionCount;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.lidExamTitle),
        actions: [
          if (exam != null && !exam.isEmpty)
            Center(child: Text('${exam.index + 1} / $total')),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: exam == null || exam.isEmpty ? 0 : (exam.index + 1) / total,
          ),
        ),
      ),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: sessionValue,
          errorMessage: context.l10n.lidLoadError,
          retryLabel: context.l10n.retryAction,
          onRetry: () => ref.invalidate(
            citizenshipExamSessionProvider(request),
          ),
          data: (session) {
            final currentExam = session.exam;
            final question = currentExam.currentQuestion;
            if (question == null) {
              return Center(child: Text(context.l10n.lidNoQuestions));
            }
            return AsyncValueView(
              value: progress,
              errorMessage: context.l10n.lidLoadError,
              retryLabel: context.l10n.retryAction,
              onRetry: () => ref.invalidate(citizenshipProgressProvider),
              data: (records) {
                final currentProgress = records
                    .where((item) => item.questionId == question.id)
                    .firstOrNull;
                return CitizenshipQuestionExercise(
                  question: question,
                  selectedAnswer: currentExam.selectedAnswer,
                  enabled: currentExam.canSelectAnswer,
                  answerKeys: _answerKeys,
                  answerStateFor: (answer) => _answerState(
                    question,
                    answer,
                    currentExam.selectedAnswer,
                  ),
                  onSelected: (answer) => ref
                      .read(citizenshipExamSessionProvider(request).notifier)
                      .selectAnswer(answer),
                  onToggleFavorite: () => ref
                      .read(citizenshipExamSessionProvider(request).notifier)
                      .toggleFavorite(question.id),
                  isFavorite: currentProgress?.isFavorite == true,
                  scrollTogether: true,
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: exam == null || exam.isEmpty
          ? null
          : _CitizenshipExamBottomBar(
              question: exam.currentQuestion!,
              selectedAnswer: exam.selectedAnswer,
              saving: exam.saving,
              isLastQuestion: exam.isLastQuestion,
              onPrimary: () async {
                final completedId = await ref
                    .read(citizenshipExamSessionProvider(request).notifier)
                    .continueExam();
                if (completedId != null && context.mounted) {
                  context.go(AppRoute.citizenshipResult(completedId));
                }
              },
            ),
    );
  }

  TrainingAnswerState? _answerState(
    CitizenshipQuestion question,
    int answer,
    int? selectedAnswer,
  ) {
    if (selectedAnswer == null) return null;
    if (answer == question.correctAnswer) return TrainingAnswerState.correct;
    if (answer == selectedAnswer) return TrainingAnswerState.incorrect;
    return null;
  }
}

class _CitizenshipExamBottomBar extends StatelessWidget {
  const _CitizenshipExamBottomBar({
    required this.question,
    required this.selectedAnswer,
    required this.saving,
    required this.isLastQuestion,
    required this.onPrimary,
  });

  final CitizenshipQuestion question;
  final int? selectedAnswer;
  final bool saving;
  final bool isLastQuestion;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) => CitizenshipAnswerBottomBar(
    question: question,
    selectedAnswer: selectedAnswer,
    primaryEnabled: selectedAnswer != null && !saving,
    primaryLabel: isLastQuestion
        ? context.l10n.lidSubmitExam
        : context.l10n.continueAction,
    onPrimary: onPrimary,
  );
}
