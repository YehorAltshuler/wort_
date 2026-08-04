import 'dart:typed_data';

import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/citizenship_test/widgets/adaptive_image_grid.dart';
import 'package:wort_flutter/widgets/training_answer_chip.dart';

class CitizenshipImageAnswerGrid extends ConsumerWidget {
  const CitizenshipImageAnswerGrid({
    required this.questionId,
    required this.answers,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.enabled,
    required this.answerKeys,
    required this.onSelected,
    this.showFeedback = true,
    super.key,
  });

  final String questionId;
  final List<String> answers;
  final int correctAnswer;
  final int? selectedAnswer;
  final bool enabled;
  final List<GlobalKey> answerKeys;
  final ValueChanged<int> onSelected;
  final bool showFeedback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(citizenshipImageProvider(questionId));
    return images.when(
      loading: () => const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => _ImageGrid(
        answers: answers,
        images: const [],
        correctAnswer: correctAnswer,
        selectedAnswer: selectedAnswer,
        enabled: enabled,
        answerKeys: answerKeys,
        showFeedback: showFeedback,
        onSelected: onSelected,
      ),
      data: (value) => _ImageGrid(
        answers: answers,
        images: value,
        correctAnswer: correctAnswer,
        selectedAnswer: selectedAnswer,
        enabled: enabled,
        answerKeys: answerKeys,
        showFeedback: showFeedback,
        onSelected: onSelected,
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({
    required this.answers,
    required this.images,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.enabled,
    required this.answerKeys,
    required this.showFeedback,
    required this.onSelected,
  });

  final List<String> answers;
  final List<QuestionImage> images;
  final int correctAnswer;
  final int? selectedAnswer;
  final bool enabled;
  final List<GlobalKey> answerKeys;
  final bool showFeedback;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return CitizenshipAdaptiveImageGrid(
      itemCount: answers.length,
      childAspectRatio: 0.9,
      itemBuilder: (context, index) {
        final image = images
            .where((item) => item.position == index)
            .firstOrNull;
        final state = selectedAnswer == null || !showFeedback
            ? null
            : index == correctAnswer
            ? TrainingAnswerState.correct
            : index == selectedAnswer
            ? TrainingAnswerState.incorrect
            : null;
        return _ImageAnswerCard(
          key: answerKeys[index],
          position: index,
          label: answers[index],
          bytes: image?.bytes,
          selected: selectedAnswer == index,
          enabled: enabled,
          answerState: state,
          onTap: () => onSelected(index),
        );
      },
    );
  }
}

class _ImageAnswerCard extends StatelessWidget {
  const _ImageAnswerCard({
    required this.position,
    required this.label,
    required this.bytes,
    required this.selected,
    required this.enabled,
    required this.answerState,
    required this.onTap,
    super.key,
  });

  final int position;
  final String label;
  final Uint8List? bytes;
  final bool selected;
  final bool enabled;
  final TrainingAnswerState? answerState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final feedbackColor = switch (answerState) {
      TrainingAnswerState.correct => TrainingAnswerChip.correctColor(context),
      TrainingAnswerState.incorrect => colors.error,
      null => null,
    };
    final foreground = feedbackColor ?? colors.onSurface;
    final border =
        feedbackColor ?? (selected ? colors.primary : colors.outlineVariant);
    final background = feedbackColor == null
        ? colors.surfaceContainerLow
        : feedbackColor.withValues(alpha: 0.14);
    final cacheWidth =
        (MediaQuery.sizeOf(context).width *
                MediaQuery.devicePixelRatioOf(context) /
                2)
            .round()
            .clamp(1, 900);

    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      child: ExcludeSemantics(
        child: IgnorePointer(
          ignoring: !enabled,
          child: Card(
            margin: EdgeInsets.zero,
            color: background,
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: border,
                width: answerState != null || selected ? 2 : 1,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: bytes == null
                          ? Icon(
                              Icons.broken_image_outlined,
                              color: colors.onSurfaceVariant,
                            )
                          : Image.memory(
                              bytes!,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              cacheWidth: cacheWidth,
                            ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: feedbackColor == null
                          ? colors.surfaceContainer
                          : feedbackColor.withValues(alpha: 0.08),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: border.withValues(alpha: 0.14),
                          foregroundColor: foreground,
                          child: Text(
                            String.fromCharCode(65 + position),
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: foreground,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            label,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: foreground,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
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
