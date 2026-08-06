import 'package:flutter/material.dart';
import 'package:wort_flutter/theme/app_spacing.dart';

class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({
    required this.title,
    required this.progressLabel,
    required this.progress,
    super.key,
  });

  final String title;
  final String progressLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      color: colors.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: AppSpacing.pageInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(progressLabel),
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
}
