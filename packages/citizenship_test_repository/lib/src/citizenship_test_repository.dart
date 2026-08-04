import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/src/exam_rules.dart';
import 'package:citizenship_test_repository/src/models.dart';
import 'package:citizenship_test_repository/src/question_parser.dart';
import 'package:citizenship_test_repository/src/sync_result.dart';
import 'package:crypto/crypto.dart';

class CitizenshipTestRepository {
  CitizenshipTestRepository({
    required CitizenshipTestLocalClient localClient,
    required CitizenshipTestRemoteClient remoteClient,
    required CitizenshipTestMediaStore mediaStore,
    CitizenshipQuestionParser parser = const CitizenshipQuestionParser(),
    DateTime Function()? now,
  }) : _local = localClient,
       _remote = remoteClient,
       _mediaStore = mediaStore,
       _parser = parser,
       _now = now ?? DateTime.now;

  static const refreshInterval = Duration(days: 15);
  static const _retryDelays = [
    Duration(hours: 1),
    Duration(hours: 6),
    Duration(hours: 24),
  ];

  final CitizenshipTestLocalClient _local;
  final CitizenshipTestRemoteClient _remote;
  final CitizenshipTestMediaStore _mediaStore;
  final CitizenshipQuestionParser _parser;
  final DateTime Function() _now;
  Future<SyncResult>? _runningSync;

  Stream<List<CitizenshipQuestion>> watchQuestions() => _local
      .watchQuestions()
      .map((rows) => rows.map(CitizenshipQuestion.fromRecord).toList());

  Future<List<CitizenshipQuestion>> loadQuestions() async =>
      (await _local.loadQuestions())
          .map(CitizenshipQuestion.fromRecord)
          .toList(growable: false);

  Future<SyncMetadataRecord> loadSyncMetadata() => _local.loadSyncMetadata();

  Future<List<QuestionImage>> loadImages(String questionId) async {
    final result = <QuestionImage>[];
    final media = await _local.loadMediaForQuestion(questionId);
    for (var position = 0; position < media.length; position++) {
      final item = media[position];
      if (item.status != MediaStatus.available) continue;
      final bytes = await _mediaStore.read(item.relativePath);
      if (bytes != null) {
        result.add(QuestionImage(bytes, item.mimeType, position));
      }
    }
    return result;
  }

  Future<void> bootstrap({
    required Uint8List jsonBytes,
    required String datasetVersion,
    required String expectedHash,
    required Future<Uint8List> Function(String assetPath) loadAsset,
    required Map<String, String> imageAssets,
  }) async {
    if (!await _local.isEmpty) return;
    final questions = _parser.parse(
      jsonBytes,
      datasetBaseUrl: 'https://yehoraltshuler.github.io/bamf-lid-dataset/',
    );
    final hash = sha256.convert(jsonBytes).toString();
    if (hash != expectedHash) {
      throw const DatasetValidationException(
        'Bundled questions checksum mismatch.',
      );
    }
    final datasetId = 'bundled-$datasetVersion';
    final media = <MediaRecord>[];
    final hydrated = <QuestionRecord>[];
    for (final question in questions) {
      final statuses = <String, MediaStatus>{};
      for (final image in question.images) {
        final asset = imageAssets[image.sourceUrl];
        var status = MediaStatus.failed;
        var relativePath = '$datasetId/${image.mediaKey}';
        String? contentHash;
        if (asset != null) {
          final bytes = await loadAsset(asset);
          contentHash = sha256.convert(bytes).toString();
          if (contentHash != image.expectedHash) {
            throw StateError(
              'Bundled image checksum mismatch: ${image.mediaKey}',
            );
          }
          relativePath = await _mediaStore.write(
            datasetId: datasetId,
            mediaKey: image.mediaKey,
            bytes: bytes,
            extension: _extensionForMime(image.mimeType),
          );
          status = MediaStatus.available;
        }
        statuses[image.mediaKey] = status;
        media.add(
          MediaRecord(
            datasetId: datasetId,
            mediaKey: image.mediaKey,
            sourceUrl: image.sourceUrl,
            relativePath: relativePath,
            status: status,
            mimeType: image.mimeType,
            contentHash: contentHash ?? image.expectedHash,
            lastError: status == MediaStatus.failed
                ? 'Bundled image is missing.'
                : null,
          ),
        );
      }
      hydrated.add(_withMedia(question, statuses));
    }
    await _local.activateDataset(
      DatasetCandidate(
        id: datasetId,
        questions: hydrated,
        media: media,
        createdAt: _now(),
        sourceHash: hash,
      ),
    );
    await _local.saveSyncMetadata(
      SyncMetadataRecord(
        lastSuccessfulUpdateAt: _now(),
        jsonHash: hash,
        questionCount: questions.length,
      ),
    );
  }

