abstract final class AppRoute {
  static const learning = '/learning';
  static const coursebooks = '/learning/coursebooks';
  static const exercises = '/learning/exercises';
  static const exerciseWordsPattern = '/learning/exercises/:exerciseId';
  static const exerciseWordListPattern =
      '/learning/exercises/:exerciseId/words';
  static const exerciseSetupPattern = '/learning/exercises/:exerciseId/setup';
  static const exerciseTrainingPattern =
      '/learning/exercises/:exerciseId/training';
  static const dictionary = '/dictionary';
  static const collections = '/collections';
  static const settings = '/settings';
  static const lid = '/learning/lid';
  static const lidVocabularyBookId = 'leben-in-deutschland';
  static const citizenshipTest = '/citizenship-test';
  static const citizenshipTrainingSetup = '/citizenship-test/training/setup';
  static const citizenshipTraining = '/citizenship-test/training';
  static const citizenshipExam = '/citizenship-test/exam';
  static const citizenshipResultPattern = '/citizenship-test/result/:sessionId';
  static const wordDetailsPattern = '/dictionary/word/:id';
  static const modulesPattern = '/learning/book/:bookId';
  static const modulePattern = '/learning/book/:bookId/module/:moduleFile';
  static const moduleWordsPattern =
      '/learning/book/:bookId/module/:moduleFile/words';
  static const sessionSetupPattern =
      '/learning/book/:bookId/module/:moduleFile/setup';
  static const sessionPattern =
      '/learning/book/:bookId/module/:moduleFile/session';
  static const collectionPattern = '/collections/:collectionId';
  static const collectionWordsPattern = '/collections/:collectionId/words';
  static const collectionSetupPattern = '/collections/:collectionId/setup';
  static const collectionSessionPattern = '/collections/:collectionId/session';

  static const List<String> paths = [
    learning,
    dictionary,
    collections,
    settings,
  ];

  static String wordDetails(String id) {
    return '/dictionary/word/${Uri.encodeComponent(id)}';
  }

  static String exerciseWords(String exerciseId) =>
      '/learning/exercises/${Uri.encodeComponent(exerciseId)}';

  static String exerciseWordList(String exerciseId, {required String filter}) =>
      '${exerciseWords(exerciseId)}/words?filter=$filter';

  static String exerciseSetup(String exerciseId, {String filter = 'all'}) =>
      '${exerciseWords(exerciseId)}/setup?filter=$filter';

  static String exerciseTraining(
    String exerciseId, {
    required String difficulty,
    String filter = 'all',
  }) =>
      '${exerciseWords(exerciseId)}/training'
      '?difficulty=${Uri.encodeQueryComponent(difficulty)}'
      '&filter=${Uri.encodeQueryComponent(filter)}';

  static String modules(String bookId) =>
      '/learning/book/${Uri.encodeComponent(bookId)}';

  static String module(String bookId, String moduleFile) =>
      '${modules(bookId)}/module/${Uri.encodeComponent(moduleFile)}';

  static String sessionSetup(
    String bookId,
    String moduleFile, {
    String? type,
  }) {
    final path = '${module(bookId, moduleFile)}/setup';
    return type == null ? path : '$path?type=${Uri.encodeQueryComponent(type)}';
  }

  static String moduleWords(
    String bookId,
    String moduleFile, {
    String? type,
  }) {
    final path = '${module(bookId, moduleFile)}/words';
    return type == null ? path : '$path?type=${Uri.encodeQueryComponent(type)}';
  }

  static String session(
    String bookId,
    String moduleFile, {
    required String type,
    required String difficulty,
  }) =>
      '${module(bookId, moduleFile)}/session?type=$type&difficulty=$difficulty';

  static String collection(String id) =>
      '/collections/${Uri.encodeComponent(id)}';

  static String collectionWords(String id, {String? type}) {
    final path = '${collection(id)}/words';
    return type == null ? path : '$path?type=${Uri.encodeQueryComponent(type)}';
  }

  static String collectionSetup(String id, {String? type}) {
    final path = '${collection(id)}/setup';
    return type == null ? path : '$path?type=${Uri.encodeQueryComponent(type)}';
  }

  static String collectionSession(
    String id, {
    required String type,
    required String difficulty,
  }) => '${collection(id)}/session?type=$type&difficulty=$difficulty';

  static String citizenshipResult(String sessionId) =>
      '/citizenship-test/result/${Uri.encodeComponent(sessionId)}';

  static String citizenshipExamMistakes(String sessionId) =>
      '$citizenshipTraining?filter=examMistakes&random=true&sessionId='
      '${Uri.encodeQueryComponent(sessionId)}';

  static String citizenshipSetup() => citizenshipTrainingSetup;
}
