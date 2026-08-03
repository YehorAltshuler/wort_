class WordCollection {
  const WordCollection({
    required this.id,
    required this.name,
    required this.wordIds,
    required this.isFavorites,
  });

  static const favoritesId = 'favorites';

  final String id;
  final String name;
  final List<String> wordIds;
  final bool isFavorites;

  bool contains(String wordId) => wordIds.contains(wordId);
}
