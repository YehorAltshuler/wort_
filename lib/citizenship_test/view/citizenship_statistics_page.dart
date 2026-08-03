import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';

class CitizenshipStatisticsPage extends ConsumerWidget {
  const CitizenshipStatisticsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(citizenshipProgressProvider);
    final sessions = ref.watch(citizenshipExamSessionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.learningProgress)),
      body: progress.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (items) => sessions.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (exams) => _Statistics(progress: items, exams: exams),
        ),
      ),
    );
  }
}

class _Statistics extends StatelessWidget {
  const _Statistics({required this.progress, required this.exams});
  final List<QuestionProgressRecord> progress;
  final List<ExamSessionRecord> exams;
  @override
  Widget build(BuildContext context) {
    const total = LebenInDeutschlandExamRules.totalCatalogQuestionCount;
    final answered = progress
        .where((item) => item.lastSelectedAnswer != null)
        .length;
    final correct = progress.where((item) => item.isMastered).length;
    final incorrect = answered - correct;
    final progressValue = answered / total;
    final correctProgress = correct / total;
    final incorrectProgress = incorrect / total;
    final completed = exams.where((exam) => exam.completedAt != null).toList();
    return ListView(
      padding: AppSpacing.pageInsets,
      children: [
        _OverallCard(answered: answered, progress: progressValue),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ProgressStatCard(
                  icon: Icons.check_circle_outline,
                  label: context.l10n.lidCorrect,
                  progress: correctProgress,
                  progressLabel: '$correct / $total',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ProgressStatCard(
                  icon: Icons.cancel_outlined,
                  label: context.l10n.lidIncorrect,
                  progress: incorrectProgress,
                  progressLabel: '$incorrect / $total',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.lidExams,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (completed.isEmpty) Text(context.l10n.lidNoCompletedExams),
        for (final exam in completed)
          ListTile(
            leading: Icon(
              exam.passedCitizenship == true
                  ? Icons.check_circle
                  : Icons.cancel,
            ),
            title: Text('${exam.correctCount ?? 0} / 33 · ${exam.stateCode}'),
            subtitle: Text(exam.completedAt!.toLocal().toString()),
          ),
      ],
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.answered, required this.progress});

  final int answered;
  final double progress;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    elevation: 0,
    child: Padding(
      padding: AppSpacing.pageInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.lidTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.lidAnsweredProgress(
              answered,
              LebenInDeutschlandExamRules.totalCatalogQuestionCount,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    ),
  );
}
