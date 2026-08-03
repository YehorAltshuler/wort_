import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';

class CitizenshipQuestion {
  const CitizenshipQuestion._(this.record);

  factory CitizenshipQuestion.fromRecord(QuestionRecord record) =>
      CitizenshipQuestion._(record);

  final QuestionRecord record;
  String get id => record.id;
  String get num => record.num;
  String get text => record.question;
  List<String> get answers => record.answers;
  int get correctAnswer => record.correctAnswer;
  QuestionScope get scope => record.scope;
  String? get stateCode => record.stateCode;
  bool get isAvailable => record.isAvailable;
  bool get hasImage => record.images.isNotEmpty;
  List<QuestionImageRecord> get images => record.images;
}

class CitizenshipCatalog {
  const CitizenshipCatalog({required this.questions, required this.progress});

  final List<CitizenshipQuestion> questions;
  final Map<String, QuestionProgressRecord> progress;

  List<CitizenshipQuestion> eligible(String stateCode) => questions
      .where(
        (question) =>
            question.isAvailable &&
            (question.scope == QuestionScope.general ||
                question.stateCode == stateCode),
      )
      .toList(growable: false);
}

class QuestionImage {
  const QuestionImage(this.bytes, this.mimeType, this.position);
  final Uint8List bytes;
  final String? mimeType;
  final int position;
}
