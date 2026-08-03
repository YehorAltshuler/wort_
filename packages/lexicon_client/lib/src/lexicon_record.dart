class LexiconRecord {
  const LexiconRecord({
    required this.id,
    required this.lemma,
    required this.normalized,
    required this.partOfSpeech,
    required this.frequencyRank,
  });

  final String id;
  final String lemma;
  final String normalized;
  final String partOfSpeech;
  final int frequencyRank;
}
