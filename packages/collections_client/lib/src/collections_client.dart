import 'package:collections_client/src/collection_record.dart';

abstract interface class CollectionsClient {
  Future<List<CollectionRecord>> loadCollections();

  Future<void> createList({required String id, required String name});

  Future<void> renameList({required String id, required String name});

  Future<void> deleteList(String id);

  Future<void> toggleWord({
    required String collectionId,
    required String wordId,
  });
}
