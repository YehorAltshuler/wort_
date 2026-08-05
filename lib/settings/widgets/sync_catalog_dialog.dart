import 'package:flutter/material.dart';
import 'package:wort_flutter/theme/app_spacing.dart';

class SyncCatalogDialog extends StatelessWidget {
  const SyncCatalogDialog({
    required this.title,
    required this.status,
    required this.details,
    required this.isLoading,
    required this.cancelLabel,
    required this.checkLabel,
    required this.onCheck,
    this.errorMessage,
    this.errorDetails,
    super.key,
  });

  final String title;
  final String status;
  final List<Widget> details;
  final bool isLoading;
  final String cancelLabel;
  final String checkLabel;
  final VoidCallback onCheck;
  final String? errorMessage;
  final String? errorDetails;

  @override
  Widget build(BuildContext context) => AlertDialog(
    icon: Icon(isLoading ? Icons.sync : Icons.cloud_done_outlined),
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(status, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.lg),
        ...details,
        if (errorDetails case final error?) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            errorMessage ?? error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              error,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
        if (isLoading) ...[
          const SizedBox(height: AppSpacing.lg),
          const LinearProgressIndicator(),
        ],
      ],
    ),
    actions: [
      TextButton(
        onPressed: isLoading ? null : () => Navigator.pop(context),
        child: Text(cancelLabel),
      ),
      FilledButton.icon(
        onPressed: isLoading ? null : onCheck,
        icon: const Icon(Icons.refresh),
        label: Text(checkLabel),
      ),
    ],
  );
}
