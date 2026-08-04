import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/adaptive_image_grid.dart';
import 'package:wort_flutter/l10n/l10n.dart';
import 'package:wort_flutter/theme/app_spacing.dart';

class CitizenshipQuestionImage extends ConsumerWidget {
  const CitizenshipQuestionImage({
    required this.questionId,
    required this.hasImage,
    super.key,
  });

  final String questionId;
  final bool hasImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!hasImage) return const SizedBox.shrink();
    final image = ref.watch(citizenshipImageProvider(questionId));
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: image.when(
        loading: () => const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => const _UnavailableImage(),
        data: (value) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: value.isEmpty
              ? const _UnavailableImage(key: ValueKey('unavailable'))
              : value.length == 1
              ? SizedBox(
                  width: double.infinity,
                  child: _QuestionImageCard(
                    key: ValueKey('$questionId:${value.single.position}'),
                    bytes: value.single.bytes,
                  ),
                )
              : CitizenshipAdaptiveImageGrid(
                  key: ValueKey(questionId),
                  itemCount: value.length,
                  spacing: 8,
                  childAspectRatio: 1.25,
                  itemBuilder: (context, index) => _QuestionImageCard(
                    bytes: value[index].bytes,
                    label: context.l10n.lidImageLabel(index + 1),
                  ),
                ),
        ),
      ),
    );
  }
}

class _QuestionImageCard extends StatelessWidget {
  const _QuestionImageCard({
    required this.bytes,
    this.label,
    super.key,
  });

  final Uint8List bytes;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final cacheWidth =
        (MediaQuery.sizeOf(context).width *
                MediaQuery.devicePixelRatioOf(context))
            .round()
            .clamp(1, 1600);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: label == null
          ? Image.memory(
              bytes,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              cacheWidth: cacheWidth,
              errorBuilder: (context, error, stackTrace) =>
                  const _UnavailableImage(),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.memory(
                      bytes,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      cacheWidth: cacheWidth,
                      errorBuilder: (context, error, stackTrace) =>
                          const _UnavailableImage(),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      label!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _UnavailableImage extends StatelessWidget {
  const _UnavailableImage({super.key});

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: AppSpacing.pageInsets,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image_outlined),
          const SizedBox(width: 8),
          Flexible(child: Text(context.l10n.lidImageUnavailable)),
        ],
      ),
    ),
  );
}
