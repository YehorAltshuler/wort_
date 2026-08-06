import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/adaptive_stat_card_row.dart';
import 'package:wort_flutter/widgets/bottom_action_button.dart';
import 'package:wort_flutter/widgets/overall_progress_card.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class CitizenshipTestHomePage extends ConsumerWidget {
  const CitizenshipTestHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(citizenshipQuestionsProvider);
    final progress = ref.watch(citizenshipProgressProvider);
    final sessions = ref.watch(citizenshipExamSessionsProvider);
    final bundesland = ref.watch(settingsProvider).value?.bundesland ?? 'BE';
    final ready = questions.hasValue && progress.hasValue;
    final activeSession = sessions.value
        ?.where((session) => session.completedAt == null)
        .firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.learningProgress)),
      body: ResponsiveContent(
        child: Column(
          children: [
            Expanded(
              child: questions.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('$error')),
                data: (items) => progress.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Center(child: Text('$error')),
                  data: (records) => _StatisticsOverview(
                    questions: items,
                    progress: records,
                    bundesland: bundesland,
                  ),
                ),
              ),
            ),
            if (activeSession case final session?)
              Padding(
                padding: AppSpacing.horizontalPageInsets,
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: ready
                        ? () => context.push(_sessionRoute(session.mode))
                        : null,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.l10n.lidContinueSession),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionButton(
        label: context.l10n.configureTraining,
        onPressed: ready
            ? () => context.push(AppRoute.citizenshipSetup())
            : null,
      ),
    );
  }

  String _sessionRoute(CitizenshipSessionMode mode) => switch (mode) {
    CitizenshipSessionMode.exam => AppRoute.citizenshipExam,
    CitizenshipSessionMode.allQuestions =>
      '${AppRoute.citizenshipTraining}?filter=all&random=false',
  };
}

class _StatisticsOverview extends StatelessWidget {
  const _StatisticsOverview({
    required this.questions,
    required this.progress,
    required this.bundesland,
  });

  final List<CitizenshipQuestion> questions;
  final List<QuestionProgressRecord> progress;
  final String bundesland;

  @override
  Widget build(BuildContext context) {
    final available = questions
        .where(
          (question) =>
              question.isAvailable &&
              (question.scope == QuestionScope.general ||
                  question.stateCode == bundesland),
        )
        .toList();
    final availableIds = available.map((question) => question.id).toSet();
    final relevantProgress = progress
        .where((item) => availableIds.contains(item.questionId))
        .toList();
    final answered = relevantProgress
        .where((item) => item.lastSelectedAnswer != null)
        .length;
    final correct = relevantProgress.where((item) => item.isMastered).length;
    final incorrect = answered - correct;
    final ratio = available.isEmpty ? 0.0 : answered / available.length;
    final correctRatio = available.isEmpty ? 0.0 : correct / available.length;
    final incorrectRatio = available.isEmpty
        ? 0.0
        : incorrect / available.length;

    return ListView(
      padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
      children: [
        OverallProgressCard(
          title: context.l10n.lidTitle,
          progressLabel: context.l10n.lidAnsweredProgress(
            answered,
            available.length,
          ),
          progress: ratio,
        ),
        const SizedBox(height: 12),
        AdaptiveStatCardRow(
          firstBuilder: (context, {required fillHeight}) => ProgressStatCard(
            key: const ValueKey('lid-correct-stat'),
            icon: Icons.check_circle_outline,
            label: context.l10n.lidCorrectAnswers,
            progress: correctRatio,
            progressLabel: '$correct',
            fillHeight: fillHeight,
          ),
          secondBuilder: (context, {required fillHeight}) => ProgressStatCard(
            key: const ValueKey('lid-incorrect-stat'),
            icon: Icons.cancel_outlined,
            label: context.l10n.lidIncorrect,
            progress: incorrectRatio,
            progressLabel: '$incorrect',
            fillHeight: fillHeight,
          ),
        ),
      ],
    );
  }
}
