import 'dart:math';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:test/test.dart';

void main() {
  test('official exam configuration is centralized', () {
    expect(LebenInDeutschlandExamRules.totalQuestionCount, 33);
    expect(LebenInDeutschlandExamRules.totalCatalogQuestionCount, 310);
    expect(LebenInDeutschlandExamRules.generalQuestionCount, 30);
    expect(LebenInDeutschlandExamRules.stateQuestionCount, 3);
    expect(LebenInDeutschlandExamRules.duration, const Duration(minutes: 60));
    expect(LebenInDeutschlandExamRules.lifeInGermanyPassCount, 15);
    expect(LebenInDeutschlandExamRules.citizenshipPassCount, 17);
  });

  test('exam contains 30 general and 3 selected-state questions', () {
    final repository = CitizenshipTestRepository(
      localClient: _UnusedLocal(),
      remoteClient: _UnusedRemote(),
      mediaStore: _UnusedMedia(),
    );
    final questions = [
      for (var i = 0; i < 40; i++) _question('g$i'),
      for (var i = 0; i < 10; i++) _question('be$i', state: 'BE'),
      for (var i = 0; i < 10; i++) _question('by$i', state: 'BY'),
    ];
    final exam = repository.createExamQuestions(
      questions,
      'BE',
      random: Random(1),
    );
    expect(exam, hasLength(33));
    expect(exam.where((q) => q.scope == QuestionScope.general), hasLength(30));
    expect(exam.where((q) => q.stateCode == 'BE'), hasLength(3));
    expect(exam.where((q) => q.stateCode == 'BY'), isEmpty);
  });
}

CitizenshipQuestion _question(String id, {String? state}) =>
    CitizenshipQuestion.fromRecord(
      QuestionRecord(
        id: id,
        num: state == null ? '1' : '$state-1',
        question: 'Question',
        answers: const ['a', 'b', 'c', 'd'],
        correctAnswer: 0,
        sortOrder: 0,
        scope: state == null ? QuestionScope.general : QuestionScope.state,
        stateCode: state,
      ),
    );

class _UnusedLocal implements CitizenshipTestLocalClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedRemote implements CitizenshipTestRemoteClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedMedia implements CitizenshipTestMediaStore {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
