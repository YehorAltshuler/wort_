import 'dart:io';

import 'package:collections_client/collections_client.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_collections_client/src/collections_database.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DriftCollectionsClient implements CollectionsClient {
  DriftCollectionsClient({CollectionsDatabase? database})
    : _database = database;

  CollectionsDatabase? _database;

  Future<CollectionsDatabase> get _db async {
    final current = _database;
    if (current != null) return current;
    final directory = await getApplicationSupportDirectory();
    final database = CollectionsDatabase(
      NativeDatabase.createInBackground(
        File(path.join(directory.path, 'collections.sqlite')),
      ),
    );
    _database = database;
    return database;
  }

  @override
  Future<List<CollectionRecord>> loadCollections() async {
    final database = await _db;
    await _ensureFavorites(database);
    final collections = await database.select(database.collections).get();
    final words = await (database.select(
      database.collectionWords,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    return [
      for (final collection in collections)
        CollectionRecord(
          id: collection.id,
          name: collection.name,
          isFavorites: collection.isFavorites,
          wordIds: [
            for (final word in words)
              if (word.collectionId == collection.id) word.wordId,
          ],
        ),
    ];
  }

  @override
  Future<void> createList({required String id, required String name}) async {
    final database = await _db;
    await database
        .into(database.collections)
        .insert(
          CollectionsCompanion.insert(id: id, name: name),
        );
  }

  @override
  Future<void> renameList({required String id, required String name}) async {
    final database = await _db;
    await (database.update(database.collections)
          ..where((row) => row.id.equals(id)))
        .write(CollectionsCompanion(name: Value(name)));
  }

  @override
  Future<void> deleteList(String id) async {
    if (id == 'favorites') return;
    final database = await _db;
    await database.transaction(() async {
      await (database.delete(
        database.collectionWords,
      )..where((row) => row.collectionId.equals(id))).go();
      await (database.delete(
        database.collections,
      )..where((row) => row.id.equals(id))).go();
    });
  }

  @override
  Future<void> toggleWord({
    required String collectionId,
    required String wordId,
  }) async {
    final database = await _db;
    await _ensureFavorites(database);
    final existing =
        await (database.select(database.collectionWords)..where(
              (row) =>
                  row.collectionId.equals(collectionId) &
                  row.wordId.equals(wordId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (database.delete(database.collectionWords)..where(
            (row) =>
                row.collectionId.equals(collectionId) &
                row.wordId.equals(wordId),
          ))
          .go();
      return;
    }
    final maximum = database.collectionWords.position.max();
    final query = database.selectOnly(database.collectionWords)
      ..addColumns([maximum])
      ..where(database.collectionWords.collectionId.equals(collectionId));
    final position = (await query.getSingle()).read(maximum) ?? -1;
    await database
        .into(database.collectionWords)
        .insert(
          CollectionWordsCompanion.insert(
            collectionId: collectionId,
            wordId: wordId,
            position: position + 1,
          ),
        );
  }

  Future<void> _ensureFavorites(CollectionsDatabase database) {
    return database
        .into(database.collections)
        .insertOnConflictUpdate(
          CollectionsCompanion.insert(
            id: 'favorites',
            name: 'Favorites',
            isFavorites: const Value(true),
          ),
        );
  }
}
