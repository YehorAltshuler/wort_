import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';

final learningProgressProvider =
    AsyncNotifierProvider<LearningProgressNotifier, LearningProgress>(
      LearningProgressNotifier.new,
    );

class LearningProgressNotifier extends AsyncNotifier<LearningProgress> {
  @override
  Future<LearningProgress> build() {
    return ref.read(learningProgressRepositoryProvider).load();
  }

  Future<void> recordResult(String wordId, {required bool correct}) async {
    final current = state.value ?? const LearningProgress();
    final next = await ref
        .read(learningProgressRepositoryProvider)
        .recordResult(
          current: current,
          wordId: wordId,
          correct: correct,
        );
    state = AsyncData(next);
  }
}