  Future<SyncResult> synchronize({bool manual = false}) {
    final current = _runningSync;
    if (current != null) return current;
    final future = _synchronize(manual: manual);
    _runningSync = future;
    return future.whenComplete(() => _runningSync = null);
  }

  Future<SyncResult> _synchronize({required bool manual}) async {
    final now = _now();
    var metadata = await _local.loadSyncMetadata();
    if (!manual && !_shouldCheck(metadata, now)) {
      return const SyncResult(SyncOutcome.skipped);
    }
    metadata = _copyMetadata(metadata, lastCheckAttemptAt: now);
    await _local.saveSyncMetadata(metadata);
    try {
      final response = await _remote.fetchDataset(
        etag: metadata.etag,
        lastModified: metadata.lastModified,
      );
      if (response.notModified) {
        await _saveSuccess(
          metadata,
          checkedAt: now,
          etag: response.etag,
          lastModified: response.lastModified,
        );
        await retryMissingImages(manual: manual);
        return const SyncResult(SyncOutcome.notModified);
      }
      final bytes = response.bytes!;
      final sourceHash = sha256.convert(bytes).toString();
      if (sourceHash != response.expectedHash) {
        throw const DatasetValidationException('Questions checksum mismatch.');
      }
      if (metadata.jsonHash == sourceHash) {
        await _saveSuccess(
          metadata,
          checkedAt: now,
          etag: response.etag,
          lastModified: response.lastModified,
        );
        await retryMissingImages(manual: manual);
        return const SyncResult(SyncOutcome.notModified);
      }
      final questions = _parser.parse(
        bytes,
        datasetBaseUrl: response.imagesBaseUrl!,
        previousCount: metadata.questionCount,
      );
      if (questions.length != response.expectedCount) {
        throw const DatasetValidationException('Question count mismatch.');
      }
      final datasetId = 'remote-${response.datasetVersion}';
      final media = <MediaRecord>[];
      final hydrated = <QuestionRecord>[];
      var missing = 0;
      for (final question in questions) {
        final statuses = <String, MediaStatus>{};
        for (final image in question.images) {
          final result = await _prepareMedia(datasetId, image);
          media.add(result);
          statuses[image.mediaKey] = result.status;
          if (result.status != MediaStatus.available) missing++;
        }
        hydrated.add(_withMedia(question, statuses));
      }
      await _local.activateDataset(
        DatasetCandidate(
          id: datasetId,
          questions: hydrated,
          media: media,
          createdAt: now,
          sourceHash: sourceHash,
        ),
      );
      await _local.saveSyncMetadata(
        SyncMetadataRecord(
          lastCheckAttemptAt: now,
          lastSuccessfulCheckAt: now,
          lastSuccessfulUpdateAt: now,
          etag: response.etag,
          lastModified: response.lastModified,
          jsonHash: sourceHash,
          questionCount: questions.length,
        ),
      );
      unawaited(_local.cleanupObsoleteDatasets());
      return SyncResult(
        missing == 0 ? SyncOutcome.updated : SyncOutcome.partiallyUpdated,
        missingImages: missing,
      );
    } on Object catch (error) {
      final failures = metadata.consecutiveFailures + 1;
      final delay = _retryDelays[min(failures - 1, _retryDelays.length - 1)];
      await _local.saveSyncMetadata(
        SyncMetadataRecord(
          lastCheckAttemptAt: now,
          lastSuccessfulCheckAt: metadata.lastSuccessfulCheckAt,
          lastSuccessfulUpdateAt: metadata.lastSuccessfulUpdateAt,
          etag: metadata.etag,
          lastModified: metadata.lastModified,
          jsonHash: metadata.jsonHash,
          questionCount: metadata.questionCount,
          lastError: error.toString(),
          consecutiveFailures: failures,
          nextAutomaticAttemptAt: now.add(delay),
        ),
      );
      rethrow;
    }
  }

