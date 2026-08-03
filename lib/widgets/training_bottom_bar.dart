import 'package:flutter/material.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/widgets/bottom_action_bar.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';

class TrainingBottomBar extends StatelessWidget {
  const TrainingBottomBar({
    required this.result,
    required this.correctAnswers,
    required this.primaryEnabled,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.secondaryEnabled = false,
    this.onSecondary,
    super.key,
  });

  final bool? result;
  final List<String> correctAnswers;
  final bool primaryEnabled;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final bool secondaryEnabled;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final checked = result != null;
    final feedbackColor = result == true
        ? TrainingAnswerChip.correctColor(context)
        : colors.error;
    return BottomActionBar(
      feedback: AnimatedSize(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: checked
            ? Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      result == true ? Icons.check_circle : Icons.cancel,
                      color: feedbackColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(result),
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, opacity, child) => Opacity(
                          opacity: opacity,
                          child: child,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result == true
                                  ? context.l10n.correctAnswer
                                  : context.l10n.wrongAnswer,
                              style: TextStyle(
                                color: feedbackColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (result == false) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${context.l10n.correctAnswerLabel}: '
                                '${correctAnswers.join(' / ')}',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
      child: Row(
        children: [
          if (secondaryLabel case final label?) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: secondaryEnabled ? onSecondary : null,
                child: Text(label),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: FilledButton(
              onPressed: primaryEnabled ? onPrimary : null,
              child: Text(primaryLabel),
            ),
          ),
        ],
      ),
    );
  }
}
