enum PartOfSpeech { noun, verb, other }

class Lexeme {
  const Lexeme({
    required this.id,
    required this.lemma,
    required this.normalized,
    required this.partOfSpeech,
    required this.frequencyRank,
    this.pronunciation = const [],
    this.forms = const {},
    this.senses = const [],
    this.etymology,
    this.localizations = const {},
  });

  final String id;
  final String lemma;
  final String normalized;
  final PartOfSpeech partOfSpeech;
  final int frequencyRank;
  final List<String> pronunciation;
  final Map<String, List<String>> forms;
  final List<LexicalSense> senses;
  final String? etymology;
  final Map<String, LexemeLocalization> localizations;
}

class LexicalSense {
  const LexicalSense({
    this.definitions = const {},
    this.translations = const {},
    this.examples = const [],
  });

  final Map<String, String> definitions;
  final Map<String, List<String>> translations;
  final List<String> examples;
}

class LexemeLocalization {
  const LexemeLocalization({this.senses = const [], this.etymology});

  final List<LexicalSense> senses;
  final String? etymology;
}