  Future<void> retryMissingImages({bool manual = false}) async {
    final now = _now();
    for (final media in await _local.loadPendingMedia()) {
      if (!manual && media.nextRetryAt?.isAfter(now) == true) continue;
      try {
        final download = await _remote.downloadImage(media.sourceUrl);
        if (download.contentHash != media.contentHash ||
            download.mimeType != media.mimeType) {
          throw StateError('Image integrity check failed: ${media.mediaKey}');
        }
        final relativePath = await _mediaStore.write(
          datasetId: media.datasetId,
          mediaKey: media.mediaKey,
          bytes: download.bytes,
          extension: _extensionForMime(download.mimeType),
        );
        await _local.updateMedia(
          MediaRecord(
            datasetId: media.datasetId,
            mediaKey: media.mediaKey,
            sourceUrl: media.sourceUrl,
            relativePath: relativePath,
            status: MediaStatus.available,
            mimeType: download.mimeType,
            contentHash: download.contentHash,
          ),
        );
      } on Object catch (error) {
        final retryCount = media.retryCount + 1;
        final delay =
            _retryDelays[min(retryCount - 1, _retryDelays.length - 1)];
        await _local.updateMedia(
          MediaRecord(
            datasetId: media.datasetId,
            mediaKey: media.mediaKey,
            sourceUrl: media.sourceUrl,
            relativePath: media.relativePath,
            status: MediaStatus.failed,
            mimeType: media.mimeType,
            contentHash: media.contentHash,
            lastError: error.toString(),
            retryCount: retryCount,
            nextRetryAt: now.add(delay),
          ),
        );
      }
    }
  }

  Future<MediaRecord> _prepareMedia(
    String datasetId,
    QuestionImageRecord image,
  ) async {
    final url = image.sourceUrl;
    final key = image.mediaKey;
    final reusable = await _local.findReusableMedia(url);
    if (reusable?.status == MediaStatus.available &&
        reusable?.contentHash == image.expectedHash) {
      final target = '$datasetId/$key';
      await _mediaStore.copy(from: reusable!.relativePath, to: target);
      return MediaRecord(
        datasetId: datasetId,
        mediaKey: key,
        sourceUrl: url,
        relativePath: target,
        status: MediaStatus.available,
        mimeType: reusable.mimeType,
        contentHash: reusable.contentHash,
      );
    }
    try {
      final download = await _remote.downloadImage(url);
      if (download.contentHash != image.expectedHash ||
          download.mimeType != image.mimeType) {
        throw StateError('Image integrity check failed: $key');
      }
      final path = await _mediaStore.write(
        datasetId: datasetId,
        mediaKey: key,
        bytes: download.bytes,
        extension: _extensionForMime(download.mimeType),
      );
      return MediaRecord(
        datasetId: datasetId,
        mediaKey: key,
        sourceUrl: url,
        relativePath: path,
        status: MediaStatus.available,
        mimeType: download.mimeType,
        contentHash: download.contentHash,
      );
    } on Object catch (error) {
      return MediaRecord(
        datasetId: datasetId,
        mediaKey: key,
        sourceUrl: url,
        relativePath: '$datasetId/$key',
        status: MediaStatus.failed,
        mimeType: image.mimeType,
        contentHash: image.expectedHash,
        lastError: error.toString(),
        retryCount: 1,
        nextRetryAt: _now().add(_retryDelays.first),
      );
    }
  }

