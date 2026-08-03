import 'dart:io';
import 'dart:typed_data';

import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bundled snapshot can build an exam for every Bundesland', () async {
    final bytes = await File(
      'assets/citizenship_test/questions.json',
    ).readAsBytes();
    final questions = const CitizenshipQuestionParser()
        .parse(
          Uint8List.fromList(bytes),
          datasetBaseUrl: 'https://yehoraltshuler.github.io/bamf-lid-dataset/',
        )
        .map(CitizenshipQuestion.fromRecord)
        .toList();
    const states = [
      'BW',
      'BY',
      'BE',
      'BB',
      'HB',
      'HH',
      'HE',
      'MV',
      'NI',
      'NW',
      'RP',
      'SL',
      'SN',
      'ST',
      'SH',
      'TH',
    ];
    for (final state in states) {
      final general = questions.where(
        (q) => q.stateCode == null && q.isAvailable,
      );
      final local = questions.where(
        (q) => q.stateCode == state && q.isAvailable,
      );
      expect(general.length, greaterThanOrEqualTo(30), reason: state);
      expect(local.length, greaterThanOrEqualTo(3), reason: state);
    }
  });
}
