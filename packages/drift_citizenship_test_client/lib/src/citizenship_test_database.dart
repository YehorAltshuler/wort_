import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'citizenship_test_database.g.dart';

class CitizenshipDatasets extends Table {
  TextColumn get id => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get sourceHash => text()();
  IntColumn get questionCount => integer()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CitizenshipQuestions extends Table {
  TextColumn get datasetId => text()();
  TextColumn get id => text()();
  TextColumn get num => text()();
  TextColumn get question => text()();
  TextColumn get answerA => text()();
  TextColumn get answerB => text()();
  TextColumn get answerC => text()();
  TextColumn get answerD => text()();
  IntColumn get correctAnswer => integer()();
  IntColumn get sortOrder => integer()();
  TextColumn get scope => text()();
  TextColumn get stateCode => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get mediaKey => text().nullable()();
  BoolColumn get imageRequired =>
      boolean().withDefault(const Constant(false))();
  @override
  Set<Column<Object>> get primaryKey => {datasetId, id};
}

class CitizenshipMedia extends Table {
  TextColumn get datasetId => text()();
  TextColumn get mediaKey => text()();
  TextColumn get sourceUrl => text()();
  TextColumn get relativePath => text()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get contentHash => text().nullable()();
  TextColumn get status => text()();
  TextColumn get lastError => text().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {datasetId, mediaKey};
}

class CitizenshipQuestionImages extends Table {
  TextColumn get datasetId => text()();
  TextColumn get questionId => text()();
  TextColumn get mediaKey => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {datasetId, questionId, mediaKey};
}

class CitizenshipSyncMetadata extends Table {
  IntColumn get singleton => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastCheckAttemptAt => dateTime().nullable()();
  DateTimeColumn get lastSuccessfulCheckAt => dateTime().nullable()();
  DateTimeColumn get lastSuccessfulUpdateAt => dateTime().nullable()();
  TextColumn get etag => text().nullable()();
  TextColumn get lastModified => text().nullable()();
  TextColumn get jsonHash => text().nullable()();
  IntColumn get questionCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  IntColumn get consecutiveFailures =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAutomaticAttemptAt => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {singleton};
}

class CitizenshipProgress extends Table {
  TextColumn get questionId => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  IntColumn get incorrect => integer().withDefault(const Constant(0))();
  IntColumn get lastSelectedAnswer => integer().nullable()();
  DateTimeColumn get lastAnsweredAt => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isMastered => boolean().withDefault(const Constant(false))();
  @override
  Set<Column<Object>> get primaryKey => {questionId};
}

class CitizenshipExamSessions extends Table {
  TextColumn get id => text()();
  TextColumn get stateCode => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get questionIdsJson => text()();
  TextColumn get mode => text().withDefault(const Constant('exam'))();
  IntColumn get currentIndex => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().nullable()();
  BoolColumn get passedLifeInGermany => boolean().nullable()();
  BoolColumn get passedCitizenship => boolean().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CitizenshipExamAnswers extends Table {
  TextColumn get sessionId => text()();
  TextColumn get questionId => text()();
  IntColumn get selectedAnswer => integer()();
  BoolColumn get isCorrect => boolean()();
  @override
  Set<Column<Object>> get primaryKey => {sessionId, questionId};
}

@DriftDatabase(
  tables: [
    CitizenshipDatasets,
    CitizenshipQuestions,
    CitizenshipMedia,
    CitizenshipQuestionImages,
    CitizenshipSyncMetadata,
    CitizenshipProgress,
    CitizenshipExamSessions,
    CitizenshipExamAnswers,
  ],
)
class CitizenshipTestDatabase extends _$CitizenshipTestDatabase {
  CitizenshipTestDatabase(super.e);

  CitizenshipTestDatabase.defaults()
    : super(
        driftDatabase(
          name: 'citizenship_test',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;
}