  Future<QuestionProgressRecord> recordAnswer({
    required CitizenshipQuestion question,
    required int selectedAnswer,
  }) async {
    final old = await _local.loadProgress(question.id);
    final isCorrect = selectedAnswer == question.correctAnswer;
    final progress = QuestionProgressRecord(
      questionId: question.id,
      attempts: (old?.attempts ?? 0) + 1,
      correct: (old?.correct ?? 0) + (isCorrect ? 1 : 0),
      incorrect: (old?.incorrect ?? 0) + (isCorrect ? 0 : 1),
      lastSelectedAnswer: selectedAnswer,
      lastAnsweredAt: _now(),
      isFavorite: old?.isFavorite ?? false,
      isMastered: isCorrect,
    );
    await _local.saveProgress(progress);
    return progress;
  }

  Future<void> toggleFavorite(String questionId) async {
    final old = await _local.loadProgress(questionId);
    await _local.saveProgress(
      QuestionProgressRecord(
        questionId: questionId,
        attempts: old?.attempts ?? 0,
        correct: old?.correct ?? 0,
        incorrect: old?.incorrect ?? 0,
        lastSelectedAnswer: old?.lastSelectedAnswer,
        lastAnsweredAt: old?.lastAnsweredAt,
        isFavorite: !(old?.isFavorite ?? false),
        isMastered: old?.isMastered ?? false,
      ),
    );
  }

  Future<List<QuestionProgressRecord>> loadProgress() =>
      _local.loadAllProgress();

  Future<void> resetAnswerProgress() => _local.resetAnswerProgress();

  List<CitizenshipQuestion> createExamQuestions(
    List<CitizenshipQuestion> questions,
    String stateCode, {
    Random? random,
  }) {
    final rng = random ?? Random.secure();
    final general =
        questions
            .where((q) => q.scope == QuestionScope.general && q.isAvailable)
            .toList()
          ..shuffle(rng);
    final state =
        questions
            .where((q) => q.stateCode == stateCode && q.isAvailable)
            .toList()
          ..shuffle(rng);
    if (general.length < LebenInDeutschlandExamRules.generalQuestionCount ||
        state.length < LebenInDeutschlandExamRules.stateQuestionCount) {
      throw StateError('Not enough available questions for an exam.');
    }
    return [
      ...general.take(LebenInDeutschlandExamRules.generalQuestionCount),
      ...state.take(LebenInDeutschlandExamRules.stateQuestionCount),
    ]..shuffle(rng);
  }

  Future<ExamSessionRecord> startExam(
    List<CitizenshipQuestion> questions,
    String stateCode,
  ) async {
    final now = _now();
    final session = ExamSessionRecord(
      id: 'exam-${now.microsecondsSinceEpoch}',
      stateCode: stateCode,
      startedAt: now,
      questionIds: questions.map((q) => q.id).toList(growable: false),
    );
    await _local.saveExamSession(session);
    return session;
  }

  Future<ExamSessionRecord> startAllQuestions(
    List<CitizenshipQuestion> questions,
    String stateCode,
  ) async {
    final now = _now();
    final session = ExamSessionRecord(
      id: 'all-${now.microsecondsSinceEpoch}',
      stateCode: stateCode,
      startedAt: now,
      questionIds: questions.map((question) => question.id).toList(),
      mode: CitizenshipSessionMode.allQuestions,
    );
    await _local.saveExamSession(session);
    return session;
  }

  Future<ExamSessionRecord?> loadActiveSession(
    CitizenshipSessionMode mode,
  ) async {
    final sessions = await _local.loadExamSessions();
    return sessions
        .where(
          (session) => session.mode == mode && session.completedAt == null,
        )
        .firstOrNull;
  }

  Future<void> discardActiveSessions(CitizenshipSessionMode mode) async {
    final sessions = await _local.loadExamSessions();
    await Future.wait([
      for (final session in sessions)
        if (session.mode == mode && session.completedAt == null)
          _local.deleteExamSession(session.id),
    ]);
  }

  Future<void> saveSessionPosition(ExamSessionRecord session, int index) =>
      _local.saveExamSession(
        ExamSessionRecord(
          id: session.id,
          stateCode: session.stateCode,
          startedAt: session.startedAt,
          questionIds: session.questionIds,
          mode: session.mode,
          currentIndex: index,
          completedAt: session.completedAt,
          correctCount: session.correctCount,
          passedLifeInGermany: session.passedLifeInGermany,
          passedCitizenship: session.passedCitizenship,
        ),
      );

