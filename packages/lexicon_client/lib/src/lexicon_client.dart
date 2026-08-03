import 'package:lexicon_client/src/lexicon_details_record.dart';
import 'package:lexicon_client/src/lexicon_record.dart';

abstract interface class LexiconClient {
  Future<List<LexiconRecord>> search(String query, {int limit = 20});

  Future<LexiconDetailsRecord?> getById(String id);
}
