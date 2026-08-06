import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    required this.errorMessage,
    this.onRetry,
    this.retryLabel,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T value) data;
  final String errorMessage;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) => value.when(
    skipLoadingOnRefresh: true,
    skipLoadingOnReload: true,
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stackTrace) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(errorMessage, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(
                retryLabel ?? MaterialLocalizations.of(context).okButtonLabel,
              ),
            ),
          ],
        ],
      ),
    ),
    data: data,
  );
}
