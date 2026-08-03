import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:web_lexicon_client/web_lexicon_client.dart';

void main() {
  test(
    'loads indexes once and fetches only the matching detail shard',
    () async {
      final requestedPaths = <String>[];
      final client = WebLexiconClient(
        baseUri: Uri.parse('https://example.test/app/'),
        httpClient: MockClient((request) async {
          requestedPaths.add(request.url.path);
          if (request.url.path.endsWith('/index.json')) {
            return Response(jsonEncode(_entries), 200);
          }
          if (request.url.path.endsWith('/search-index.json')) {
            return Response(jsonEncode(_searchIndex), 200);
          }
          if (request.url.path.contains('/details/')) {
            return Response(jsonEncode(_details), 200);
          }
          return Response('', 404);
        }),
      );

      final firstSearch = await client.search('haus');
      final secondSearch = await client.search('haust');
      final details = await client.getById('haus');

      expect(firstSearch.first.normalized, 'haus');
      expect(secondSearch.single.normalized, 'haustür');
      expect(details!.lemma, 'Haus');
      expect(
        requestedPaths.where((path) => path.endsWith('/index.json')),
        hasLength(1),
      );
      expect(
        requestedPaths.where((path) => path.endsWith('/search-index.json')),
        hasLength(1),
      );
      expect(
        requestedPaths.where((path) => path.contains('/details/')),
        hasLength(1),
      );
    },
  );
}

const List<Map<String, Object>> _entries = [
  {
    'id': 'haus',
    'lemma': 'Haus',
    'normalized': 'haus',
    'partOfSpeech': 'noun',
    'frequencyRank': 1,
  },
  {
    'id': 'haustür',
    'lemma': 'Haustür',
    'normalized': 'haustür',
    'partOfSpeech': 'noun',
    'frequencyRank': 2,
  },
];

const Map<String, Object> _searchIndex = {
  'grams': {
    'hau': [0, 1],
    'aus': [0, 1],
    'ust': [1],
  },
  'sortedIds': [0, 1],
};

const Map<String, Object> _details = {
  'haus': {
    'lemma': 'Haus',
    'partOfSpeech': 'noun',
    'frequencyRank': 1,
    'senses': [
      {
        'definitions': {'de': 'Gebäude'},
      },
    ],
  },
};
