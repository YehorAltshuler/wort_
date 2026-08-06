import 'package:flutter/material.dart';

class ProgressStatCard extends StatelessWidget {
  const ProgressStatCard({
    required this.icon,
    required this.label,
    required this.progress,
    required this.progressLabel,
    this.fillHeight = true,
    super.key,
  });

  final IconData icon;
  final String label;
  final double progress;
  final String progressLabel;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    return _ProgressCardFrame(
      child: _ProgressCardContent(
        icon: icon,
        label: label,
        progress: progress,
        progressLabel: progressLabel,
        fillHeight: fillHeight,
      ),
    );
  }
}

class SelectableProgressCard extends StatelessWidget {
  const SelectableProgressCard({
    required this.icon,
    required this.label,
    required this.progress,
    required this.progressLabel,
    required this.selected,
    required this.onTap,
    this.fillHeight = true,
    super.key,
  });

  final IconData icon;
  final String label;
  final double progress;
  final String progressLabel;
  final bool selected;
  final VoidCallback onTap;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) => _ProgressCardFrame(
    selected: selected,
    onTap: onTap,
    child: _ProgressCardContent(
      icon: icon,
      label: label,
      progress: progress,
      progressLabel: progressLabel,
      fillHeight: fillHeight,
      selected: selected,
    ),
  );
}

class _ProgressCardFrame extends StatelessWidget {
  const _ProgressCardFrame({
    required this.child,
    this.selected = false,
    this.onTap,
  });

  final Widget child;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final content = Ink(
      color: selected ? colors.secondaryContainer : colors.surfaceContainerLow,
      child: onTap == null ? child : InkWell(onTap: onTap, child: child),
    );
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
      child: content,
    );
  }
}

class _ProgressCardContent extends StatelessWidget {
  const _ProgressCardContent({
    required this.icon,
    required this.label,
    required this.progress,
    required this.progressLabel,
    required this.fillHeight,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final double progress;
  final String progressLabel;
  final bool fillHeight;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
