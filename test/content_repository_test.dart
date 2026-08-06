import 'dart:convert';

import 'package:course_client/course_client.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wort_flutter/content/content_repository.dart';

void main() {
  test('uses bundled course content before a remote bundle exists', () async {
    final repository = ContentRepository(
      cache: _MemoryCache(),
      fallback: _FallbackCourseClient(),
      httpClient: MockClient((_) async => http.Response('', 500)),
    );
    expect((await repository.loadBooks()).single['id'], 'bundled');
  });

  test('downloads, verifies, activates, and reuses remote content', () async {
    const root = 'https://example.com/';
    final module = [
      {
        'id': 'freiheit',
        'dictionaryId': 'freiheit',
        'type': 'noun',
        'word': 'Freiheit',
        'translation': {
          'en': ['freedom'],
        },
      },
    ];
    final exerciseWords = [
      {
        'id': 'warten-auf-akkusativ',
        'verb': 'warten',
        'preposition': 'auf',
        'case': 'Akkusativ',
        'translation': {
          'en': ['to wait for'],
        },
        'example': 'Ich warte auf den Bus.',
      },
    ];
    final moduleBytes = utf8.encode(jsonEncode(module));
    final exerciseWordBytes = utf8.encode(jsonEncode(exerciseWords));
    final book = {
      'schemaVersion': 1,
      'contentVersion': 'v1',
      'id': 'lid',
      'title': 'LiD',
      'level': 'LiD',
      'modules': [
        {
          'id': 'module0',
          'title': 'Module 1: Rights',
          'url': 'coursebooks/lid/module0.json',
          'sha256': sha256.convert(moduleBytes).toString(),
          'count': 1,
        },
      ],
    };
    final exercise = {
      'schemaVersion': 1,
      'contentVersion': 'v1',
      'id': 'fixed',
      'title': 'Fixed verbs',
      'description': {
        'en': ['Practice'],
      },
      'words': {
        'url': 'exercises/fixed/words.json',
        'sha256': sha256.convert(exerciseWordBytes).toString(),
        'count': 1,
      },
    };
    final bookBytes = utf8.encode(jsonEncode(book));
    final exerciseBytes = utf8.encode(jsonEncode(exercise));
    final catalog = {
      'schemaVersion': 1,
      'contentVersion': 'v1',
      'sources': [
        {
          'id': 'lid',
          'type': 'coursebook',
          'url': 'coursebooks/lid/book.json',
          'sha256': sha256.convert(bookBytes).toString(),
        },
        {
          'id': 'fixed',
          'type': 'exercise',
          'url': 'exercises/fixed/exercise.json',
          'sha256': sha256.convert(exerciseBytes).toString(),
        },
      ],
    };
    final catalogBytes = utf8.encode(jsonEncode(catalog));
    final manifest = {
      'schemaVersion': 1,
      'datasetVersion': 'v1',
      'catalog': {
        'url': 'catalog.json',
        'sha256': sha256.convert(catalogBytes).toString(),
      },
    };
    final responses = <String, List<int>>{
      '${root}manifest.json': utf8.encode(jsonEncode(manifest)),
      '${root}catalog.json': catalogBytes,
      '${root}coursebooks/lid/book.json': bookBytes,
      '${root}coursebooks/lid/module0.json': moduleBytes,
      '${root}exercises/fixed/exercise.json': exerciseBytes,
      '${root}exercises/fixed/words.json': exerciseWordBytes,
    };
    var requests = 0;
    final cache = _MemoryCache();
    final repository = ContentRepository(
      cache: cache,
      fallback: _FallbackCourseClient(),
      manifestUri: Uri.parse('${root}manifest.json'),
      httpClient: MockClient((request) async {
        requests++;
        final bytes = responses[request.url.toString()];
        return bytes == null
            ? http.Response('', 404)
            : http.Response.bytes(bytes, 200);
      }),
    );

    final result = await repository.synchronize(manual: true);
    expect(result.outcome, ContentSyncOutcome.updated);
    expect((await repository.loadBooks()).single['id'], 'lid');
    expect(
      (await repository.loadModuleWords(
        bookId: 'lid',
        moduleFile: 'module0.json',
      )).single['id'],
      'freiheit',
    );
    expect((await repository.loadExercise('fixed'))?['words'], exerciseWords);

    final second = await repository.synchronize(manual: true);
    expect(second.outcome, ContentSyncOutcome.notModified);
    expect(
      requests,
      12,
      reason: 'every manual check verifies the complete content graph',
    );

    cache.values['wort.content.bundle.v1'] = '{"books": []}';
    final recoveredRepository = ContentRepository(
      cache: cache,
      fallback: _FallbackCourseClient(),
      manifestUri: Uri.parse('${root}manifest.json'),
      httpClient: MockClient((request) async {
        final bytes = responses[request.url.toString()];
        return bytes == null
            ? http.Response('', 404)
            : http.Response.bytes(bytes, 200);
      }),
    );
    expect((await recoveredRepository.loadBooks()).single['id'], 'bundled');
    final recovered = await recoveredRepository.synchronize(manual: true);
    expect(recovered.outcome, ContentSyncOutcome.updated);
    expect((await recoveredRepository.loadBooks()).single['id'], 'lid');
  });

  test('does not activate a bundle with a checksum mismatch', () async {
    final repository = ContentRepository(
      cache: _MemoryCache(),
      fallback: _FallbackCourseClient(),
      manifestUri: Uri.parse('https://example.com/manifest.json'),
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'schemaVersion': 1,
            'datasetVersion': 'bad',
            'catalog': {'url': 'catalog.json', 'sha256': 'wrong'},
          }),
          200,
        ),
      ),
    );

    await expectLater(
      repository.synchronize(manual: true),
      throwsA(isA<FormatException>()),
    );
    expect((await repository.loadBooks()).single['id'], 'bundled');
  });

  test('rejects content whose declared record count is incorrect', () async {
    const root = 'https://example.com/';
    final wordsBytes = utf8.encode(jsonEncode(<Object?>[]));
    final descriptorBytes = utf8.encode(
      jsonEncode({
        'schemaVersion': 1,
        'id': 'book',
        'title': 'Book',
        'level': 'A1',
        'modules': [
          {
            'title': 'Module',
            'url': 'words.json',
            'sha256': sha256.convert(wordsBytes).toString(),
            'count': 1,
          },
        ],
      }),
    );
    final catalogBytes = utf8.encode(
      jsonEncode({
        'schemaVersion': 1,
        'sources': [
          {
            'id': 'book',
            'type': 'coursebook',
            'url': 'book.json',
            'sha256': sha256.convert(descriptorBytes).toString(),
          },
        ],
      }),
    );
    final responses = <String, List<int>>{
      '${root}manifest.json': utf8.encode(
        jsonEncode({
          'schemaVersion': 1,
          'datasetVersion': 'v1',
          'catalog': {
            'url': 'catalog.json',
            'sha256': sha256.convert(catalogBytes).toString(),
          },
        }),
      ),
      '${root}catalog.json': catalogBytes,
      '${root}book.json': descriptorBytes,
      '${root}words.json': wordsBytes,
    };
    final repository = ContentRepository(
      cache: _MemoryCache(),
      fallback: _FallbackCourseClient(),
      manifestUri: Uri.parse('${root}manifest.json'),
      httpClient: MockClient(
        (request) => Future.value(
          http.Response.bytes(responses[request.url.toString()]!, 200),
        ),
      ),
    );

    await expectLater(
      repository.synchronize(manual: true),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('count mismatch'),
        ),
      ),
    );
    expect((await repository.loadBooks()).single['id'], 'bundled');
  });
}

class _MemoryCache implements ContentCache {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}

class _FallbackCourseClient implements CourseClient {
  @override
  Future<List<Map<String, Object?>>> loadBooks() async => [
    {
      'id': 'bundled',
      'title': 'Bundled',
      'level': 'A1',
      'modules': [
        {'id': 1, 'title': 'Module', 'file': 'module0.json'},
      ],
    },
  ];

  @override
  Future<List<Map<String, Object?>>> loadModuleWords({
    required String bookId,
    required String moduleFile,
  }) async => const [];
}
