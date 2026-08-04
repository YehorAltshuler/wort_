import 'dart:convert';

import 'package:learning_progress_repository/src/learning_progress.dart';
import 'package:preferences_client/preferences_client.dart';

class LearningProgressRepository {
  LearningProgressRepository({PreferencesClient? client})
    : _client = client ?? PreferencesClient();

  static const _storageKey = 'learningProgress';
  final PreferencesClient _client;

  Future<LearningProgress> load() async {
    final raw = await _client.readString(_storageKey);
    if (raw == null) return const LearningProgress();
    final json = jsonDecode(raw)! as Map<String, Object?>;
    return LearningProgress(
      testedWordIds: (json['testedWordIds'] as List<Object?>? ?? const [])
          .cast<String>()
          .toSet(),
      incorrectWordIds: (json['incorrectWordIds'] as List<Object?>? ?? const [])
          .cast<String>()
          .toSet(),
      lastActivityByModule:
          (json['lastActivityByModule'] as Map<String, Object?>? ?? const {})
              .map(
                (key, value) => MapEntry(key, DateTime.parse(value! as String)),
              ),
    );
  }

  Future<LearningProgress> recordResult({
    required LearningProgress current,
    required String wordId,
    required bool correct,
    DateTime? recordedAt,
  }) async {
    final tested = {...current.testedWordIds};
    final incorrect = {...current.incorrectWordIds};
    if (correct) {
      tested.add(wordId);
      incorrect.remove(wordId);
    } else {
      tested.remove(wordId);
      incorrect.add(wordId);
    }
    final moduleKey = wordId.split(':').take(2).join(':');
    final next = LearningProgress(
      testedWordIds: tested,
      incorrectWordIds: incorrect,
      lastActivityByModule: {
        ...current.lastActivityByModule,
        moduleKey: recordedAt ?? DateTime.now(),
      },
    );
    await _client.writeString(
      _storageKey,
      jsonEncode({
        'testedWordIds': next.testedWordIds.toList(),
        'incorrectWordIds': next.incorrectWordIds.toList(),
        'lastActivityByModule': next.lastActivityByModule.map(
          (key, value) => MapEntry(key, value.toIso8601String()),
        ),
      }),
    );
    return next;
  }
}
