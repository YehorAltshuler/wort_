import 'package:flutter/material.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';

class TrainingCompletionAction {
  const TrainingCompletionAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
}

class TrainingCompletionView extends StatelessWidget {
  const TrainingCompletionView({
    required this.title,
    required this.correct,
    required this.incorrect,
    this.total,
    this.success = true,
    this.message,
    this.secondaryAction,
    this.footer,
    super.key,
  });

  final String title;
  final int correct;
  final int incorrect;
  final int? total;
  final bool success;
  final Widget? message;
  final TrainingCompletionAction? secondaryAction;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final answered = correct + incorrect;
    final denominator = total ?? answered;
    final accuracy = denominator == 0 ? 0 : correct / denominator;
    final colors = Theme.of(context).colorScheme;
    final heroForeground = success ? colors.onSurfaceVariant : colors.error;
    final heroBackground = success
        ? colors.surfaceContainerHighest
        : colors.errorContainer;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: ResponsiveContent.insets(
              context,
              const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xxl,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
            ),
            children: [
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: heroBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          success
                              ? Icons.emoji_events_outlined
                              : Icons.refresh_rounded,
                          size: 42,
                          color: heroForeground,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      if (message case final message?) ...[
                        const SizedBox(height: AppSpacing.sm),
                        DefaultTextStyle.merge(
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.onSurfaceVariant),
                          child: message,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cards = [
                    _ResultStat(
                      icon: Icons.check_circle_outline,
                      label: context.l10n.correctAnswer,
                      value: '$correct',
                      color: TrainingAnswerChip.correctColor(context),
                    ),
                    _ResultStat(
                      icon: Icons.cancel_outlined,
                      label: context.l10n.wrongAnswer,
                      value: '$incorrect',
                      color: colors.error,
                    ),
                    _ResultStat(
                      icon: Icons.track_changes_rounded,
                      label: context.l10n.lidAccuracy,
                      value: '${(accuracy * 100).round()}%',
                      color: colors.primary,
                    ),
                  ];
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        for (final card in cards) ...[
                          card,
                          if (card != cards.last)
                            const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    );
                  }
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final card in cards) ...[
                          Expanded(child: card),
                          if (card != cards.last)
                            const SizedBox(width: AppSpacing.sm),
                        ],
                      ],
                    ),
                  );
                },
              ),
              if (footer case final footer?) ...[
                const SizedBox(height: AppSpacing.xxl),
                footer,
              ],
            ],
          ),
        ),
        if (secondaryAction case final action?)
          Padding(
            padding: ResponsiveContent.insets(
              context,
              const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            ),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: action.onPressed,
                icon: Icon(action.icon ?? Icons.replay_rounded),
                label: Text(action.label),
              ),
            ),
          ),
      ],
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
