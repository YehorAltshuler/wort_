class LearningProgress {
  const LearningProgress({
    this.testedWordIds = const {},
    this.incorrectWordIds = const {},
    this.lastActivityByModule = const {},
  });

  final Set<String> testedWordIds;
  final Set<String> incorrectWordIds;
  final Map<String, DateTime> lastActivityByModule;

  bool isTested(String wordId) => testedWordIds.contains(wordId);

  bool isIncorrect(String wordId) => incorrectWordIds.contains(wordId);

  int testedCount(Iterable<String> wordIds) {
    return wordIds.where(testedWordIds.contains).length;
  }

  int incorrectCount(Iterable<String> wordIds) {
    return wordIds.where(incorrectWordIds.contains).length;
  }
}
