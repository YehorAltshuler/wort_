import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:test/test.dart';

void main() {
  const parser = CitizenshipQuestionParser(
    minimumQuestions: 1,
    maximumQuestions: 10,
  );
  const baseUrl = 'https://example.com/dataset/';

  test('parses published schema and ignores unknown fields', () {
    final result = parser.parse(
      _dataset([_question('same', officialNumber: 2)]),
      datasetBaseUrl: baseUrl,
    );
    expect(result, hasLength(1));
    expect(result.single.id, 'same');
    expect(result.single.num, '2');
    expect(result.single.correctAnswer, 0);
    expect(result.single.scope, QuestionScope.general);
  });

  test('allows duplicate official number but rejects duplicate id', () {
    final valid = parser.parse(
      _dataset([
        _question('one', officialNumber: 2),
        _question('two', officialNumber: 2),
      ]),
      datasetBaseUrl: baseUrl,
    );
    expect(valid, hasLength(2));
    expect(
      () => parser.parse(
        _dataset([_question('same'), _question('same')]),
        datasetBaseUrl: baseUrl,
      ),
      throwsA(isA<DatasetValidationException>()),
    );
  });

  test('validates solutions, image metadata and sharp shrink', () {
    expect(
      () => parser.parse(
        _dataset([_question('one', solution: 'x')]),
        datasetBaseUrl: baseUrl,
      ),
      throwsA(isA<DatasetValidationException>()),
    );
    expect(
      () => parser.parse(
        _dataset([
          _question(
            'one',
            images: [
              {
                'path': 'images/a.png',
                'sha256': 'bad',
                'mime_type': 'image/png',
              },
            ],
          ),
        ]),
        datasetBaseUrl: baseUrl,
      ),
      throwsA(isA<DatasetValidationException>()),
    );
    expect(
      () => parser.parse(
        _dataset([_question('one')]),
        datasetBaseUrl: baseUrl,
        previousCount: 2,
      ),
      throwsA(isA<DatasetValidationException>()),
    );
  });
}

Map<String, Object?> _question(
  String id, {
  int officialNumber = 1,
  String solution = 'a',
  List<Map<String, Object?>> images = const [],
}) => {
  'id': id,
  'officialNumber': officialNumber,
  'scope': 'general',
  'stateCode': null,
  'question': '  Eine   Frage? ',
  'answers': {
    'a': 'Antwort A',
    'b': 'Antwort B',
    'c': 'Antwort C',
    'd': 'Antwort D',
  },
  'solution': solution,
  'images': images,
  'sourcePage': 1,
};

Uint8List _dataset(List<Map<String, Object?>> rows) => Uint8List.fromList(
  utf8.encode(
    jsonEncode({
      'schemaVersion': 1,
      'datasetVersion': 'test',
      'questions': rows,
    }),
  ),
);
