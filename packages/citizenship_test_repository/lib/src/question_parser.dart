import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';

class DatasetValidationException implements Exception {
  const DatasetValidationException(this.message);
  final String message;
  @override
  String toString() => message;
}

class CitizenshipQuestionParser {
  const CitizenshipQuestionParser({
    this.minimumQuestions = 350,
    this.maximumQuestions = 600,
    this.maximumJsonBytes = 8 * 1024 * 1024,
  });

  final int minimumQuestions;
  final int maximumQuestions;
  final int maximumJsonBytes;

  List<QuestionRecord> parse(
    Uint8List bytes, {
    required String datasetBaseUrl,
    int previousCount = 0,
  }) {
    if (bytes.length > maximumJsonBytes) {
      throw const DatasetValidationException('Dataset is too large.');
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes));
    } on Object {
      throw const DatasetValidationException('Dataset is not valid JSON.');
    }
    if (decoded is! Map<String, Object?>) {
      throw const DatasetValidationException('Dataset root must be an object.');
    }
    if (decoded['schemaVersion'] != 1) {
      throw const DatasetValidationException('Unsupported dataset schema.');
    }
    final questions = decoded['questions'];
    if (questions is! List<Object?>) {
      throw const DatasetValidationException('Questions must be an array.');
    }
    if (questions.length < minimumQuestions ||
        questions.length > maximumQuestions) {
      throw DatasetValidationException(
        'Unexpected question count: ${questions.length}.',
      );
    }
    if (previousCount > 0 && questions.length < previousCount * 0.8) {
      throw const DatasetValidationException('Dataset shrank unexpectedly.');
    }
    final ids = <String>{};
    return [
      for (var index = 0; index < questions.length; index++)
        _parseQuestion(questions[index], index, ids, datasetBaseUrl),
    ];
  }

  QuestionRecord _parseQuestion(
    Object? value,
    int index,
    Set<String> ids,
    String datasetBaseUrl,
  ) {
    if (value is! Map<String, Object?>) {
      throw DatasetValidationException('Question $index is not an object.');
    }
    String field(String name) {
      final normalized = _normalize(value[name]);
      if (normalized.isEmpty) {
        throw DatasetValidationException('Question $index has empty $name.');
      }
      return normalized;
    }

    final id = field('id');
    if (!ids.add(id)) {
      throw DatasetValidationException('Duplicate question id: $id.');
    }
    final officialNumber = value['officialNumber'];
    if (officialNumber is! int || officialNumber <= 0) {
      throw DatasetValidationException('Question $id has invalid number.');
    }
    final scopeValue = field('scope');
    final scope = switch (scopeValue) {
      'general' => QuestionScope.general,
      'state' => QuestionScope.state,
      _ => throw DatasetValidationException('Question $id has invalid scope.'),
    };
    final stateCode = _normalize(value['stateCode']);
    if (scope == QuestionScope.state &&
        !RegExp(r'^[A-Z]{2}$').hasMatch(stateCode)) {
      throw DatasetValidationException('Question $id has invalid state code.');
    }
    final answersValue = value['answers'];
    if (answersValue is! Map<String, Object?>) {
      throw DatasetValidationException('Question $id has invalid answers.');
    }
    String answer(String key) {
      final result = _normalize(answersValue[key]);
      if (result.isEmpty) {
        throw DatasetValidationException('Question $id has empty answer $key.');
      }
      return result;
    }

    final solution = field('solution').toLowerCase();
    final correct = const {'a': 0, 'b': 1, 'c': 2, 'd': 3}[solution];
    if (correct == null) {
      throw DatasetValidationException('Question $id has invalid solution.');
    }
    final imagesValue = value['images'];
    if (imagesValue is! List<Object?>) {
      throw DatasetValidationException('Question $id has invalid images.');
    }
    final baseUri = Uri.parse(datasetBaseUrl);
    final images = <QuestionImageRecord>[];
    for (var position = 0; position < imagesValue.length; position++) {
      final image = imagesValue[position];
      if (image is! Map<String, Object?>) {
        throw DatasetValidationException('Question $id has invalid image.');
      }
      final path = _normalize(image['path']);
      final hash = _normalize(image['sha256']);
      final mime = _normalize(image['mime_type']);
      if (path.isEmpty || hash.length != 64) {
        throw DatasetValidationException(
          'Question $id has invalid image metadata.',
        );
      }
      if (mime != 'image/png' && mime != 'image/jpeg') {
        throw DatasetValidationException(
          'Question $id has invalid image MIME.',
        );
      }
      final url = baseUri.resolve(path).toString();
      if (Uri.parse(url).scheme != 'https') {
        throw DatasetValidationException('Question $id has unsafe image URL.');
      }
      images.add(
        QuestionImageRecord(
          mediaKey: path.split('/').last,
          sourceUrl: url,
          position: position,
          status: MediaStatus.pending,
          expectedHash: hash,
          mimeType: mime,
        ),
      );
    }
    return QuestionRecord(
      id: id,
      num: scope == QuestionScope.general
          ? officialNumber.toString()
          : '$stateCode-$officialNumber',
      question: field('question'),
      answers: [answer('a'), answer('b'), answer('c'), answer('d')],
      correctAnswer: correct,
      sortOrder: index,
      scope: scope,
      stateCode: scope == QuestionScope.state ? stateCode : null,
      images: images,
    );
  }

  static String _normalize(Object? value) =>
      (value as String? ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
}
