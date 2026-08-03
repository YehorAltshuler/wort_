class LexiconDetailsRecord {
  const LexiconDetailsRecord({
    required this.id,
    required this.lemma,
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
  final String partOfSpeech;
  final int frequencyRank;
  final List<String> pronunciation;
  final Map<String, List<String>> forms;
  final List<Map<String, dynamic>> senses;
  final String? etymology;
  final Map<String, dynamic> localizations;
}
