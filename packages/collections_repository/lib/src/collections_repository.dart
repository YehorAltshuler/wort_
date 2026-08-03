import 'package:collections_client/collections_client.dart';
import 'package:collections_repository/src/collection.dart';

class CollectionsRepository {
  const CollectionsRepository({required CollectionsClient client})
    : _client = client;

  final CollectionsClient _client;

  Future<List<WordCollection>> getCollections() async {
    final records = await _client.loadCollections();
    return records
        .map(
          (record) => WordCollection(
            id: record.id,
            name: record.name,
            wordIds: record.wordIds,
            isFavorites: record.isFavorites,
          ),
        )
        .toList(growable: false);
  }

  Future<String?> createList(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    await _client.createList(id: id, name: trimmed);
    return id;
  }

  Future<void> renameList(String id, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return Future.value();
    return _client.renameList(id: id, name: trimmed);
  }

  Future<void> deleteList(String id) => _client.deleteList(id);

  Future<void> toggleWord(String collectionId, String wordId) {
    return _client.toggleWord(collectionId: collectionId, wordId: wordId);
  }
}
