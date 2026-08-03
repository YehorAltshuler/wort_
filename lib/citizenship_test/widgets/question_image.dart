import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
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
              ? _QuestionImageCard(
                  key: ValueKey('$questionId:${value.single.position}'),
                  bytes: value.single.bytes,
                )
              : GridView.builder(
                  key: ValueKey(questionId),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.25,
                  ),
                  itemCount: value.length,
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          maxHeight: 320,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.memory(
                bytes,
                width: double.infinity,
                height: label == null ? 280 : 220,
                fit: BoxFit.contain,
                cacheWidth: cacheWidth,
                errorBuilder: (context, error, stackTrace) =>
                    const _UnavailableImage(),
              ),
            ),
            if (label case final label?)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UnavailableImage extends StatelessWidget {
  const _UnavailableImage({super.key});

  @override
  Widget build(BuildContext context) => Card(
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
