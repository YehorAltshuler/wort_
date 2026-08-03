import 'package:drift/drift.dart';

part 'lexicon_database.g.dart';

class Lexemes extends Table {
  TextColumn get id => text()();
  TextColumn get lemma => text()();
  TextColumn get partOfSpeech => text().named('part_of_speech').nullable()();
  TextColumn get pronunciation => text().nullable()();
  TextColumn get senses => text().nullable()();
  TextColumn get etymology => text().nullable()();
  TextColumn get localizations => text().nullable()();
  TextColumn get forms => text().nullable()();
  IntColumn get frequencyRank => integer().named('frequency_rank')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LexemeSearch extends Table {
  TextColumn get id => text()();
  TextColumn get lemma => text()();
  TextColumn get partOfSpeech => text().named('part_of_speech').nullable()();
  IntColumn get frequencyRank => integer().named('frequency_rank')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Lexemes, LexemeSearch])
class LexiconDatabase extends _$LexiconDatabase {
  LexiconDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {},
    onUpgrade: (migrator, from, to) async {},
  );
}
