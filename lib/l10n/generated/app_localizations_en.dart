// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'wort_';

  @override
  String get learningTab => 'Learn';

  @override
  String get dictionaryTab => 'Dictionary';

  @override
  String get collectionsTab => 'My words';

  @override
  String get settingsTab => 'Settings';

  @override
  String get homeTagline => 'Finding a word is not enough — remember it.';

  @override
  String get booksTitle => 'Books and modules';

  @override
  String get booksSubtitle => 'Learn course vocabulary step by step';

  @override
  String get knowledgeCheckTitle => 'Knowledge check';

  @override
  String get exercisesTitle => 'Exercises';

  @override
  String get fixedPrepositionEasyDescription =>
      'Choose the translation and correct case';

  @override
  String get fixedPrepositionHardDescription =>
      'Choose the preposition and correct case';

  @override
  String get fixedPrepositionPrompt =>
      'Insert the fixed preposition and identify the case';

  @override
  String get chooseTranslationAndCase => 'Choose the translation and case';

  @override
  String get preposition => 'Preposition';

  @override
  String get translationTitle => 'Translation';

  @override
  String get grammaticalCase => 'Case';

  @override
  String get knowledgeCheckSubtitle => 'Active recall and focused error review';

  @override
  String get citizenshipTestSubtitle =>
      'Official test preparation and exam practice';

  @override
  String get lidTestChoiceTitle => 'LiD test';

  @override
  String get lidTestChoiceSubtitle =>
      'Questions, statistics, and exam simulation';

  @override
  String get lidVocabularyChoiceTitle => 'LiD vocabulary';

  @override
  String get lidVocabularyChoiceSubtitle =>
      'Learn words from the Life in Germany catalog';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressSubtitle => 'Learned words and recent activity';

  @override
  String get dictionaryTitle => 'Dictionary';

  @override
  String get dictionaryHint => 'Search';

  @override
  String get dictionaryPrompt => 'Start typing a German word';

  @override
  String get dictionaryEmpty => 'Nothing found';

  @override
  String get dictionaryLoadError => 'Unable to load the dictionary';

  @override
  String get collectionsTitle => 'My words';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesSubtitle => 'Words for personal practice';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageTitle => 'Interface language';

  @override
  String get nativeLanguageTitle => 'Native language';

  @override
  String get themeTitle => 'Theme';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get textSizeTitle => 'Text size';

  @override
  String get textSizeStandard => 'Standard';

  @override
  String get textSizeLarge => 'Large';

  @override
  String get textSizeExtraLarge => 'Extra large';

  @override
  String get wordLoadError => 'Unable to load the word';

  @override
  String get wordNotFound => 'Word not found';

  @override
  String get noun => 'Noun';

  @override
  String get verb => 'Verb';

  @override
  String get otherPartOfSpeech => 'Other part of speech';

  @override
  String frequencyRank(int rank) {
    return 'frequency $rank';
  }

  @override
  String get meaningsTitle => 'Meanings';

  @override
  String get formsTitle => 'Forms';

  @override
  String get etymologyTitle => 'Etymology';

  @override
  String get dictionarySources => 'Dictionary sources';

  @override
  String get wiktionaryAttribution =>
      'Wiktionary/Kaikki content is available under the CC BY-SA license.';

  @override
  String get externalLinkError => 'Could not open the external dictionary.';

  @override
  String get coursebooksTitle => 'Coursebooks';

  @override
  String get modulesTitle => 'Modules';

  @override
  String get modulesCount => 'modules';

  @override
  String get generalSettingsSection => 'General';

  @override
  String get learningSettingsSection => 'Learning';

  @override
  String get appearanceSettingsSection => 'Appearance';

  @override
  String get lidSettingsSection => 'Leben in Deutschland';

  @override
  String get contentSettingsSection => 'Learning content';

  @override
  String get contentCatalogTitle => 'Content updates';

  @override
  String get contentCatalogChecking => 'Checking for updates…';

  @override
  String get contentCatalogCheckFailed => 'Could not check for updates';

  @override
  String get contentCatalogBundled => 'Using the bundled version';

  @override
  String contentCatalogVersion(String version) {
    return 'Version: $version';
  }

  @override
  String get contentCatalogUpdated => 'Learning content updated';

  @override
  String get contentCatalogNoChanges => 'Learning content is already current';

  @override
  String get contentCatalogCheckError =>
      'Could not update content. The saved version is still available.';

  @override
  String get lidCatalogTitle => 'LiD question catalog';

  @override
  String get lidCatalogUpToDate => 'Questions are up to date';

  @override
  String get lidCatalogCheckRecommended =>
      'Checking for updates is recommended';

  @override
  String get lidCatalogStatusUnknown =>
      'Update status has not been checked yet';

  @override
  String get lidCatalogInstalledNotChecked =>
      'The local catalog is installed; an online check has not completed yet';

  @override
  String get lidCatalogCheckFailed =>
      'Could not verify whether questions are current';

  @override
  String get lidCatalogChecking => 'Checking for updates…';

  @override
  String lidCatalogQuestions(int count) {
    return 'Questions in catalog: $count';
  }

  @override
  String lidCatalogLastChecked(String value) {
    return 'Last check: $value';
  }

  @override
  String lidCatalogLastUpdated(String value) {
    return 'Last update: $value';
  }

  @override
  String get lidCatalogUsingLocal => 'The saved local version is being used.';

  @override
  String get lidCatalogCheckAction => 'Check';

  @override
  String get lidCatalogNoChanges =>
      'Your question catalog is already up to date.';

  @override
  String get lidCatalogUpdated => 'The question catalog has been updated.';

  @override
  String lidCatalogPartiallyUpdated(int count) {
    return 'The catalog was updated, but $count images could not be downloaded.';
  }

  @override
  String get lidCatalogCheckError =>
      'Could not check for updates. The local version is still available.';

  @override
  String addedToList(String name) {
    return 'Added to “$name”.';
  }

  @override
  String get wordsCount => 'words';

  @override
  String get courseLoadError => 'Unable to load learning materials';

  @override
  String get allWords => 'All words';

  @override
  String get nouns => 'Nouns';

  @override
  String get verbs => 'Verbs';

  @override
  String get otherWords => 'Other';

  @override
  String get viewWords => 'Words';

  @override
  String get configureSession => 'Configure session';

  @override
  String get sessionSetupTitle => 'Session setup';

  @override
  String get sessionSize => 'Number of words';

  @override
  String get startSession => 'Start session';

  @override
  String get showTranslation => 'Show translation';

  @override
  String get nextWord => 'Next word';

  @override
  String get finishSession => 'Finish';

  @override
  String get sessionComplete => 'Session complete';

  @override
  String get backToModule => 'Back to module';

  @override
  String get noWords => 'There are no words in this category yet';

  @override
  String get invalidCourseRoute => 'Learning material not found';

  @override
  String get customLists => 'My lists';

  @override
  String get confirmedByTest => 'confirmed by test';

  @override
  String get newList => 'New list';

  @override
  String get listName => 'List name';

  @override
  String get create => 'Create';

  @override
  String get rename => 'Rename';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get collectionEmpty => 'There are no words in this collection yet';

  @override
  String get collectionsLoadError => 'Unable to load collections';

  @override
  String get addToCollections => 'Add to lists';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get paletteTitle => 'Color palette';

  @override
  String get palettePink => 'Pink';

  @override
  String get paletteAzure => 'Azure';

  @override
  String get paletteLime => 'Lime';

  @override
  String get paletteMonochrome => 'Monochrome';

  @override
  String get nounIndicatorTitle => 'Article indicator';

  @override
  String get nounIndicatorV1 => 'Vertical mark';

  @override
  String get nounIndicatorV2 => 'Color badge';

  @override
  String get learningProgress => 'Learning progress';

  @override
  String get startKnowledgeCheck => 'Start knowledge check';

  @override
  String get configureTraining => 'Configure training';

  @override
  String get startTraining => 'Start training';

  @override
  String get difficultyTitle => 'Difficulty';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyEasyDescription =>
      'Choose the translation of a German word';

  @override
  String get difficultyMediumDescription => 'Choose the article or German word';

  @override
  String get difficultyHardDescription => 'Enter the German variant yourself';

  @override
  String get checkAnswer => 'Check';

  @override
  String get wordDetailsAction => 'Word details';

  @override
  String get continueAction => 'Continue';

  @override
  String get nextQuestion => 'Next question';

  @override
  String get finishAction => 'Finish';

  @override
  String get correctAnswerLabel => 'Correct answer';

  @override
  String get correctAnswer => 'Correct';

  @override
  String get wrongAnswer => 'Incorrect';

  @override
  String get knowledgeCheckComplete => 'Knowledge check complete';

  @override
  String get retryMistakes => 'Retry mistakes';

  @override
  String get retryAction => 'Try again';

  @override
  String get lidLoadError => 'Unable to load LID questions';

  @override
  String get lidTitle => 'Life in Germany';

  @override
  String get lidTrainingTitle => 'Training';

  @override
  String get lidTrainingSetupTitle => 'Configure training';

  @override
  String get lidMode => 'Mode';

  @override
  String get lidSequentialMode => 'All questions in order';

  @override
  String get lidSequentialModeDescription =>
      'General questions and questions for the selected state';

  @override
  String get lidExamSimulation => 'Exam simulation';

  @override
  String get lidExamSimulationDescription => '33 randomly selected questions';

  @override
  String get lidFederalState => 'Federal state';

  @override
  String get lidSelectFederalState => 'Select federal state';

  @override
  String get lidStartExam => 'Start exam';

  @override
  String get lidAnsweredQuestions => 'Answered questions';

  @override
  String get lidCorrectAnswers => 'Correct answers';

  @override
  String get lidAccuracy => 'Accuracy';

  @override
  String get lidFavorites => 'Favorites';

  @override
  String get lidLearningProgress => 'Learning progress';

  @override
  String lidMasteredQuestions(int mastered, int total) {
    return 'Mastered $mastered of $total questions';
  }

  @override
  String get lidNoQuestions => 'No matching questions are available.';

  @override
  String lidQuestionNumber(String number) {
    return 'No. $number';
  }

  @override
  String get lidFavoriteTooltip => 'Favorite';

  @override
  String get lidTrainingComplete => 'Training complete';

  @override
  String lidTrainingSummary(int total, int mistakes) {
    return '$total questions · $mistakes mistakes';
  }

  @override
  String lidImageLabel(int number) {
    return 'Image $number';
  }

  @override
  String get lidImageUnavailable => 'The image is not available offline yet.';

  @override
  String get lidExamTitle => 'Life in Germany · Exam';

  @override
  String get lidSubmitExam => 'Submit exam';

  @override
  String get lidSaveAnswer => 'Save answer';

  @override
  String get lidExamResult => 'Exam result';

  @override
  String get lidTestPassed => 'Life in Germany test passed';

  @override
  String get lidTestFailed => 'Life in Germany test not passed';

  @override
  String get lidCitizenshipPassed => 'Citizenship evidence threshold reached';

  @override
  String get lidCitizenshipFailed =>
      'Citizenship threshold of 17 points not reached';

  @override
  String get lidBackToOverview => 'Back to overview';

  @override
  String get lidViewMistakes => 'Review mistakes';

  @override
  String lidYourAnswer(String answer) {
    return 'Your answer: $answer';
  }

  @override
  String lidCorrectAnswerValue(String answer) {
    return 'Correct: $answer';
  }

  @override
  String get lidStatistics => 'Statistics';

  @override
  String get lidAnswers => 'Answers';

  @override
  String get lidCorrect => 'Correct';

  @override
  String get lidRate => 'Accuracy';

  @override
  String get lidMastered => 'Mastered';

  @override
  String get lidExams => 'Exams';

  @override
  String get lidNoCompletedExams => 'No completed exam yet.';

  @override
  String get lidFavoritesMode => 'Favorites only';

  @override
  String get lidFavoritesModeDescription =>
      'Train with questions added to favorites';

  @override
  String get lidIncorrect => 'Incorrect';

  @override
  String get lidUnanswered => 'Unanswered';

  @override
  String get lidQuestionList => 'Question list';

  @override
  String get lidResetProgress => 'Reset answer statistics';

  @override
  String get lidResetProgressTitle => 'Reset statistics?';

  @override
  String get lidResetProgressMessage =>
      'Correct and incorrect answers will be removed. Favorites will be preserved.';

  @override
  String get lidProgressReset => 'Answer statistics reset';

  @override
  String get lidAddFavoritesFirst => 'Add questions to favorites first';

  @override
  String lidAnsweredProgress(int answered, int total) {
    return 'Answered $answered of $total';
  }

  @override
  String get lidContinueSession => 'Continue session';

  @override
  String get downloadAndroidTitle => 'Download the Android app';

  @override
  String get downloadAndroidSubtitle => 'APK from the latest GitHub release';
}
