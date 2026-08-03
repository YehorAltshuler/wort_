import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_client/preferences_client.dart';
import 'package:preferences_collections_client/preferences_collections_client.dart';

void main() {
  test('reads and writes the Expo wordCollections JSON shape', () async {
    final preferences = _MockPreferencesClient();
    final client = PreferencesCollectionsClient(preferences: preferences);
    when(() => preferences.readString('wordCollections')).thenAnswer(
      (_) async => jsonEncode({
        'favorites': ['lexicon:haus'],
        'lists': [
          {
            'id': '123',
            'name': 'Travel',
            'wordIds': ['book:module1.json:0'],
          },
        ],
      }),
    );
    when(
      () => preferences.writeString('wordCollections', any()),
    ).thenAnswer((_) async {});

    final collections = await client.loadCollections();
    await client.toggleWord(
      collectionId: 'favorites',
      wordId: 'lexicon:baum',
    );

    expect(collections.first.wordIds, ['lexicon:haus']);
    final saved =
        verify(
              () => preferences.writeString('wordCollections', captureAny()),
            ).captured.single
            as String;
    expect(
      (jsonDecode(saved)! as Map<String, Object?>)['favorites'],
      ['lexicon:haus', 'lexicon:baum'],
    );
  });
}

class _MockPreferencesClient extends Mock implements PreferencesClient {}
