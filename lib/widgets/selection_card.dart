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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected
              ? colors.primaryContainer.withValues(alpha: 0.55)
              : colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  if (leading case final leading?) ...[
                    Icon(
                      leading,
                      size: 22,
                      color: enabled
                          ? (selected
                                ? colors.primary
                                : colors.onSurfaceVariant)
                          : colors.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 14),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: foreground.withValues(
                                  alpha: enabled ? 1 : 0.5,
                                ),
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                        ),
                        if (subtitle case final subtitle?) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colors.onSurfaceVariant.withValues(
                                    alpha: enabled ? 1 : 0.5,
                                  ),
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (badge case final badge?) ...[
                    const SizedBox(width: 12),
                    Container(
                      constraints: const BoxConstraints(minWidth: 32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? colors.primary.withValues(alpha: 0.12)
                            : colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        badge,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: selected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
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
          ),
        ),
      ),
    );
  }
}
