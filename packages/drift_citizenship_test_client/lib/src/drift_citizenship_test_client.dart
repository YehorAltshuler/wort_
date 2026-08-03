import 'dart:convert';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:drift/drift.dart';
import 'package:drift_citizenship_test_client/src/citizenship_test_database.dart';

class DriftCitizenshipTestClient implements CitizenshipTestLocalClient {
  DriftCitizenshipTestClient({
    required CitizenshipTestMediaStore mediaStore,
    CitizenshipTestDatabase? database,
  }) : _database = database ?? CitizenshipTestDatabase.defaults(),
       _mediaStore = mediaStore;

  final CitizenshipTestDatabase _database;
  final CitizenshipTestMediaStore _mediaStore;

  @override
  Future<bool> get isEmpty async =>
      (await (_database.select(_database.citizenshipDatasets)
            ..where((row) => row.status.equals(DatasetStatus.active.name)))
          .getSingleOrNull()) ==
      null;

  @override
  Stream<List<QuestionRecord>> watchQuestions() => _database
      .customSelect(
        'SELECT 1',
        readsFrom: {
          _database.citizenshipQuestions,
          _database.citizenshipDatasets,
          _database.citizenshipMedia,
          _database.citizenshipQuestionImages,
        },
      )
      .watch()
      .asyncMap((_) => _loadQuestions());

  @override
  Future<List<QuestionRecord>> loadQuestions() => _loadQuestions();

  static const _questionSql = '''
    SELECT q.*
    FROM citizenship_questions q
    JOIN citizenship_datasets d ON d.id = q.dataset_id
    WHERE d.status = 'active'
    ORDER BY q.sort_order
  ''';

  Future<List<QuestionRecord>> _loadQuestions() async {
    final questionRows = await _database.customSelect(_questionSql).get();
    final imageRows = await _database.customSelect('''
      SELECT qi.question_id, qi.position, m.*
      FROM citizenship_question_images qi
      JOIN citizenship_datasets d ON d.id = qi.dataset_id
      JOIN citizenship_media m
        ON m.dataset_id = qi.dataset_id AND m.media_key = qi.media_key
      WHERE d.status = 'active'
      ORDER BY qi.question_id, qi.position
    ''').get();
    final images = <String, List<QuestionImageRecord>>{};
    for (final row in imageRows) {
      images
          .putIfAbsent(row.read<String>('question_id'), () => [])
          .add(
            QuestionImageRecord(
              mediaKey: row.read<String>('media_key'),
              sourceUrl: row.read<String>('source_url'),
              position: row.read<int>('position'),
              status: MediaStatus.values.byName(row.read<String>('status')),
              expectedHash: row.readNullable<String>('content_hash') ?? '',
              mimeType: row.readNullable<String>('mime_type') ?? '',
            ),
          );
    }
    return questionRows
        .map(
          (row) => _mapQuestion(
            row,
            images[row.read<String>('id')] ?? const [],
          ),
        )
        .toList(growable: false);
  }

  QuestionRecord _mapQuestion(
    QueryRow row,
    List<QuestionImageRecord> images,
  ) => QuestionRecord(
    id: row.read<String>('id'),
    num: row.read<String>('num'),
    question: row.read<String>('question'),
    answers: [
      row.read<String>('answer_a'),
      row.read<String>('answer_b'),
      row.read<String>('answer_c'),
      row.read<String>('answer_d'),
    ],
    correctAnswer: row.read<int>('correct_answer'),
    sortOrder: row.read<int>('sort_order'),
    scope: QuestionScope.values.byName(row.read<String>('scope')),
    stateCode: row.readNullable<String>('state_code'),
    images: images,
  );

