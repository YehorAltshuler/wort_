class CollectionRecord {
  const CollectionRecord({
    required this.id,
    required this.name,
    required this.wordIds,
    required this.isFavorites,
  });

  final String id;
  final String name;
  final List<String> wordIds;
  final bool isFavorites;
}
