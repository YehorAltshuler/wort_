import 'dart:async';

import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/citizenship_test/controller/citizenship_training_controller.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_training_session_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/citizenship_answer_bottom_bar.dart';
import 'package:wort_flutter/citizenship_test/widgets/citizenship_question_exercise.dart';
import 'package:wort_flutter/citizenship_test/widgets/citizenship_question_list_sheet.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/widgets/async_value_view.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/selection_bottom_sheet.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';
import 'package:wort_flutter/widgets/training_completion_view.dart';
import 'package:wort_flutter/widgets/training_progress_indicator.dart';

class CitizenshipTrainingPage extends ConsumerStatefulWidget {
  const CitizenshipTrainingPage({
    required this.filter,
    required this.randomOrder,
    this.sessionId,
    this.startNew = false,
    super.key,
  });

  final String filter;
  final bool randomOrder;
  final String? sessionId;
  final bool startNew;

  @override
  ConsumerState<CitizenshipTrainingPage> createState() =>
      _CitizenshipTrainingPageState();
}

class _CitizenshipTrainingPageState
    extends ConsumerState<CitizenshipTrainingPage> {
  final List<GlobalKey> _answerKeys = List.generate(4, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final request = (
      filter: widget.filter,
      randomOrder: widget.randomOrder,
      sessionId: widget.sessionId,
      startNew: widget.startNew,
      stateCode: ref.watch(settingsProvider).value?.bundesland ?? 'BE',
    );
    final sessionValue = ref.watch(
      citizenshipTrainingSessionProvider(request),
    );
    final progress = ref.watch(citizenshipProgressProvider);
    final training = sessionValue.value?.training;
    final total = training?.total ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.lidTrainingTitle),
        actions: [
          if (widget.filter == 'all' && training != null && total > 0)
            IconButton(
              tooltip: context.l10n.lidQuestionList,
              icon: const Icon(Icons.format_list_numbered),
              onPressed: () => _showQuestionList(request, training),
            ),
          if (training != null && total > 0)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Center(child: Text('${training.index + 1} / $total')),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: TrainingProgressIndicator(
            correctProgress: total == 0 ? 0 : training!.correct / total,
            incorrectProgress: total == 0 ? 0 : training!.incorrect / total,
          ),
        ),
      ),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: sessionValue,
          errorMessage: context.l10n.lidLoadError,
          retryLabel: context.l10n.retryAction,
          onRetry: () => ref.invalidate(
            citizenshipTrainingSessionProvider(request),
          ),
          data: (session) {
            final currentTraining = session.training;
            if (currentTraining.total == 0) {
              return Center(child: Text(context.l10n.lidNoQuestions));
            }
            if (currentTraining.isComplete) {
              return TrainingCompletionView(
                title: context.l10n.lidTrainingComplete,
                correct: currentTraining.correct,
                incorrect: currentTraining.incorrect,
                total: currentTraining.total,
                secondaryAction: !currentTraining.hasMistakes
                    ? null
                    : TrainingCompletionAction(
                        label: context.l10n.retryMistakes,
                        onPressed: () => ref
                            .read(
                              citizenshipTrainingSessionProvider(
                                request,
                              ).notifier,
                            )
                            .retryMistakes(),
                      ),
              );
            }
            final question = currentTraining.currentQuestion;
            if (question == null) return const SizedBox.shrink();
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
                  selectedAnswer: currentTraining.selectedAnswer,
                  enabled: currentTraining.selectedAnswer == null,
                  answerKeys: _answerKeys,
                  answerStateFor: (answer) =>
                      _answerState(question, answer, currentTraining),
                  onSelected: (answer) {
                    unawaited(
                      ref
                          .read(
                            citizenshipTrainingSessionProvider(
                              request,
                            ).notifier,
                          )
                          .answer(answer),
                    );
                    unawaited(_keepAnswerVisible(answer));
                  },
                  onToggleFavorite: () => ref
                      .read(
                        citizenshipTrainingSessionProvider(request).notifier,
                      )
                      .toggleFavorite(question.id),
                  isFavorite: currentProgress?.isFavorite == true,
                  scrollTogether: true,
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: training == null || training.total == 0
          ? null
          : training.isComplete
          ? BottomActionButton(
              label: context.l10n.lidBackToOverview,
              onPressed: () => context.pop(),
            )
          : _CitizenshipTrainingBottomBar(
              question: training.currentQuestion!,
              selectedAnswer: training.selectedAnswer,
              isLastQuestion: training.index == training.total - 1,
              onPrimary: () => ref
                  .read(citizenshipTrainingSessionProvider(request).notifier)
                  .next(),
            ),
    );
  }

  TrainingAnswerState? _answerState(
    CitizenshipQuestion question,
    int answer,
    CitizenshipTrainingController training,
  ) {
    final selected = training.selectedAnswer;
    if (selected == null) return null;
    if (answer == question.correctAnswer) return TrainingAnswerState.correct;
    if (answer == selected) return TrainingAnswerState.incorrect;
    return null;
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

  Future<void> _showQuestionList(
    CitizenshipTrainingRequest request,
    CitizenshipTrainingController training,
  ) async {
    final queue = training.questions;
    if (queue.isEmpty) return;
    final selected = await showAppBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      title: context.l10n.lidQuestionList,
      maxHeightFactor: 0.75,
      builder: (sheetContext) => Consumer(
        builder: (context, ref, _) => CitizenshipQuestionListSheet(
          questions: queue,
          currentIndex: training.index,
          progress: ref.watch(citizenshipProgressProvider).value ?? const [],
          onSelected: (index) => Navigator.pop(sheetContext, index),
        ),
      ),
    );
    if (selected == null || !mounted) return;
    await ref
        .read(citizenshipTrainingSessionProvider(request).notifier)
        .jumpTo(selected);
  }
}

class _CitizenshipTrainingBottomBar extends StatelessWidget {
  const _CitizenshipTrainingBottomBar({
    required this.question,
    required this.selectedAnswer,
    required this.isLastQuestion,
    required this.onPrimary,
  });

  final CitizenshipQuestion question;
  final int? selectedAnswer;
  final bool isLastQuestion;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) => CitizenshipAnswerBottomBar(
    question: question,
    selectedAnswer: selectedAnswer,
    primaryEnabled: selectedAnswer != null,
    primaryLabel: isLastQuestion
        ? context.l10n.finishAction
        : context.l10n.nextQuestion,
    onPrimary: onPrimary,
  );
}