  @override
  Future<void> activateDataset(DatasetCandidate candidate) async {
    await _database.transaction(() async {
      await (_database.update(
        _database.citizenshipDatasets,
      )..where((row) => row.status.equals(DatasetStatus.previous.name))).write(
        CitizenshipDatasetsCompanion(
          status: Value(DatasetStatus.obsolete.name),
        ),
      );
      await (_database.update(
        _database.citizenshipDatasets,
      )..where((row) => row.status.equals(DatasetStatus.active.name))).write(
        CitizenshipDatasetsCompanion(
          status: Value(DatasetStatus.previous.name),
        ),
      );
      await _database
          .into(_database.citizenshipDatasets)
          .insert(
            CitizenshipDatasetsCompanion.insert(
              id: candidate.id,
              status: DatasetStatus.staging.name,
              createdAt: candidate.createdAt,
              sourceHash: candidate.sourceHash,
              questionCount: candidate.questions.length,
            ),
          );
      await _database.batch((batch) {
        batch
          ..insertAll(
            _database.citizenshipQuestions,
            candidate.questions
                .map(
                  (question) => CitizenshipQuestionsCompanion.insert(
                    datasetId: candidate.id,
                    id: question.id,
                    num: question.num,
                    question: question.question,
                    answerA: question.answers[0],
                    answerB: question.answers[1],
                    answerC: question.answers[2],
                    answerD: question.answers[3],
                    correctAnswer: question.correctAnswer,
                    sortOrder: question.sortOrder,
                    scope: question.scope.name,
                    stateCode: Value(question.stateCode),
                  ),
                )
                .toList(),
          )
          ..insertAll(
            _database.citizenshipMedia,
            candidate.media.map(_mediaCompanion).toList(),
          )
          ..insertAll(
            _database.citizenshipQuestionImages,
            [
              for (final question in candidate.questions)
                for (final image in question.images)
                  CitizenshipQuestionImagesCompanion.insert(
                    datasetId: candidate.id,
                    questionId: question.id,
                    mediaKey: image.mediaKey,
                    position: image.position,
                  ),
            ],
          );
      });
      await (_database.update(
        _database.citizenshipDatasets,
      )..where((row) => row.id.equals(candidate.id))).write(
        CitizenshipDatasetsCompanion(
          status: Value(DatasetStatus.active.name),
        ),
      );
    });
  }

  CitizenshipMediaCompanion _mediaCompanion(MediaRecord media) =>
      CitizenshipMediaCompanion.insert(
        datasetId: media.datasetId,
        mediaKey: media.mediaKey,
        sourceUrl: media.sourceUrl,
        relativePath: media.relativePath,
        status: media.status.name,
        mimeType: Value(media.mimeType),
        contentHash: Value(media.contentHash),
        lastError: Value(media.lastError),
        retryCount: Value(media.retryCount),
        nextRetryAt: Value(media.nextRetryAt),
      );

  @override
  Future<void> updateMedia(MediaRecord media) => _database
      .into(_database.citizenshipMedia)
      .insertOnConflictUpdate(_mediaCompanion(media));

  @override
  Future<List<MediaRecord>> loadPendingMedia() async =>
      (await (_database.select(_database.citizenshipMedia).join([
                innerJoin(
                  _database.citizenshipDatasets,
                  _database.citizenshipDatasets.id.equalsExp(
                    _database.citizenshipMedia.datasetId,
                  ),
                ),
              ])..where(
                _database.citizenshipDatasets.status.equals(
                      DatasetStatus.active.name,
                    ) &
                    _database.citizenshipMedia.status.isNotValue(
                      MediaStatus.available.name,
                    ),
              ))
              .get())
          .map((row) => _mapMedia(row.readTable(_database.citizenshipMedia)))
          .toList(growable: false);

  @override
  Future<List<MediaRecord>> loadMediaForQuestion(String questionId) async {
    final rows = await _database
        .customSelect(
          '''
      SELECT m.* FROM citizenship_media m
      JOIN citizenship_datasets d ON d.id = m.dataset_id
      JOIN citizenship_question_images qi
        ON qi.dataset_id = m.dataset_id AND qi.media_key = m.media_key
      WHERE d.status = 'active' AND qi.question_id = ?
      ORDER BY qi.position
      ''',
          variables: [Variable<String>(questionId)],
        )
        .get();
    return rows.map(_mapMediaRow).toList(growable: false);
  }

