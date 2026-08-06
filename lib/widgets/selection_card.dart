import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.badge,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final IconData? leading;
  final String? badge;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = enabled ? colors.onSurface : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: ListTile(
        enabled: enabled,
        selected: selected,
        selectedTileColor: colors.primaryContainer.withValues(alpha: 0.28),
        onTap: enabled ? onTap : null,
        contentPadding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
        leading: leading == null
            ? null
            : Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(
                    alpha: enabled ? 0.13 : 0.06,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  leading,
                  color: colors.primary.withValues(alpha: enabled ? 1 : 0.4),
                ),
              ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: foreground.withValues(alpha: enabled ? 1 : 0.5),
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant.withValues(
                    alpha: enabled ? 1 : 0.5,
                  ),
                ),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge case final badge?) ...[
              Container(
                height: 28,
                constraints: const BoxConstraints(minWidth: 32),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badge,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? colors.primary : colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: enabled
                  ? (selected ? colors.primary : colors.onSurfaceVariant)
                  : colors.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
