import 'package:lexicon_client/lexicon_client.dart';
import 'package:lexicon_repository/src/lexeme.dart';

class LexiconRepository {
  const LexiconRepository({required LexiconClient client}) : _client = client;

  final LexiconClient _client;

  Future<List<Lexeme>> search(String query, {int limit = 20}) async {
    final records = await _client.search(query, limit: limit);
    return records
        .map(
          (record) => Lexeme(
            id: record.id,
            lemma: record.lemma,
            normalized: record.normalized,
            partOfSpeech: switch (record.partOfSpeech) {
              'noun' => PartOfSpeech.noun,
              'verb' => PartOfSpeech.verb,
              _ => PartOfSpeech.other,
            },
            frequencyRank: record.frequencyRank,
          ),
        )
        .toList(growable: false);
  }

  Future<Lexeme?> getById(String id) async {
    final record = await _client.getById(id);
    if (record == null) return null;
    return Lexeme(
      id: record.id,
      lemma: record.lemma,
      normalized: record.id,
      partOfSpeech: _partOfSpeech(record.partOfSpeech),
      frequencyRank: record.frequencyRank,
      pronunciation: record.pronunciation,
      forms: record.forms,
      senses: record.senses.map(_senseFromJson).toList(growable: false),
      etymology: record.etymology,
      localizations: record.localizations.map(
        (language, value) => MapEntry(
          language,
          _localizationFromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  static PartOfSpeech _partOfSpeech(String value) => switch (value) {
    'noun' => PartOfSpeech.noun,
    'verb' => PartOfSpeech.verb,
    _ => PartOfSpeech.other,
  };

  static LexicalSense _senseFromJson(Map<String, dynamic> value) {
    final rawDefinitions = value['definitions'] as Map<String, dynamic>?;
    final rawTranslations = value['translations'] as Map<String, dynamic>?;
    return LexicalSense(
      definitions: rawDefinitions?.cast<String, String>() ?? const {},
      translations:
          rawTranslations?.map(
            (language, translations) => MapEntry(
              language,
              (translations as List<dynamic>).cast<String>(),
            ),
          ) ??
          const {},
      examples: (value['examples'] as List<dynamic>? ?? const [])
          .cast<String>(),
    );
  }

  static LexemeLocalization _localizationFromJson(
    Map<String, dynamic> value,
  ) {
    return LexemeLocalization(
      senses: (value['senses'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(_senseFromJson)
          .toList(growable: false),
      etymology: value['etymology'] as String?,
    );
  }
}
