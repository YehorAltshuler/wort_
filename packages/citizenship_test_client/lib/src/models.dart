import 'dart:typed_data';

enum DatasetStatus { staging, active, previous, obsolete }

enum MediaStatus { pending, available, failed }

enum QuestionScope { general, state }

class QuestionRecord {
  const QuestionRecord({
    required this.id,
    required this.num,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.sortOrder,
    required this.scope,
    this.stateCode,
    this.images = const [],
  });

  final String id;
  final String num;
  final String question;
  final List<String> answers;
  final int correctAnswer;
  final int sortOrder;
  final QuestionScope scope;
  final String? stateCode;
  final List<QuestionImageRecord> images;

  bool get isAvailable =>
      images.isEmpty ||
      images.every((image) => image.status == MediaStatus.available);
}

class QuestionImageRecord {
  const QuestionImageRecord({
    required this.mediaKey,
    required this.sourceUrl,
    required this.position,
    required this.status,
    required this.expectedHash,
    required this.mimeType,
  });

  final String mediaKey;
  final String sourceUrl;
  final int position;
  final MediaStatus status;
  final String expectedHash;
  final String mimeType;
}

class MediaRecord {
  const MediaRecord({
    required this.datasetId,
    required this.mediaKey,
    required this.sourceUrl,
    required this.relativePath,
    required this.status,
    this.mimeType,
    this.contentHash,
    this.lastError,
    this.retryCount = 0,
    this.nextRetryAt,
  });

  final String datasetId;
  final String mediaKey;
  final String sourceUrl;
  final String relativePath;
  final MediaStatus status;
  final String? mimeType;
  final String? contentHash;
  final String? lastError;
  final int retryCount;
  final DateTime? nextRetryAt;
}

class MediaDownload {
  const MediaDownload({
    required this.bytes,
    required this.mimeType,
    required this.contentHash,
  });

  final Uint8List bytes;
  final String mimeType;
  final String contentHash;
}

class DatasetCandidate {
  const DatasetCandidate({
    required this.id,
    required this.questions,
    required this.media,
    required this.createdAt,
    required this.sourceHash,
  });

  final String id;
  final List<QuestionRecord> questions;
  final List<MediaRecord> media;
  final DateTime createdAt;
  final String sourceHash;
}

class SyncMetadataRecord {
  const SyncMetadataRecord({
    this.lastCheckAttemptAt,
    this.lastSuccessfulCheckAt,
    this.lastSuccessfulUpdateAt,
    this.etag,
    this.lastModified,
    this.jsonHash,
    this.questionCount = 0,
    this.lastError,
    this.consecutiveFailures = 0,
    this.nextAutomaticAttemptAt,
  });

  final DateTime? lastCheckAttemptAt;
  final DateTime? lastSuccessfulCheckAt;
  final DateTime? lastSuccessfulUpdateAt;
  final String? etag;
  final String? lastModified;
  final String? jsonHash;
  final int questionCount;
  final String? lastError;
  final int consecutiveFailures;
  final DateTime? nextAutomaticAttemptAt;
}

class RemoteDatasetResponse {
  const RemoteDatasetResponse.notModified({this.etag, this.lastModified})
    : bytes = null,
      datasetVersion = null,
      imagesBaseUrl = null,
      expectedHash = null,
      expectedCount = null,
      notModified = true;

  const RemoteDatasetResponse.updated({
    required this.bytes,
    required this.datasetVersion,
    required this.imagesBaseUrl,
    required this.expectedHash,
    required this.expectedCount,
    this.etag,
    this.lastModified,
  }) : notModified = false;

  final Uint8List? bytes;
  final bool notModified;
  final String? datasetVersion;
  final String? imagesBaseUrl;
  final String? expectedHash;
  final int? expectedCount;
  final String? etag;
  final String? lastModified;
}

class QuestionProgressRecord {
  const QuestionProgressRecord({
    required this.questionId,
    this.attempts = 0,
    this.correct = 0,
    this.incorrect = 0,
    this.lastSelectedAnswer,
    this.lastAnsweredAt,
    this.isFavorite = false,
    this.isMastered = false,
  });

  final String questionId;
  final int attempts;
  final int correct;
  final int incorrect;
  final int? lastSelectedAnswer;
  final DateTime? lastAnsweredAt;
  final bool isFavorite;
  final bool isMastered;
}

enum CitizenshipSessionMode { exam, allQuestions }

class ExamSessionRecord {
  const ExamSessionRecord({
    required this.id,
    required this.stateCode,
    required this.startedAt,
    required this.questionIds,
    this.mode = CitizenshipSessionMode.exam,
    this.currentIndex = 0,
    this.completedAt,
    this.correctCount,
    this.passedLifeInGermany,
    this.passedCitizenship,
  });

  final String id;
  final String stateCode;
  final DateTime startedAt;
  final List<String> questionIds;
  final CitizenshipSessionMode mode;
  final int currentIndex;
  final DateTime? completedAt;
  final int? correctCount;
  final bool? passedLifeInGermany;
  final bool? passedCitizenship;
}

class ExamAnswerRecord {
  const ExamAnswerRecord({
    required this.sessionId,
    required this.questionId,
    required this.selectedAnswer,
    required this.isCorrect,
  });

  final String sessionId;
  final String questionId;
  final int selectedAnswer;
  final bool isCorrect;
}
