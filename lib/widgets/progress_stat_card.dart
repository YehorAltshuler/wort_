import 'package:flutter/material.dart';

class ProgressStatCard extends StatelessWidget {
  const ProgressStatCard({
    required this.icon,
    required this.label,
    required this.progress,
    required this.progressLabel,
    this.selected = false,
    this.onTap,
    this.fillHeight = true,
    super.key,
  });

  final IconData icon;
  final String label;
  final double progress;
  final String progressLabel;
  final bool selected;
  final VoidCallback? onTap;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        color: selected
            ? colors.secondaryContainer
            : colors.surfaceContainerLow,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: colors.primary),
                    const Spacer(),
                    if (selected)
                      Icon(Icons.check_circle, color: colors.primary, size: 20),
                  ],
                ),
                if (fillHeight) const Spacer() else const SizedBox(height: 24),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(5),
                  backgroundColor: colors.surface.withValues(alpha: 0.65),
                ),
                const SizedBox(height: 6),
                Text(
                  progressLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
