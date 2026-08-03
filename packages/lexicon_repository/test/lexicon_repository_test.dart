import 'package:lexicon_client/lexicon_client.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:test/test.dart';

void main() {
  test('maps raw records to domain lexemes', () async {
    final repository = LexiconRepository(client: _FakeLexiconClient());

    final results = await repository.search('Haus');

    expect(results, hasLength(1));
    expect(results.single.lemma, 'Haus');
    expect(results.single.partOfSpeech, PartOfSpeech.noun);
  });
}

class _FakeLexiconClient implements LexiconClient {
  @override
  Future<LexiconDetailsRecord?> getById(String id) async => null;

  @override
  Future<List<LexiconRecord>> search(String query, {int limit = 20}) async {
    return const [
      LexiconRecord(
        id: 'haus',
        lemma: 'Haus',
        normalized: 'haus',
        partOfSpeech: 'noun',
        frequencyRank: 42,
      ),
    ];
  }
}
