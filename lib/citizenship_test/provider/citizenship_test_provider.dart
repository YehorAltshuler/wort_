import 'dart:async';
import 'dart:convert';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart' show FutureProviderFamily;
import 'package:wort_flutter/app/provider/repository_providers.dart';

final FutureProvider<void> citizenshipBootstrapProvider = FutureProvider<void>((
  ref,
) async {
  final repository = ref.watch(citizenshipTestRepositoryProvider);
  final jsonData = await rootBundle.load(
    'assets/citizenship_test/questions.json',
  );
  final datasetManifestText = await rootBundle.loadString(
    'assets/citizenship_test/manifest.json',
  );
  final datasetManifest =
      jsonDecode(datasetManifestText) as Map<String, Object?>;
  final questionsManifest =
      datasetManifest['questions']! as Map<String, Object?>;
  final imageManifestText = await rootBundle.loadString(
    'assets/citizenship_test/images.json',
  );
  final imageManifest = (jsonDecode(imageManifestText) as Map<String, Object?>)
      .map(
        (key, value) => MapEntry(key, value! as String),
      );
  try {
    await repository.bootstrap(
      jsonBytes: jsonData.buffer.asUint8List(),
      datasetVersion: datasetManifest['datasetVersion']! as String,
      expectedHash: questionsManifest['sha256']! as String,
      imageAssets: imageManifest,
      loadAsset: (path) async {
        final data = await rootBundle.load(path);
        return Uint8List.sublistView(data);
      },
    );
  } on Object {
    // A remote synchronization below can still recover an empty local store.
  }
  try {
    await repository.synchronize();
  } on Object {
    return;
  }
});

final citizenshipQuestionsProvider = StreamProvider<List<CitizenshipQuestion>>(
  (ref) {
    ref.watch(citizenshipBootstrapProvider);
    return ref.watch(citizenshipTestRepositoryProvider).watchQuestions();
  },
);

final citizenshipProgressProvider =
    FutureProvider<List<QuestionProgressRecord>>(
      (ref) => ref.watch(citizenshipTestRepositoryProvider).loadProgress(),
    );

final FutureProvider<SyncMetadataRecord> citizenshipSyncMetadataProvider =
    FutureProvider<SyncMetadataRecord>((ref) async {
      ref.watch(citizenshipBootstrapProvider);
      return ref.watch(citizenshipTestRepositoryProvider).loadSyncMetadata();
    });

final FutureProviderFamily<List<QuestionImage>, String>
citizenshipImageProvider = FutureProvider.autoDispose
    .family<List<QuestionImage>, String>(
      (ref, questionId) =>
          ref.watch(citizenshipTestRepositoryProvider).loadImages(questionId),
    );

final FutureProvider<List<ExamSessionRecord>> citizenshipExamSessionsProvider =
    FutureProvider((ref) {
      return ref.watch(citizenshipTestRepositoryProvider).loadExamSessions();
    });

final citizenshipSyncControllerProvider =
    AsyncNotifierProvider<CitizenshipSyncController, SyncResult?>(
      CitizenshipSyncController.new,
    );

class CitizenshipSyncController extends AsyncNotifier<SyncResult?> {
  @override
  FutureOr<SyncResult?> build() => null;

  Future<void> synchronize({bool manual = false}) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await ref.read(citizenshipBootstrapProvider.future);
    } on Object {
      // Manual synchronization remains the recovery path for bootstrap errors.
    }
    state = await AsyncValue.guard(
      () => ref
          .read(citizenshipTestRepositoryProvider)
          .synchronize(manual: manual),
    );
    ref
      ..invalidate(citizenshipSyncMetadataProvider)
      ..invalidate(citizenshipProgressProvider);
  }
}
