import 'package:drift/native.dart';
import 'package:drift_collections_client/drift_collections_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'creates lists and toggles ordered memberships transactionally',
    () async {
      final database = CollectionsDatabase(NativeDatabase.memory());
      final client = DriftCollectionsClient(database: database);
      addTearDown(database.close);

      await client.createList(id: '123', name: 'Travel');
      await client.toggleWord(
        collectionId: 'favorites',
        wordId: 'lexicon:haus',
      );
      await client.toggleWord(
        collectionId: '123',
        wordId: 'book:module1.json:0',
      );
      await client.toggleWord(collectionId: '123', wordId: 'lexicon:haus');

      var collections = await client.loadCollections();
      expect(collections.firstWhere((item) => item.isFavorites).wordIds, [
        'lexicon:haus',
      ]);
      expect(collections.firstWhere((item) => item.id == '123').wordIds, [
        'book:module1.json:0',
        'lexicon:haus',
      ]);

      await client.toggleWord(
        collectionId: '123',
        wordId: 'book:module1.json:0',
      );
      await client.deleteList('123');
      collections = await client.loadCollections();
      expect(collections.any((item) => item.id == '123'), isFalse);
    },
  );
}
