import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/content/content_repository.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';

final contentMetadataProvider = FutureProvider<ContentSyncMetadata>(
  (ref) => ref.watch(contentRepositoryProvider).loadMetadata(),
);

final contentSyncControllerProvider =
    AsyncNotifierProvider<ContentSyncController, ContentSyncResult?>(
      ContentSyncController.new,
    );

final contentBootstrapProvider = FutureProvider<void>((ref) async {
  try {
    final result = await ref.watch(contentRepositoryProvider).synchronize();
    ref.invalidate(contentMetadataProvider);
    if (result.outcome == ContentSyncOutcome.updated) {
      ref
        ..invalidate(booksProvider)
        ..invalidate(moduleWordsProvider)
        ..invalidate(fixedPrepositionExerciseProvider);
    }
  } on Object {
    // Bundled assets remain the offline and recovery fallback.
  }
});

class ContentSyncController extends AsyncNotifier<ContentSyncResult?> {
  @override
  FutureOr<ContentSyncResult?> build() => null;

  Future<ContentSyncResult?> synchronize({bool manual = false}) async {
    if (state.isLoading) return state.value;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(contentRepositoryProvider).synchronize(manual: manual),
    );
    state = result;
    ref
      ..invalidate(contentMetadataProvider)
      ..invalidate(booksProvider)
      ..invalidate(moduleWordsProvider)
      ..invalidate(fixedPrepositionExerciseProvider);
    return result.value;
  }
}
