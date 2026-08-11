// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'wort_';

  @override
  String get learningTab => 'Lernen';

  @override
  String get dictionaryTab => 'Wörterbuch';

  @override
  String get collectionsTab => 'Meine Wörter';

  @override
  String get settingsTab => 'Einstellungen';

  @override
  String get homeTagline =>
      'Ein Wort zu finden reicht nicht – man muss es sich merken.';

  @override
  String get booksTitle => 'Lehrbücher und Module';

  @override
  String get booksSubtitle =>
      'Lerne den Wortschatz der Lehrbücher Schritt für Schritt';

  @override
  String get knowledgeCheckTitle => 'Wissenstest';

  @override
  String get exercisesTitle => 'Übungen';

  @override
  String get fixedPrepositionEasyDescription =>
      'Wähle die Übersetzung und den richtigen Fall';

  @override
  String get fixedPrepositionHardDescription =>
      'Wähle die Präposition und den richtigen Fall';

  @override
  String get fixedPrepositionPrompt =>
      'Setze die feste Präposition ein und bestimme den Fall';

  @override
  String get chooseTranslationAndCase => 'Wähle Übersetzung und Fall';

  @override
  String get preposition => 'Präposition';

  @override
  String get translationTitle => 'Übersetzung';

  @override
  String get grammaticalCase => 'Fall';

  @override
  String get knowledgeCheckSubtitle =>
      'Aktives Erinnern und gezieltes Wiederholen von Fehlern';

  @override
  String get citizenshipTestSubtitle =>
      'Vorbereitung auf den offiziellen Test und Prüfungstraining';

  @override
  String get lidTestChoiceTitle => 'LiD-Test';

  @override
  String get lidTestChoiceSubtitle =>
      'Fragen, Statistik und Prüfungssimulation';

  @override
  String get lidVocabularyChoiceTitle => 'LiD-Wortschatz';

  @override
  String get lidVocabularyChoiceSubtitle =>
      'Lerne Wörter aus dem Katalog „Leben in Deutschland“';

  @override
  String get progressTitle => 'Fortschritt';

  @override
  String get progressSubtitle => 'Gelernte Wörter und letzte Aktivitäten';

  @override
  String get dictionaryTitle => 'Wörterbuch';

  @override
  String get dictionaryHint => 'Suchen';

  @override
  String get dictionaryPrompt => 'Gib ein deutsches Wort ein';

  @override
  String get dictionaryEmpty => 'Nichts gefunden';

  @override
  String get dictionaryLoadError =>
      'Das Wörterbuch konnte nicht geladen werden';

  @override
  String get collectionsTitle => 'Meine Wörter';

  @override
  String get favoritesTitle => 'Favoriten';

  @override
  String get favoritesSubtitle => 'Wörter für dein persönliches Training';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get languageTitle => 'Sprache der Benutzeroberfläche';

  @override
  String get nativeLanguageTitle => 'Muttersprache';

  @override
  String get themeTitle => 'Design';

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
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get textSizeTitle => 'Textgröße';

  @override
  String get textSizeStandard => 'Standard';

  @override
  String get textSizeLarge => 'Groß';

  @override
  String get textSizeExtraLarge => 'Sehr groß';

  @override
  String get wordLoadError => 'Das Wort konnte nicht geladen werden';

  @override
  String get wordNotFound => 'Wort nicht gefunden';

  @override
  String get noun => 'Substantiv';

  @override
  String get verb => 'Verb';

  @override
  String get otherPartOfSpeech => 'Andere Wortart';

  @override
  String frequencyRank(int rank) {
    return 'Häufigkeit $rank';
  }

  @override
  String get meaningsTitle => 'Bedeutungen';

  @override
  String get formsTitle => 'Formen';

  @override
  String get etymologyTitle => 'Etymologie';

  @override
  String get dictionarySources => 'Wörterbuchquellen';

  @override
  String get wiktionaryAttribution =>
      'Inhalte von Wiktionary/Kaikki sind unter der Lizenz CC BY-SA verfügbar.';

  @override
  String get externalLinkError =>
      'Das externe Wörterbuch konnte nicht geöffnet werden.';

  @override
  String get coursebooksTitle => 'Lehrbücher';

  @override
  String get modulesTitle => 'Module';

  @override
  String get modulesCount => 'Module';

  @override
  String get generalSettingsSection => 'Allgemein';

  @override
  String get learningSettingsSection => 'Lernen';

  @override
  String get appearanceSettingsSection => 'Darstellung';

  @override
  String get lidSettingsSection => 'Leben in Deutschland';

  @override
  String get contentSettingsSection => 'Lerninhalte';

  @override
  String get contentCatalogTitle => 'Inhalte aktualisieren';

  @override
  String get contentCatalogChecking => 'Updates werden gesucht…';

  @override
  String get contentCatalogCheckFailed =>
      'Die Suche nach Updates ist fehlgeschlagen';

  @override
  String get contentCatalogBundled =>
      'Die mitgelieferte Version wird verwendet';

  @override
  String contentCatalogVersion(String version) {
    return 'Version: $version';
  }

  @override
  String get contentCatalogUpdated => 'Die Lerninhalte wurden aktualisiert';

  @override
  String get contentCatalogNoChanges => 'Die Lerninhalte sind bereits aktuell';

  @override
  String get contentCatalogCheckError =>
      'Die Inhalte konnten nicht aktualisiert werden. Die gespeicherte Version bleibt verfügbar.';

  @override
  String get lidCatalogTitle => 'LiD-Fragenkatalog';

  @override
  String get lidCatalogUpToDate => 'Die Fragen sind aktuell';

  @override
  String get lidCatalogCheckRecommended =>
      'Es wird empfohlen, nach Updates zu suchen';

  @override
  String get lidCatalogStatusUnknown =>
      'Der Update-Status wurde noch nicht geprüft';

  @override
  String get lidCatalogInstalledNotChecked =>
      'Der lokale Katalog ist installiert; die Online-Prüfung wurde noch nicht abgeschlossen';

  @override
  String get lidCatalogCheckFailed =>
      'Die Aktualität der Fragen konnte nicht geprüft werden';

  @override
  String get lidCatalogChecking => 'Updates werden gesucht…';

  @override
  String lidCatalogQuestions(int count) {
    return 'Fragen im Katalog: $count';
  }

  @override
  String lidCatalogLastChecked(String value) {
    return 'Letzte Prüfung: $value';
  }

  @override
  String lidCatalogLastUpdated(String value) {
    return 'Letzte Aktualisierung: $value';
  }

  @override
  String get lidCatalogUsingLocal =>
      'Die gespeicherte lokale Version wird verwendet.';

  @override
  String get lidCatalogCheckAction => 'Prüfen';

  @override
  String get lidCatalogNoChanges => 'Der Fragenkatalog ist bereits aktuell.';

  @override
  String get lidCatalogUpdated => 'Der Fragenkatalog wurde aktualisiert.';

  @override
  String lidCatalogPartiallyUpdated(int count) {
    return 'Der Katalog wurde aktualisiert, aber $count Bilder konnten nicht heruntergeladen werden.';
  }

  @override
  String get lidCatalogCheckError =>
      'Die Suche nach Updates ist fehlgeschlagen. Die lokale Version bleibt verfügbar.';

  @override
  String addedToList(String name) {
    return 'Zu „$name“ hinzugefügt.';
  }

  @override
  String get wordsCount => 'Wörter';

  @override
  String get courseLoadError =>
      'Die Lernmaterialien konnten nicht geladen werden';

  @override
  String get allWords => 'Alle Wörter';

  @override
  String get nouns => 'Substantive';

  @override
  String get verbs => 'Verben';

  @override
  String get otherWords => 'Andere';

  @override
  String get viewWords => 'Wörter';

  @override
  String get configureSession => 'Lerneinheit konfigurieren';

  @override
  String get sessionSetupTitle => 'Lerneinheit einrichten';

  @override
  String get sessionSize => 'Anzahl der Wörter';

  @override
  String get startSession => 'Lerneinheit starten';

  @override
  String get showTranslation => 'Übersetzung anzeigen';

  @override
  String get nextWord => 'Nächstes Wort';

  @override
  String get finishSession => 'Beenden';

  @override
  String get sessionComplete => 'Lerneinheit abgeschlossen';

  @override
  String get backToModule => 'Zurück zum Modul';

  @override
  String get noWords => 'In dieser Kategorie gibt es noch keine Wörter';

  @override
  String get invalidCourseRoute => 'Lernmaterial nicht gefunden';

  @override
  String get customLists => 'Meine Listen';

  @override
  String get confirmedByTest => 'durch Test bestätigt';

  @override
  String get newList => 'Neue Liste';

  @override
  String get listName => 'Listenname';

  @override
  String get create => 'Erstellen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get delete => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get collectionEmpty => 'Diese Sammlung enthält noch keine Wörter';

  @override
  String get collectionsLoadError =>
      'Die Sammlungen konnten nicht geladen werden';

  @override
  String get addToCollections => 'Zu Listen hinzufügen';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get paletteTitle => 'Farbpalette';

  @override
  String get palettePink => 'Rosa';

  @override
  String get paletteAzure => 'Azurblau';

  @override
  String get paletteLime => 'Limettengrün';

  @override
  String get paletteMonochrome => 'Monochrom';

  @override
  String get nounIndicatorTitle => 'Artikelanzeige';

  @override
  String get nounIndicatorV1 => 'Vertikale Markierung';

  @override
  String get nounIndicatorV2 => 'Farbiges Abzeichen';

  @override
  String get learningProgress => 'Lernfortschritt';

  @override
  String get startKnowledgeCheck => 'Wissenstest starten';

  @override
  String get configureTraining => 'Training konfigurieren';

  @override
  String get startTraining => 'Training starten';

  @override
  String get difficultyTitle => 'Schwierigkeit';

  @override
  String get difficultyEasy => 'Leicht';

  @override
  String get difficultyMedium => 'Mittel';

  @override
  String get difficultyHard => 'Schwer';

  @override
  String get difficultyEasyDescription =>
      'Wähle die Übersetzung eines deutschen Wortes';

  @override
  String get difficultyMediumDescription =>
      'Wähle den Artikel oder das deutsche Wort';

  @override
  String get difficultyHardDescription =>
      'Gib die deutsche Variante selbst ein';

  @override
  String get checkAnswer => 'Prüfen';

  @override
  String get wordDetailsAction => 'Wortdetails';

  @override
  String get continueAction => 'Weiter';

  @override
  String get nextQuestion => 'Nächste Frage';

  @override
  String get finishAction => 'Beenden';

  @override
  String get correctAnswerLabel => 'Richtige Antwort';

  @override
  String get correctAnswer => 'Richtig';

  @override
  String get wrongAnswer => 'Falsch';

  @override
  String get knowledgeCheckComplete => 'Wissenstest abgeschlossen';

  @override
  String get retryMistakes => 'Fehler wiederholen';

  @override
  String get retryAction => 'Erneut versuchen';

  @override
  String get lidLoadError => 'LID-Fragen konnten nicht geladen werden';

  @override
  String get lidTitle => 'Leben in Deutschland';

  @override
  String get lidTrainingTitle => 'Training';

  @override
  String get lidTrainingSetupTitle => 'Training konfigurieren';

  @override
  String get lidMode => 'Modus';

  @override
  String get lidSequentialMode => 'Alle Fragen der Reihe nach';

  @override
  String get lidSequentialModeDescription =>
      'Allgemeine Fragen und Fragen zum ausgewählten Bundesland';

  @override
  String get lidExamSimulation => 'Prüfungssimulation';

  @override
  String get lidExamSimulationDescription => '33 zufällig ausgewählte Fragen';

  @override
  String get lidFederalState => 'Bundesland';

  @override
  String get lidSelectFederalState => 'Bundesland auswählen';

  @override
  String get lidStartExam => 'Prüfung starten';

  @override
  String get lidAnsweredQuestions => 'Beantwortete Fragen';

  @override
  String get lidCorrectAnswers => 'Richtige Antworten';

  @override
  String get lidAccuracy => 'Genauigkeit';

  @override
  String get lidFavorites => 'Favoriten';

  @override
  String get lidLearningProgress => 'Lernfortschritt';

  @override
  String lidMasteredQuestions(int mastered, int total) {
    return '$mastered von $total Fragen gemeistert';
  }

  @override
  String get lidNoQuestions => 'Keine passenden Fragen verfügbar.';

  @override
  String lidQuestionNumber(String number) {
    return 'Nr. $number';
  }

  @override
  String get lidFavoriteTooltip => 'Favorit';

  @override
  String get lidTrainingComplete => 'Training abgeschlossen';

  @override
  String lidTrainingSummary(int total, int mistakes) {
    return '$total Fragen · $mistakes Fehler';
  }

  @override
  String lidImageLabel(int number) {
    return 'Bild $number';
  }

  @override
  String get lidImageUnavailable =>
      'Das Bild ist offline noch nicht verfügbar.';

  @override
  String get lidExamTitle => 'Leben in Deutschland · Prüfung';

  @override
  String get lidSubmitExam => 'Prüfung abgeben';

  @override
  String get lidSaveAnswer => 'Antwort speichern';

  @override
  String get lidExamResult => 'Prüfungsergebnis';

  @override
  String get lidTestPassed => 'Test „Leben in Deutschland“ bestanden';

  @override
  String get lidTestFailed => 'Test „Leben in Deutschland“ nicht bestanden';

  @override
  String get lidCitizenshipPassed =>
      'Erforderliche Punktzahl für den Einbürgerungsnachweis erreicht';

  @override
  String get lidCitizenshipFailed =>
      'Die Einbürgerungsschwelle von 17 Punkten wurde nicht erreicht';

  @override
  String get lidBackToOverview => 'Zurück zur Übersicht';

  @override
  String get lidViewMistakes => 'Fehler ansehen';

  @override
  String lidYourAnswer(String answer) {
    return 'Deine Antwort: $answer';
  }

  @override
  String lidCorrectAnswerValue(String answer) {
    return 'Richtig: $answer';
  }

  @override
  String get lidStatistics => 'Statistik';

  @override
  String get lidAnswers => 'Antworten';

  @override
  String get lidCorrect => 'Richtig';

  @override
  String get lidRate => 'Genauigkeit';

  @override
  String get lidMastered => 'Gemeistert';

  @override
  String get lidExams => 'Prüfungen';

  @override
  String get lidNoCompletedExams => 'Noch keine Prüfung abgeschlossen.';

  @override
  String get lidFavoritesMode => 'Nur Favoriten';

  @override
  String get lidFavoritesModeDescription =>
      'Trainiere mit als Favoriten markierten Fragen';

  @override
  String get lidIncorrect => 'Falsch';

  @override
  String get lidUnanswered => 'Unbeantwortet';

  @override
  String get lidQuestionList => 'Fragenliste';

  @override
  String get lidQuestionNumberInput => 'Fragennummer';

  @override
  String lidQuestionNumberInvalid(int max) {
    return 'Gib eine Zahl von 1 bis $max ein';
  }

  @override
  String get lidGoToQuestion => 'Zur Frage springen';

  @override
  String get lidResetProgress => 'Antwortstatistik zurücksetzen';

  @override
  String get lidResetProgressTitle => 'Statistik zurücksetzen?';

  @override
  String get lidResetProgressMessage =>
      'Richtige und falsche Antworten werden gelöscht. Favoriten bleiben erhalten.';

  @override
  String get lidProgressReset => 'Antwortstatistik zurückgesetzt';

  @override
  String get lidAddFavoritesFirst =>
      'Füge zuerst Fragen zu den Favoriten hinzu';

  @override
  String lidAnsweredProgress(int answered, int total) {
    return '$answered von $total beantwortet';
  }

  @override
  String get lidContinueSession => 'Lerneinheit fortsetzen';

  @override
  String get downloadAndroidTitle => 'Android-App herunterladen';

  @override
  String get downloadAndroidSubtitle => 'APK aus dem neuesten GitHub-Release';
}
