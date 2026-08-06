import 'package:flutter/material.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/adaptive_stat_card_row.dart';
import 'package:wort_flutter/widgets/overall_progress_card.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

class TrainingStatisticsView extends StatelessWidget {
  const TrainingStatisticsView({
    required this.title,
    required this.total,
    required this.answered,
    required this.correct,
    required this.incorrect,
    this.keyPrefix = 'training',
    super.key,
  });

  final String title;
  final int total;
  final int answered;
  final int correct;
  final int incorrect;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final answeredProgress = total == 0 ? 0.0 : answered / total;
    final correctProgress = total == 0 ? 0.0 : correct / total;
    final incorrectProgress = total == 0 ? 0.0 : incorrect / total;
    return ListView(
      padding: ResponsiveContent.insets(context, AppSpacing.pageInsets),
      children: [
        OverallProgressCard(
          key: ValueKey('$keyPrefix-all-stat'),
          title: title,
          progressLabel: context.l10n.lidAnsweredProgress(answered, total),
          progress: answeredProgress,
        ),
        const SizedBox(height: AppSpacing.md),
        AdaptiveStatCardRow(
          firstBuilder: (context, {required fillHeight}) => ProgressStatCard(
            key: ValueKey('$keyPrefix-correct-stat'),
            icon: Icons.check_circle_outline,
            label: context.l10n.lidCorrectAnswers,
            progress: correctProgress,
            progressLabel: '$correct',
            fillHeight: fillHeight,
          ),
          secondBuilder: (context, {required fillHeight}) => ProgressStatCard(
            key: ValueKey('$keyPrefix-incorrect-stat'),
            icon: Icons.cancel_outlined,
            label: context.l10n.lidIncorrect,
            progress: incorrectProgress,
            progressLabel: '$incorrect',
            fillHeight: fillHeight,
          ),
        ),
      ],
    );
  }
}
