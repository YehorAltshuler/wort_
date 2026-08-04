import 'dart:typed_data';

import 'package:citizenship_test_client/src/models.dart';

abstract interface class CitizenshipTestLocalClient {
  Stream<List<QuestionRecord>> watchQuestions();
  Future<List<QuestionRecord>> loadQuestions();
  Future<bool> get isEmpty;
  Future<void> activateDataset(DatasetCandidate candidate);
  Future<void> updateMedia(MediaRecord media);
  Future<List<MediaRecord>> loadPendingMedia();
  Future<List<MediaRecord>> loadMediaForQuestion(String questionId);
  Future<MediaRecord?> findReusableMedia(String sourceUrl);
  Future<SyncMetadataRecord> loadSyncMetadata();
  Future<void> saveSyncMetadata(SyncMetadataRecord metadata);
  Future<void> cleanupObsoleteDatasets();
  Future<QuestionProgressRecord?> loadProgress(String questionId);
  Future<List<QuestionProgressRecord>> loadAllProgress();
  Future<void> saveProgress(QuestionProgressRecord progress);
  Future<void> resetAnswerProgress();
  Future<void> saveExamSession(ExamSessionRecord session);
  Future<void> saveExamAnswer(ExamAnswerRecord answer);
  Future<List<ExamSessionRecord>> loadExamSessions();
  Future<List<ExamAnswerRecord>> loadExamAnswers(String sessionId);
  Future<void> deleteExamSession(String sessionId);
}

abstract interface class CitizenshipTestRemoteClient {
  Future<RemoteDatasetResponse> fetchDataset({
    String? etag,
    String? lastModified,
  });

  Future<MediaDownload> downloadImage(String url);
}

abstract interface class CitizenshipTestMediaStore {
  Future<String> write({
    required String datasetId,
    required String mediaKey,
    required Uint8List bytes,
    required String extension,
  });

  Future<Uint8List?> read(String relativePath);
  Future<void> copy({required String from, required String to});
  Future<void> deleteDataset(String datasetId);
}
