import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_client/preferences_client.dart';

void main() {
  test('reads and writes the Expo learningProgress shape', () async {
    final client = _MockPreferencesClient();
    final repository = LearningProgressRepository(client: client);
    when(() => client.readString('learningProgress')).thenAnswer(
      (_) async => jsonEncode({
        'testedWordIds': ['book:module1.json:0'],
        'lastActivityByModule': {
          'book:module1.json': '2026-08-01T12:00:00.000Z',
        },
      }),
    );
    when(
      () => client.writeString('learningProgress', any()),
    ).thenAnswer((_) async {});

    final current = await repository.load();
    final next = await repository.recordResult(
      current: current,
      wordId: 'book:module1.json:1',
      correct: true,
      recordedAt: DateTime.utc(2026, 8, 2),
    );

    expect(
      next.testedWordIds,
      containsAll(['book:module1.json:0', 'book:module1.json:1']),
    );
    final saved =
        verify(
              () => client.writeString('learningProgress', captureAny()),
            ).captured.single
            as String;
    expect(
      (jsonDecode(saved)! as Map<String, Object?>)['testedWordIds'],
      hasLength(2),
    );
  });
}

class _MockPreferencesClient extends Mock implements PreferencesClient {}