  @override
  Future<MediaRecord?> findReusableMedia(String sourceUrl) async {
    final row =
        await (_database.select(_database.citizenshipMedia)
              ..where(
                (media) =>
                    media.sourceUrl.equals(sourceUrl) &
                    media.status.equals(MediaStatus.available.name),
              )
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _mapMedia(row);
  }

  MediaRecord _mapMedia(CitizenshipMediaData row) => MediaRecord(
    datasetId: row.datasetId,
    mediaKey: row.mediaKey,
    sourceUrl: row.sourceUrl,
    relativePath: row.relativePath,
    status: MediaStatus.values.byName(row.status),
    mimeType: row.mimeType,
    contentHash: row.contentHash,
    lastError: row.lastError,
    retryCount: row.retryCount,
    nextRetryAt: row.nextRetryAt,
  );

  MediaRecord _mapMediaRow(QueryRow row) => MediaRecord(
    datasetId: row.read<String>('dataset_id'),
    mediaKey: row.read<String>('media_key'),
    sourceUrl: row.read<String>('source_url'),
    relativePath: row.read<String>('relative_path'),
    status: MediaStatus.values.byName(row.read<String>('status')),
    mimeType: row.readNullable<String>('mime_type'),
    contentHash: row.readNullable<String>('content_hash'),
    lastError: row.readNullable<String>('last_error'),
    retryCount: row.read<int>('retry_count'),
    nextRetryAt: row.readNullable<DateTime>('next_retry_at'),
  );

  @override
  Future<SyncMetadataRecord> loadSyncMetadata() async {
    final row = await _database
        .select(_database.citizenshipSyncMetadata)
        .getSingleOrNull();
    return row == null
        ? const SyncMetadataRecord()
        : SyncMetadataRecord(
            lastCheckAttemptAt: row.lastCheckAttemptAt,
            lastSuccessfulCheckAt: row.lastSuccessfulCheckAt,
            lastSuccessfulUpdateAt: row.lastSuccessfulUpdateAt,
            etag: row.etag,
            lastModified: row.lastModified,
            jsonHash: row.jsonHash,
            questionCount: row.questionCount,
            lastError: row.lastError,
            consecutiveFailures: row.consecutiveFailures,
            nextAutomaticAttemptAt: row.nextAutomaticAttemptAt,
          );
  }

  @override
  Future<void> saveSyncMetadata(SyncMetadataRecord metadata) => _database
      .into(_database.citizenshipSyncMetadata)
      .insertOnConflictUpdate(
        CitizenshipSyncMetadataCompanion.insert(
          lastCheckAttemptAt: Value(metadata.lastCheckAttemptAt),
          lastSuccessfulCheckAt: Value(metadata.lastSuccessfulCheckAt),
          lastSuccessfulUpdateAt: Value(metadata.lastSuccessfulUpdateAt),
          etag: Value(metadata.etag),
          lastModified: Value(metadata.lastModified),
          jsonHash: Value(metadata.jsonHash),
          questionCount: Value(metadata.questionCount),
          lastError: Value(metadata.lastError),
          consecutiveFailures: Value(metadata.consecutiveFailures),
          nextAutomaticAttemptAt: Value(metadata.nextAutomaticAttemptAt),
        ),
      );

  @override
  Future<void> cleanupObsoleteDatasets() async {
    final rows = await (_database.select(
      _database.citizenshipDatasets,
    )..where((row) => row.status.equals(DatasetStatus.obsolete.name))).get();
    for (final dataset in rows) {
      await _database.transaction(() async {
        await (_database.delete(
          _database.citizenshipQuestionImages,
        )..where((row) => row.datasetId.equals(dataset.id))).go();
        await (_database.delete(
          _database.citizenshipQuestions,
        )..where((row) => row.datasetId.equals(dataset.id))).go();
        await (_database.delete(
          _database.citizenshipMedia,
        )..where((row) => row.datasetId.equals(dataset.id))).go();
        await (_database.delete(_database.citizenshipDatasets)..where(
              (row) =>
                  row.id.equals(dataset.id) &
                  row.status.equals(DatasetStatus.obsolete.name),
            ))
            .go();
      });
      await _mediaStore.deleteDataset(dataset.id);
    }
  }

  @override
  Future<QuestionProgressRecord?> loadProgress(String questionId) async {
    final row = await (_database.select(
      _database.citizenshipProgress,
    )..where((row) => row.questionId.equals(questionId))).getSingleOrNull();
    return row == null ? null : _mapProgress(row);
  }

  @override
  Future<List<QuestionProgressRecord>> loadAllProgress() async =>
      (await _database.select(_database.citizenshipProgress).get())
          .map(_mapProgress)
          .toList(growable: false);

  QuestionProgressRecord _mapProgress(CitizenshipProgressData row) =>
      QuestionProgressRecord(
        questionId: row.questionId,
        attempts: row.attempts,
        correct: row.correct,
        incorrect: row.incorrect,
        lastSelectedAnswer: row.lastSelectedAnswer,
        lastAnsweredAt: row.lastAnsweredAt,
        isFavorite: row.isFavorite,
        isMastered: row.isMastered,
      );

  @override
  Future<void> saveProgress(QuestionProgressRecord progress) => _database
      .into(_database.citizenshipProgress)
      .insertOnConflictUpdate(
        CitizenshipProgressCompanion.insert(
          questionId: progress.questionId,
          attempts: Value(progress.attempts),
          correct: Value(progress.correct),
          incorrect: Value(progress.incorrect),
          lastSelectedAnswer: Value(progress.lastSelectedAnswer),
          lastAnsweredAt: Value(progress.lastAnsweredAt),
          isFavorite: Value(progress.isFavorite),
          isMastered: Value(progress.isMastered),
        ),
      );

  @override
  Future<void> resetAnswerProgress() async {
    await _database.customUpdate(
      'UPDATE citizenship_progress SET attempts = 0, correct = 0, '
      'incorrect = 0, last_selected_answer = NULL, '
      'last_answered_at = NULL, is_mastered = 0',
      updates: {_database.citizenshipProgress},
    );
  }

  @override
  Future<void> saveExamSession(ExamSessionRecord session) => _database
      .into(_database.citizenshipExamSessions)
      .insertOnConflictUpdate(
        CitizenshipExamSessionsCompanion.insert(
          id: session.id,
          stateCode: session.stateCode,
          startedAt: session.startedAt,
          completedAt: Value(session.completedAt),
          questionIdsJson: jsonEncode(session.questionIds),
          mode: Value(session.mode.name),
          currentIndex: Value(session.currentIndex),
          correctCount: Value(session.correctCount),
          passedLifeInGermany: Value(session.passedLifeInGermany),
          passedCitizenship: Value(session.passedCitizenship),
        ),
      );

  @override
  Future<void> saveExamAnswer(ExamAnswerRecord answer) => _database
      .into(_database.citizenshipExamAnswers)
      .insertOnConflictUpdate(
        CitizenshipExamAnswersCompanion.insert(
          sessionId: answer.sessionId,
          questionId: answer.questionId,
          selectedAnswer: answer.selectedAnswer,
          isCorrect: answer.isCorrect,
        ),
      );

  @override
  Future<List<ExamSessionRecord>> loadExamSessions() async =>
      (await (_database.select(
            _database.citizenshipExamSessions,
          )..orderBy([(row) => OrderingTerm.desc(row.startedAt)])).get())
          .map(
            (row) => ExamSessionRecord(
              id: row.id,
              stateCode: row.stateCode,
              startedAt: row.startedAt,
              questionIds: (jsonDecode(row.questionIdsJson) as List<Object?>)
                  .cast<String>(),
              mode: CitizenshipSessionMode.values.byName(row.mode),
              currentIndex: row.currentIndex,
              completedAt: row.completedAt,
              correctCount: row.correctCount,
              passedLifeInGermany: row.passedLifeInGermany,
              passedCitizenship: row.passedCitizenship,
            ),
          )
          .toList(growable: false);

  @override
  Future<List<ExamAnswerRecord>> loadExamAnswers(String sessionId) async =>
      (await (_database.select(
            _database.citizenshipExamAnswers,
          )..where((row) => row.sessionId.equals(sessionId))).get())
          .map(
            (row) => ExamAnswerRecord(
              sessionId: row.sessionId,
              questionId: row.questionId,
              selectedAnswer: row.selectedAnswer,
              isCorrect: row.isCorrect,
            ),
          )
          .toList(growable: false);
}
