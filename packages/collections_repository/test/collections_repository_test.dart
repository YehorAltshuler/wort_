import 'package:collections_client/collections_client.dart';
import 'package:collections_repository/collections_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  test('trims names and maps collection records', () async {
    final client = _MockCollectionsClient();
    final repository = CollectionsRepository(client: client);
    when(client.loadCollections).thenAnswer(
      (_) async => const [
        CollectionRecord(
          id: 'favorites',
          name: 'Favorites',
          wordIds: ['lexicon:haus'],
          isFavorites: true,
        ),
      ],
    );
    when(
      () => client.createList(
        id: any(named: 'id'),
        name: 'Travel',
      ),
    ).thenAnswer((_) async {});

    final collections = await repository.getCollections();
    final createdId = await repository.createList('  Travel  ');

    expect(collections.single.contains('lexicon:haus'), isTrue);
    expect(createdId, isNotEmpty);
    verify(
      () => client.createList(
        id: any(named: 'id'),
        name: 'Travel',
      ),
    ).called(1);
  });
}

class _MockCollectionsClient extends Mock implements CollectionsClient {}
