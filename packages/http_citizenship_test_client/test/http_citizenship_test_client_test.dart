import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_citizenship_test_client/http_citizenship_test_client.dart';
import 'package:test/test.dart';

void main() {
  test('loads manifest then checksum-verified questions', () async {
    final questions = utf8.encode('{"schemaVersion":1,"questions":[]}');
    var requests = 0;
    final client = HttpCitizenshipTestClient(
      manifestUri: Uri.parse('https://example.com/data/manifest.json'),
      client: MockClient((request) async {
        requests++;
        if (request.url.path.endsWith('manifest.json')) {
          expect(request.headers['If-None-Match'], 'tag');
          expect(request.headers['If-Modified-Since'], 'date');
          return http.Response(
            jsonEncode({
              'schemaVersion': 1,
              'datasetVersion': '2026-08-02',
              'questions': {
                'url': 'questions.json',
                'sha256': sha256.convert(questions).toString(),
                'count': 460,
              },
              'imagesBaseUrl': 'images/',
            }),
            200,
            headers: {'etag': 'new'},
          );
        }
        expect(
          request.url.toString(),
          'https://example.com/data/questions.json',
        );
        return http.Response.bytes(questions, 200);
      }),
    );
    final response = await client.fetchDataset(
      etag: 'tag',
      lastModified: 'date',
    );
    expect(response.notModified, isFalse);
    expect(response.datasetVersion, '2026-08-02');
    expect(response.expectedCount, 460);
    expect(response.etag, 'new');
    expect(requests, 2);
  });

  test('treats manifest HTTP 304 as not modified', () async {
    final client = HttpCitizenshipTestClient(
      client: MockClient((_) async => http.Response('', 304)),
    );
    expect((await client.fetchDataset()).notModified, isTrue);
  });

  test('rejects a questions checksum mismatch', () async {
    final client = HttpCitizenshipTestClient(
      client: MockClient((request) async {
        if (request.url.path.endsWith('manifest.json')) {
          return http.Response(
            jsonEncode({
              'schemaVersion': 1,
              'datasetVersion': 'test',
              'questions': {
                'url': 'questions.json',
                'sha256':
                    '00000000000000000000000000000000'
                    '00000000000000000000000000000000',
                'count': 460,
              },
            }),
            200,
          );
        }
        return http.Response('{}', 200);
      }),
    );
    expect(
      client.fetchDataset,
      throwsA(isA<CitizenshipTestHttpException>()),
    );
  });

  test('validates image MIME and size', () async {
    final valid = HttpCitizenshipTestClient(
      client: MockClient(
        (_) async => http.Response.bytes(
          [1, 2, 3],
          200,
          headers: {'content-type': 'image/png'},
        ),
      ),
    );
    expect((await valid.downloadImage('https://example.com/a.png')).bytes, [
      1,
      2,
      3,
    ]);
    final invalid = HttpCitizenshipTestClient(
      client: MockClient(
        (_) async =>
            http.Response('html', 200, headers: {'content-type': 'text/html'}),
      ),
    );
    expect(
      () => invalid.downloadImage('https://example.com/a.png'),
      throwsA(isA<CitizenshipTestHttpException>()),
    );
  });
}
