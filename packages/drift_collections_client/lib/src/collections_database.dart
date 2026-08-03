import 'package:drift/drift.dart';

part 'collections_database.g.dart';

class Collections extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get isFavorites => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CollectionWords extends Table {
  TextColumn get collectionId => text().references(Collections, #id)();
  TextColumn get wordId => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {collectionId, wordId};
}

@DriftDatabase(tables: [Collections, CollectionWords])
class CollectionsDatabase extends _$CollectionsDatabase {
  CollectionsDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
