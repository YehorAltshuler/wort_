class LearningProgress {
  const LearningProgress({
    this.testedWordIds = const {},
    this.lastActivityByModule = const {},
  });

  final Set<String> testedWordIds;
  final Map<String, DateTime> lastActivityByModule;

  bool isTested(String wordId) => testedWordIds.contains(wordId);

  int testedCount(Iterable<String> wordIds) {
    return wordIds.where(testedWordIds.contains).length;
  }
}