  Future<ExamSessionRecord> completeAllQuestions(
    ExamSessionRecord session,
  ) async {
    final completed = ExamSessionRecord(
      id: session.id,
      stateCode: session.stateCode,
      startedAt: session.startedAt,
      questionIds: session.questionIds,
      mode: session.mode,
      currentIndex: session.questionIds.length,
      completedAt: _now(),
    );
    await _local.saveExamSession(completed);
    return completed;
  }

  Future<void> saveExamAnswer(ExamAnswerRecord answer) =>
      _local.saveExamAnswer(answer);

  Future<ExamSessionRecord> completeExam(ExamSessionRecord session) async {
    final answers = await _local.loadExamAnswers(session.id);
    final correct = answers.where((answer) => answer.isCorrect).length;
    final completed = ExamSessionRecord(
      id: session.id,
      stateCode: session.stateCode,
      startedAt: session.startedAt,
      questionIds: session.questionIds,
      mode: session.mode,
      currentIndex: session.currentIndex,
      completedAt: _now(),
      correctCount: correct,
      passedLifeInGermany:
          correct >= LebenInDeutschlandExamRules.lifeInGermanyPassCount,
      passedCitizenship:
          correct >= LebenInDeutschlandExamRules.citizenshipPassCount,
    );
    await _local.saveExamSession(completed);
    return completed;
  }

  Future<List<ExamSessionRecord>> loadExamSessions() =>
      _local.loadExamSessions();
  Future<List<ExamAnswerRecord>> loadExamAnswers(String sessionId) =>
      _local.loadExamAnswers(sessionId);

  bool _shouldCheck(SyncMetadataRecord metadata, DateTime now) {
    final retryAt = metadata.nextAutomaticAttemptAt;
    if (retryAt != null && retryAt.isAfter(now)) return false;
    final checked = metadata.lastSuccessfulCheckAt;
    return checked == null || now.difference(checked) >= refreshInterval;
  }

  Future<void> _saveSuccess(
    SyncMetadataRecord old, {
    required DateTime checkedAt,
    String? etag,
    String? lastModified,
  }) => _local.saveSyncMetadata(
    SyncMetadataRecord(
      lastCheckAttemptAt: checkedAt,
      lastSuccessfulCheckAt: checkedAt,
      lastSuccessfulUpdateAt: old.lastSuccessfulUpdateAt,
      etag: etag ?? old.etag,
      lastModified: lastModified ?? old.lastModified,
      jsonHash: old.jsonHash,
      questionCount: old.questionCount,
    ),
  );

  static SyncMetadataRecord _copyMetadata(
    SyncMetadataRecord old, {
    DateTime? lastCheckAttemptAt,
  }) => SyncMetadataRecord(
    lastCheckAttemptAt: lastCheckAttemptAt ?? old.lastCheckAttemptAt,
    lastSuccessfulCheckAt: old.lastSuccessfulCheckAt,
    lastSuccessfulUpdateAt: old.lastSuccessfulUpdateAt,
    etag: old.etag,
    lastModified: old.lastModified,
    jsonHash: old.jsonHash,
    questionCount: old.questionCount,
    lastError: old.lastError,
    consecutiveFailures: old.consecutiveFailures,
    nextAutomaticAttemptAt: old.nextAutomaticAttemptAt,
  );

  static QuestionRecord _withMedia(
    QuestionRecord q,
    Map<String, MediaStatus> statuses,
  ) => QuestionRecord(
    id: q.id,
    num: q.num,
    question: q.question,
    answers: q.answers,
    correctAnswer: q.correctAnswer,
    sortOrder: q.sortOrder,
    scope: q.scope,
    stateCode: q.stateCode,
    images: [
      for (final image in q.images)
        QuestionImageRecord(
          mediaKey: image.mediaKey,
          sourceUrl: image.sourceUrl,
          position: image.position,
          status: statuses[image.mediaKey] ?? image.status,
          expectedHash: image.expectedHash,
          mimeType: image.mimeType,
        ),
    ],
  );
  static String _extensionForMime(String mime) =>
      mime == 'image/png' ? '.png' : '.jpg';
}
