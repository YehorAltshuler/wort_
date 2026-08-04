import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:drift_citizenship_test_client/drift_citizenship_test_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CitizenshipTestDatabase database;
  late _MemoryMediaStore media;
  late DriftCitizenshipTestClient client;

  setUp(() {
    database = CitizenshipTestDatabase(NativeDatabase.memory());
    media = _MemoryMediaStore();
    client = DriftCitizenshipTestClient(
      mediaStore: media,
      database: database,
    );
  });

  tearDown(() => database.close());

  test('keeps active and previous generations and cleans obsolete', () async {
    await client.activateDataset(_candidate('one', 'q1'));
    await client.activateDataset(_candidate('two', 'q2'));
    await client.activateDataset(_candidate('three', 'q3'));
    expect((await client.loadQuestions()).single.id, 'q3');
    final statuses = await database.select(database.citizenshipDatasets).get();
    expect(statuses.where((row) => row.status == 'active'), hasLength(1));
    expect(statuses.where((row) => row.status == 'previous'), hasLength(1));
    expect(statuses.where((row) => row.status == 'obsolete'), hasLength(1));
    await client.cleanupObsoleteDatasets();
    final remaining = await database.select(database.citizenshipDatasets).get();
    expect(remaining, hasLength(2));
    expect(media.deleted, contains('one'));
  });

  test('progress survives dataset replacement', () async {
    await client.activateDataset(_candidate('one', 'q1'));
    await client.saveProgress(
      const QuestionProgressRecord(questionId: 'q1', attempts: 2, correct: 1),
    );
    await client.activateDataset(_candidate('two', 'q2'));
    expect((await client.loadProgress('q1'))?.attempts, 2);
  });

  test('stores exam sessions and answers', () async {
    final session = ExamSessionRecord(
      id: 's',
      stateCode: 'BE',
      startedAt: DateTime(2026),
      questionIds: const ['q'],
      mode: CitizenshipSessionMode.allQuestions,
      currentIndex: 42,
    );
    await client.saveExamSession(session);
    await client.saveExamAnswer(
      const ExamAnswerRecord(
        sessionId: 's',
        questionId: 'q',
        selectedAnswer: 1,
        isCorrect: false,
      ),
    );
    final sessions = await client.loadExamSessions();
    expect(sessions, hasLength(1));
    expect(sessions.single.mode, CitizenshipSessionMode.allQuestions);
    expect(sessions.single.currentIndex, 42);
    expect(await client.loadExamAnswers('s'), hasLength(1));
  });

  test('reset clears answers but preserves favorites', () async {
    await client.saveProgress(
      QuestionProgressRecord(
        questionId: 'q1',
        attempts: 3,
        correct: 2,
        incorrect: 1,
        lastSelectedAnswer: 2,
        lastAnsweredAt: DateTime(2026),
        isFavorite: true,
        isMastered: true,
      ),
    );

    await client.resetAnswerProgress();

    final progress = await client.loadProgress('q1');
    expect(progress?.attempts, 0);
    expect(progress?.lastSelectedAnswer, isNull);
    expect(progress?.isMastered, isFalse);
    expect(progress?.isFavorite, isTrue);
  });

  test('repairs duplicate synchronization metadata', () async {
    await database
        .into(database.citizenshipSyncMetadata)
        .insert(
          CitizenshipSyncMetadataCompanion.insert(
            singleton: const Value(1),
            lastCheckAttemptAt: Value(DateTime(2026)),
            questionCount: const Value(310),
          ),
        );
    await database
        .into(database.citizenshipSyncMetadata)
        .insert(
          CitizenshipSyncMetadataCompanion.insert(
            singleton: const Value(2),
            lastCheckAttemptAt: Value(DateTime(2026, 2)),
            questionCount: const Value(460),
          ),
        );

    final metadata = await client.loadSyncMetadata();
    expect(metadata.questionCount, 460);

    await client.saveSyncMetadata(metadata);
    final rows = await database.select(database.citizenshipSyncMetadata).get();
    expect(rows, hasLength(1));
    expect(rows.single.singleton, 1);
  });
}

DatasetCandidate _candidate(String id, String questionId) => DatasetCandidate(
  id: id,
  questions: [
    QuestionRecord(
      id: questionId,
      num: '1',
      question: 'Question',
      answers: const ['a', 'b', 'c', 'd'],
      correctAnswer: 0,
      sortOrder: 0,
      scope: QuestionScope.general,
    ),
  ],
  media: const [],
  createdAt: DateTime(2026),
  sourceHash: id,
);

class _MemoryMediaStore implements CitizenshipTestMediaStore {
  final deleted = <String>[];
  @override
  Future<void> deleteDataset(String datasetId) async => deleted.add(datasetId);
  @override
  Future<void> copy({required String from, required String to}) async {}
  @override
  Future<Uint8List?> read(String relativePath) async => null;
  @override
  Future<String> write({
    required String datasetId,
    required String mediaKey,
    required Uint8List bytes,
    required String extension,
  }) async => '$datasetId/$mediaKey';
}
