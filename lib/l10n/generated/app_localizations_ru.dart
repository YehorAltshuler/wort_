// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'wort_';

  @override
  String get learningTab => 'Учёба';

  @override
  String get dictionaryTab => 'Словарь';

  @override
  String get collectionsTab => 'Мои слова';

  @override
  String get settingsTab => 'Настройки';

  @override
  String get homeTagline => 'Найти слово недостаточно — его нужно запомнить.';

  @override
  String get booksTitle => 'Учебники и модули';

  @override
  String get booksSubtitle => 'Последовательное изучение лексики курса';

  @override
  String get knowledgeCheckTitle => 'Проверка знаний';

  @override
  String get exercisesTitle => 'Упражнения';

  @override
  String get fixedPrepositionEasyDescription =>
      'Выберите перевод и правильный падеж';

  @override
  String get fixedPrepositionHardDescription =>
      'Выберите предлог и правильный падеж';

  @override
  String get fixedPrepositionPrompt =>
      'Вставьте фиксированный предлог и определите падеж';

  @override
  String get chooseTranslationAndCase => 'Выберите перевод и падеж';

  @override
  String get preposition => 'Предлог';

  @override
  String get translationTitle => 'Перевод';

  @override
  String get grammaticalCase => 'Падеж';

  @override
  String get knowledgeCheckSubtitle =>
      'Активное вспоминание и повторение ошибок';

  @override
  String get citizenshipTestSubtitle =>
      'Подготовка к официальному тесту и экзаменационная тренировка';

  @override
  String get progressTitle => 'Прогресс';

  @override
  String get progressSubtitle => 'Изученные слова и последняя активность';

  @override
  String get dictionaryTitle => 'Словарь';

  @override
  String get dictionaryHint => 'Поиск';

  @override
  String get dictionaryPrompt => 'Начните вводить немецкое слово';

  @override
  String get dictionaryEmpty => 'Ничего не найдено';

  @override
  String get dictionaryLoadError => 'Не удалось загрузить словарь';

  @override
  String get collectionsTitle => 'Мои слова';

  @override
  String get favoritesTitle => 'Избранное';

  @override
  String get favoritesSubtitle => 'Слова для персональной тренировки';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get languageTitle => 'Язык';

  @override
  String get themeTitle => 'Тема';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get wordLoadError => 'Не удалось загрузить слово';

  @override
  String get wordNotFound => 'Слово не найдено';

  @override
  String get noun => 'Существительное';

  @override
  String get verb => 'Глагол';

  @override
  String get otherPartOfSpeech => 'Другая часть речи';

  @override
  String frequencyRank(int rank) {
    return 'частота $rank';
  }

  @override
  String get meaningsTitle => 'Значения';

  @override
  String get formsTitle => 'Формы';

  @override
  String get etymologyTitle => 'Этимология';

  @override
  String get coursebooksTitle => 'Учебники';

  @override
  String get modulesTitle => 'Модули';

  @override
  String get modulesCount => 'модулей';

  @override
  String get generalSettingsSection => 'Основные';

  @override
  String get learningSettingsSection => 'Обучение';

  @override
  String get appearanceSettingsSection => 'Оформление';

  @override
  String get lidSettingsSection => 'Leben in Deutschland';

  @override
  String get lidCatalogTitle => 'Каталог вопросов LiD';

  @override
  String get lidCatalogUpToDate => 'Вопросы актуальны';

  @override
  String get lidCatalogCheckRecommended => 'Рекомендуется проверить обновления';

  @override
  String get lidCatalogStatusUnknown => 'Актуальность ещё не проверена';

  @override
  String get lidCatalogCheckFailed => 'Не удалось проверить актуальность';

  @override
  String get lidCatalogChecking => 'Проверяем обновления…';

  @override
  String lidCatalogQuestions(int count) {
    return 'Доступно вопросов: $count';
  }

  @override
  String lidCatalogLastChecked(String value) {
    return 'Последняя проверка: $value';
  }

  @override
  String lidCatalogLastUpdated(String value) {
    return 'Последнее обновление: $value';
  }

  @override
  String get lidCatalogUsingLocal =>
      'Используется сохранённая локальная версия.';

  @override
  String get lidCatalogCheckAction => 'Проверить';

  @override
  String get lidCatalogNoChanges => 'У вас уже актуальная версия вопросов.';

  @override
  String get lidCatalogUpdated => 'Каталог вопросов обновлён.';

  @override
  String lidCatalogPartiallyUpdated(int count) {
    return 'Каталог обновлён, но не загружено изображений: $count.';
  }

  @override
  String get lidCatalogCheckError =>
      'Не удалось проверить обновления. Используется локальная версия.';

  @override
  String addedToList(String name) {
    return 'Добавлено в список «$name».';
  }

  @override
  String get wordsCount => 'слов';

  @override
  String get courseLoadError => 'Не удалось загрузить учебные материалы';

  @override
  String get allWords => 'Все слова';

  @override
  String get nouns => 'Существительные';

  @override
  String get verbs => 'Глаголы';

  @override
  String get otherWords => 'Другие';

  @override
  String get viewWords => 'Слова модуля';

  @override
  String get configureSession => 'Настроить занятие';

  @override
  String get sessionSetupTitle => 'Настройка занятия';

  @override
  String get sessionSize => 'Количество слов';

  @override
  String get startSession => 'Начать занятие';

  @override
  String get showTranslation => 'Показать перевод';

  @override
  String get nextWord => 'Следующее слово';

  @override
  String get finishSession => 'Завершить';

  @override
  String get sessionComplete => 'Занятие завершено';

  @override
  String get backToModule => 'Вернуться к модулю';

  @override
  String get noWords => 'В этой категории пока нет слов';

  @override
  String get invalidCourseRoute => 'Учебный материал не найден';

  @override
  String get customLists => 'Мои списки';

  @override
  String get confirmedByTest => 'подтверждено проверкой';

  @override
  String get newList => 'Новый список';

  @override
  String get listName => 'Название списка';

  @override
  String get create => 'Создать';

  @override
  String get rename => 'Переименовать';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String get collectionEmpty => 'В этой коллекции пока нет слов';

  @override
  String get collectionsLoadError => 'Не удалось загрузить коллекции';

  @override
  String get addToCollections => 'Добавить в списки';

  @override
  String get addToFavorites => 'В избранное';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String get paletteTitle => 'Цветовая палитра';

  @override
  String get palettePink => 'Розовая';

  @override
  String get paletteAzure => 'Лазурная';

  @override
  String get paletteLime => 'Лаймовая';

  @override
  String get paletteMonochrome => 'Монохромная';

  @override
  String get nounIndicatorTitle => 'Индикатор артикля';

  @override
  String get nounIndicatorV1 => 'Вертикальная метка';

  @override
  String get nounIndicatorV2 => 'Цветная плашка';

  @override
  String get learningProgress => 'Прогресс обучения';

  @override
  String get startKnowledgeCheck => 'Начать проверку знаний';

  @override
  String get configureTraining => 'Настроить тренировку';

  @override
  String get startTraining => 'Начать тренировку';

  @override
  String get difficultyTitle => 'Сложность';

  @override
  String get difficultyEasy => 'Легко';

  @override
  String get difficultyMedium => 'Средне';

  @override
  String get difficultyHard => 'Сложно';

  @override
  String get difficultyEasyDescription => 'Выберите перевод немецкого слова';

  @override
  String get difficultyMediumDescription =>
      'Выберите артикль или немецкое слово';

  @override
  String get difficultyHardDescription =>
      'Введите немецкий вариант самостоятельно';

  @override
  String get checkAnswer => 'Проверить';

  @override
  String get wordDetailsAction => 'О слове';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get correctAnswerLabel => 'Правильный ответ';

  @override
  String get correctAnswer => 'Правильно';

  @override
  String get wrongAnswer => 'Ошибка';

  @override
  String get knowledgeCheckComplete => 'Проверка завершена';

  @override
  String get retryMistakes => 'Повторить ошибки';

  @override
  String get lidTitle => 'Leben in Deutschland';

  @override
  String get lidTrainingTitle => 'Тренировка';

  @override
  String get lidTrainingSetupTitle => 'Настройка тренировки';

  @override
  String get lidMode => 'Режим';

  @override
  String get lidSequentialMode => 'Все вопросы по порядку';

  @override
  String get lidSequentialModeDescription =>
      'Общие вопросы и вопросы выбранной земли';

  @override
  String get lidExamSimulation => 'Симуляция экзамена';

  @override
  String get lidExamSimulationDescription => 'Экзамен в реалистичных условиях';

  @override
  String get lidFederalState => 'Федеральная земля';

  @override
  String get lidSelectFederalState => 'Выберите федеральную землю';

  @override
  String get lidStartExam => 'Начать экзамен';

  @override
  String get lidAnsweredQuestions => 'Отвеченные вопросы';

  @override
  String get lidCorrectAnswers => 'Правильные ответы';

  @override
  String get lidAccuracy => 'Точность';

  @override
  String get lidFavorites => 'Избранное';

  @override
  String get lidLearningProgress => 'Прогресс обучения';

  @override
  String lidMasteredQuestions(int mastered, int total) {
    return 'Освоено: $mastered из $total';
  }

  @override
  String get lidNoQuestions => 'Подходящие вопросы отсутствуют.';

  @override
  String lidQuestionNumber(String number) {
    return '№ $number';
  }

  @override
  String get lidFavoriteTooltip => 'Избранное';

  @override
  String get lidTrainingComplete => 'Тренировка завершена';

  @override
  String lidTrainingSummary(int total, int mistakes) {
    return 'Вопросов: $total · Ошибок: $mistakes';
  }

  @override
  String lidImageLabel(int number) {
    return 'Изображение $number';
  }

  @override
  String get lidImageUnavailable => 'Изображение пока недоступно офлайн.';

  @override
  String get lidExamTitle => 'Leben in Deutschland · Экзамен';

  @override
  String get lidSubmitExam => 'Завершить экзамен';

  @override
  String get lidSaveAnswer => 'Сохранить ответ';

  @override
  String get lidExamResult => 'Результат экзамена';

  @override
  String get lidTestPassed => 'Тест Leben in Deutschland сдан';

  @override
  String get lidTestFailed => 'Тест Leben in Deutschland не сдан';

  @override
  String get lidCitizenshipPassed =>
      'Достигнут результат для подтверждения гражданства';

  @override
  String get lidCitizenshipFailed =>
      'Не достигнут порог в 17 баллов для гражданства';

  @override
  String get lidBackToOverview => 'К обзору';

  @override
  String get lidViewMistakes => 'Посмотреть ошибки';

  @override
  String lidYourAnswer(String answer) {
    return 'Ваш ответ: $answer';
  }

  @override
  String lidCorrectAnswerValue(String answer) {
    return 'Правильно: $answer';
  }

  @override
  String get lidStatistics => 'Статистика';

  @override
  String get lidAnswers => 'Ответы';

  @override
  String get lidCorrect => 'Правильно';

  @override
  String get lidRate => 'Доля правильных';

  @override
  String get lidMastered => 'Освоено';

  @override
  String get lidExams => 'Экзамены';

  @override
  String get lidNoCompletedExams => 'Завершённых экзаменов пока нет.';

  @override
  String get lidFavoritesMode => 'Только избранные';

  @override
  String get lidFavoritesModeDescription =>
      'Тренировка вопросов, добавленных в избранное';

  @override
  String get lidIncorrect => 'Неправильно';

  @override
  String get lidUnanswered => 'Без ответа';

  @override
  String get lidQuestionList => 'Список вопросов';

  @override
  String get lidResetProgress => 'Сбросить статистику ответов';

  @override
  String get lidResetProgressTitle => 'Сбросить статистику?';

  @override
  String get lidResetProgressMessage =>
      'Правильные и неправильные ответы будут удалены. Избранное сохранится.';

  @override
  String get lidProgressReset => 'Статистика ответов сброшена';

  @override
  String get lidAddFavoritesFirst => 'Сначала добавьте вопросы в избранное';

  @override
  String lidAnsweredProgress(int answered, int total) {
    return 'Отвечено: $answered из $total';
  }

  @override
  String get lidContinueSession => 'Продолжить сессию';

  @override
  String get downloadAndroidTitle => 'Скачать приложение для Android';

  @override
  String get downloadAndroidSubtitle => 'APK из последнего релиза на GitHub';
}
