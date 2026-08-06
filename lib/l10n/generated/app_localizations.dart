import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'wort_'**
  String get appTitle;

  /// No description provided for @learningTab.
  ///
  /// In ru, this message translates to:
  /// **'Учёба'**
  String get learningTab;

  /// No description provided for @dictionaryTab.
  ///
  /// In ru, this message translates to:
  /// **'Словарь'**
  String get dictionaryTab;

  /// No description provided for @collectionsTab.
  ///
  /// In ru, this message translates to:
  /// **'Мои слова'**
  String get collectionsTab;

  /// No description provided for @settingsTab.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTab;

  /// No description provided for @homeTagline.
  ///
  /// In ru, this message translates to:
  /// **'Найти слово недостаточно — его нужно запомнить.'**
  String get homeTagline;

  /// No description provided for @booksTitle.
  ///
  /// In ru, this message translates to:
  /// **'Учебники и модули'**
  String get booksTitle;

  /// No description provided for @booksSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Последовательное изучение лексики курса'**
  String get booksSubtitle;

  /// No description provided for @knowledgeCheckTitle.
  ///
  /// In ru, this message translates to:
  /// **'Проверка знаний'**
  String get knowledgeCheckTitle;

  /// No description provided for @exercisesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Упражнения'**
  String get exercisesTitle;

  /// No description provided for @fixedPrepositionEasyDescription.
  ///
  /// In ru, this message translates to:
  /// **'Выберите перевод и правильный падеж'**
  String get fixedPrepositionEasyDescription;

  /// No description provided for @fixedPrepositionHardDescription.
  ///
  /// In ru, this message translates to:
  /// **'Выберите предлог и правильный падеж'**
  String get fixedPrepositionHardDescription;

  /// No description provided for @fixedPrepositionPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Вставьте фиксированный предлог и определите падеж'**
  String get fixedPrepositionPrompt;

  /// No description provided for @chooseTranslationAndCase.
  ///
  /// In ru, this message translates to:
  /// **'Выберите перевод и падеж'**
  String get chooseTranslationAndCase;

  /// No description provided for @preposition.
  ///
  /// In ru, this message translates to:
  /// **'Предлог'**
  String get preposition;

  /// No description provided for @translationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Перевод'**
  String get translationTitle;

  /// No description provided for @grammaticalCase.
  ///
  /// In ru, this message translates to:
  /// **'Падеж'**
  String get grammaticalCase;

  /// No description provided for @knowledgeCheckSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Активное вспоминание и повторение ошибок'**
  String get knowledgeCheckSubtitle;

  /// No description provided for @citizenshipTestSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Подготовка к официальному тесту и экзаменационная тренировка'**
  String get citizenshipTestSubtitle;

  /// No description provided for @lidTestChoiceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тест LiD'**
  String get lidTestChoiceTitle;

  /// No description provided for @lidTestChoiceSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Вопросы, статистика и симуляция экзамена'**
  String get lidTestChoiceSubtitle;

  /// No description provided for @lidVocabularyChoiceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Лексика LiD'**
  String get lidVocabularyChoiceTitle;

  /// No description provided for @lidVocabularyChoiceSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Изучение слов из каталога Leben in Deutschland'**
  String get lidVocabularyChoiceSubtitle;

  /// No description provided for @progressTitle.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get progressTitle;

  /// No description provided for @progressSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Изученные слова и последняя активность'**
  String get progressSubtitle;

  /// No description provided for @dictionaryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Словарь'**
  String get dictionaryTitle;

  /// No description provided for @dictionaryHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get dictionaryHint;

  /// No description provided for @dictionaryPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Начните вводить немецкое слово'**
  String get dictionaryPrompt;

  /// No description provided for @dictionaryEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get dictionaryEmpty;

  /// No description provided for @dictionaryLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить словарь'**
  String get dictionaryLoadError;

  /// No description provided for @collectionsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои слова'**
  String get collectionsTitle;

  /// No description provided for @favoritesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get favoritesTitle;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Слова для персональной тренировки'**
  String get favoritesSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @languageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык интерфейса'**
  String get languageTitle;

  /// No description provided for @nativeLanguageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Родной язык'**
  String get nativeLanguageTitle;

  /// No description provided for @themeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get themeTitle;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In ru, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageArabic.
  ///
  /// In ru, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @textSizeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Размер текста'**
  String get textSizeTitle;

  /// No description provided for @textSizeStandard.
  ///
  /// In ru, this message translates to:
  /// **'Стандартный'**
  String get textSizeStandard;

  /// No description provided for @textSizeLarge.
  ///
  /// In ru, this message translates to:
  /// **'Крупный'**
  String get textSizeLarge;

  /// No description provided for @textSizeExtraLarge.
  ///
  /// In ru, this message translates to:
  /// **'Очень крупный'**
  String get textSizeExtraLarge;

  /// No description provided for @wordLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить слово'**
  String get wordLoadError;

  /// No description provided for @wordNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Слово не найдено'**
  String get wordNotFound;

  /// No description provided for @noun.
  ///
  /// In ru, this message translates to:
  /// **'Существительное'**
  String get noun;

  /// No description provided for @verb.
  ///
  /// In ru, this message translates to:
  /// **'Глагол'**
  String get verb;

  /// No description provided for @otherPartOfSpeech.
  ///
  /// In ru, this message translates to:
  /// **'Другая часть речи'**
  String get otherPartOfSpeech;

  /// No description provided for @frequencyRank.
  ///
  /// In ru, this message translates to:
  /// **'частота {rank}'**
  String frequencyRank(int rank);

  /// No description provided for @meaningsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Значения'**
  String get meaningsTitle;

  /// No description provided for @formsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Формы'**
  String get formsTitle;

  /// No description provided for @etymologyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Этимология'**
  String get etymologyTitle;

  /// No description provided for @dictionarySources.
  ///
  /// In ru, this message translates to:
  /// **'Словарные источники'**
  String get dictionarySources;

  /// No description provided for @wiktionaryAttribution.
  ///
  /// In ru, this message translates to:
  /// **'Материалы Wiktionary/Kaikki доступны по лицензии CC BY-SA.'**
  String get wiktionaryAttribution;

  /// No description provided for @externalLinkError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть внешний словарь.'**
  String get externalLinkError;

  /// No description provided for @coursebooksTitle.
  ///
  /// In ru, this message translates to:
  /// **'Учебники'**
  String get coursebooksTitle;

  /// No description provided for @modulesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Модули'**
  String get modulesTitle;

  /// No description provided for @modulesCount.
  ///
  /// In ru, this message translates to:
  /// **'модулей'**
  String get modulesCount;

  /// No description provided for @generalSettingsSection.
  ///
  /// In ru, this message translates to:
  /// **'Основные'**
  String get generalSettingsSection;

  /// No description provided for @learningSettingsSection.
  ///
  /// In ru, this message translates to:
  /// **'Обучение'**
  String get learningSettingsSection;

  /// No description provided for @appearanceSettingsSection.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get appearanceSettingsSection;

  /// No description provided for @lidSettingsSection.
  ///
  /// In ru, this message translates to:
  /// **'Leben in Deutschland'**
  String get lidSettingsSection;

  /// No description provided for @contentSettingsSection.
  ///
  /// In ru, this message translates to:
  /// **'Учебные материалы'**
  String get contentSettingsSection;

  /// No description provided for @contentCatalogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновление содержания'**
  String get contentCatalogTitle;

  /// No description provided for @contentCatalogChecking.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем обновления…'**
  String get contentCatalogChecking;

  /// No description provided for @contentCatalogCheckFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось проверить обновления'**
  String get contentCatalogCheckFailed;

  /// No description provided for @contentCatalogBundled.
  ///
  /// In ru, this message translates to:
  /// **'Используется встроенная версия'**
  String get contentCatalogBundled;

  /// No description provided for @contentCatalogVersion.
  ///
  /// In ru, this message translates to:
  /// **'Версия: {version}'**
  String contentCatalogVersion(String version);

  /// No description provided for @contentCatalogUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Учебные материалы обновлены'**
  String get contentCatalogUpdated;

  /// No description provided for @contentCatalogNoChanges.
  ///
  /// In ru, this message translates to:
  /// **'Учебные материалы уже актуальны'**
  String get contentCatalogNoChanges;

  /// No description provided for @contentCatalogCheckError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить материалы. Используется сохранённая версия.'**
  String get contentCatalogCheckError;

  /// No description provided for @lidCatalogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Каталог вопросов LiD'**
  String get lidCatalogTitle;

  /// No description provided for @lidCatalogUpToDate.
  ///
  /// In ru, this message translates to:
  /// **'Вопросы актуальны'**
  String get lidCatalogUpToDate;

  /// No description provided for @lidCatalogCheckRecommended.
  ///
  /// In ru, this message translates to:
  /// **'Рекомендуется проверить обновления'**
  String get lidCatalogCheckRecommended;

  /// No description provided for @lidCatalogStatusUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Актуальность ещё не проверена'**
  String get lidCatalogStatusUnknown;

  /// No description provided for @lidCatalogInstalledNotChecked.
  ///
  /// In ru, this message translates to:
  /// **'Локальный каталог установлен, онлайн-проверка ещё не завершена'**
  String get lidCatalogInstalledNotChecked;

  /// No description provided for @lidCatalogCheckFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось проверить актуальность'**
  String get lidCatalogCheckFailed;

  /// No description provided for @lidCatalogChecking.
  ///
  /// In ru, this message translates to:
  /// **'Проверяем обновления…'**
  String get lidCatalogChecking;

  /// No description provided for @lidCatalogQuestions.
  ///
  /// In ru, this message translates to:
  /// **'Вопросов в каталоге: {count}'**
  String lidCatalogQuestions(int count);

  /// No description provided for @lidCatalogLastChecked.
  ///
  /// In ru, this message translates to:
  /// **'Последняя проверка: {value}'**
  String lidCatalogLastChecked(String value);

  /// No description provided for @lidCatalogLastUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Последнее обновление: {value}'**
  String lidCatalogLastUpdated(String value);

  /// No description provided for @lidCatalogUsingLocal.
  ///
  /// In ru, this message translates to:
  /// **'Используется сохранённая локальная версия.'**
  String get lidCatalogUsingLocal;

  /// No description provided for @lidCatalogCheckAction.
  ///
  /// In ru, this message translates to:
  /// **'Проверить'**
  String get lidCatalogCheckAction;

  /// No description provided for @lidCatalogNoChanges.
  ///
  /// In ru, this message translates to:
  /// **'У вас уже актуальная версия вопросов.'**
  String get lidCatalogNoChanges;

  /// No description provided for @lidCatalogUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Каталог вопросов обновлён.'**
  String get lidCatalogUpdated;

  /// No description provided for @lidCatalogPartiallyUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Каталог обновлён, но не загружено изображений: {count}.'**
  String lidCatalogPartiallyUpdated(int count);

  /// No description provided for @lidCatalogCheckError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось проверить обновления. Используется локальная версия.'**
  String get lidCatalogCheckError;

  /// No description provided for @addedToList.
  ///
  /// In ru, this message translates to:
  /// **'Добавлено в список «{name}».'**
  String addedToList(String name);

  /// No description provided for @wordsCount.
  ///
  /// In ru, this message translates to:
  /// **'слов'**
  String get wordsCount;

  /// No description provided for @courseLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить учебные материалы'**
  String get courseLoadError;

  /// No description provided for @allWords.
  ///
  /// In ru, this message translates to:
  /// **'Все слова'**
  String get allWords;

  /// No description provided for @nouns.
  ///
  /// In ru, this message translates to:
  /// **'Существительные'**
  String get nouns;

  /// No description provided for @verbs.
  ///
  /// In ru, this message translates to:
  /// **'Глаголы'**
  String get verbs;

  /// No description provided for @otherWords.
  ///
  /// In ru, this message translates to:
  /// **'Другие'**
  String get otherWords;

  /// No description provided for @viewWords.
  ///
  /// In ru, this message translates to:
  /// **'Слова'**
  String get viewWords;

  /// No description provided for @configureSession.
  ///
  /// In ru, this message translates to:
  /// **'Настроить занятие'**
  String get configureSession;

  /// No description provided for @sessionSetupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройка занятия'**
  String get sessionSetupTitle;

  /// No description provided for @sessionSize.
  ///
  /// In ru, this message translates to:
  /// **'Количество слов'**
  String get sessionSize;

  /// No description provided for @startSession.
  ///
  /// In ru, this message translates to:
  /// **'Начать занятие'**
  String get startSession;

  /// No description provided for @showTranslation.
  ///
  /// In ru, this message translates to:
  /// **'Показать перевод'**
  String get showTranslation;

  /// No description provided for @nextWord.
  ///
  /// In ru, this message translates to:
  /// **'Следующее слово'**
  String get nextWord;

  /// No description provided for @finishSession.
  ///
  /// In ru, this message translates to:
  /// **'Завершить'**
  String get finishSession;

  /// No description provided for @sessionComplete.
  ///
  /// In ru, this message translates to:
  /// **'Занятие завершено'**
  String get sessionComplete;

  /// No description provided for @backToModule.
  ///
  /// In ru, this message translates to:
  /// **'Вернуться к модулю'**
  String get backToModule;

  /// No description provided for @noWords.
  ///
  /// In ru, this message translates to:
  /// **'В этой категории пока нет слов'**
  String get noWords;

  /// No description provided for @invalidCourseRoute.
  ///
  /// In ru, this message translates to:
  /// **'Учебный материал не найден'**
  String get invalidCourseRoute;

  /// No description provided for @customLists.
  ///
  /// In ru, this message translates to:
  /// **'Мои списки'**
  String get customLists;

  /// No description provided for @confirmedByTest.
  ///
  /// In ru, this message translates to:
  /// **'подтверждено проверкой'**
  String get confirmedByTest;

  /// No description provided for @newList.
  ///
  /// In ru, this message translates to:
  /// **'Новый список'**
  String get newList;

  /// No description provided for @listName.
  ///
  /// In ru, this message translates to:
  /// **'Название списка'**
  String get listName;

  /// No description provided for @create.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get create;

  /// No description provided for @rename.
  ///
  /// In ru, this message translates to:
  /// **'Переименовать'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @collectionEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В этой коллекции пока нет слов'**
  String get collectionEmpty;

  /// No description provided for @collectionsLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить коллекции'**
  String get collectionsLoadError;

  /// No description provided for @addToCollections.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в списки'**
  String get addToCollections;

  /// No description provided for @addToFavorites.
  ///
  /// In ru, this message translates to:
  /// **'В избранное'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из избранного'**
  String get removeFromFavorites;

  /// No description provided for @paletteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цветовая палитра'**
  String get paletteTitle;

  /// No description provided for @palettePink.
  ///
  /// In ru, this message translates to:
  /// **'Розовая'**
  String get palettePink;

  /// No description provided for @paletteAzure.
  ///
  /// In ru, this message translates to:
  /// **'Лазурная'**
  String get paletteAzure;

  /// No description provided for @paletteLime.
  ///
  /// In ru, this message translates to:
  /// **'Лаймовая'**
  String get paletteLime;

  /// No description provided for @paletteMonochrome.
  ///
  /// In ru, this message translates to:
  /// **'Монохромная'**
  String get paletteMonochrome;

  /// No description provided for @nounIndicatorTitle.
  ///
  /// In ru, this message translates to:
  /// **'Индикатор артикля'**
  String get nounIndicatorTitle;

  /// No description provided for @nounIndicatorV1.
  ///
  /// In ru, this message translates to:
  /// **'Вертикальная метка'**
  String get nounIndicatorV1;

  /// No description provided for @nounIndicatorV2.
  ///
  /// In ru, this message translates to:
  /// **'Цветная плашка'**
  String get nounIndicatorV2;

  /// No description provided for @learningProgress.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс обучения'**
  String get learningProgress;

  /// No description provided for @startKnowledgeCheck.
  ///
  /// In ru, this message translates to:
  /// **'Начать проверку знаний'**
  String get startKnowledgeCheck;

  /// No description provided for @configureTraining.
  ///
  /// In ru, this message translates to:
  /// **'Настроить тренировку'**
  String get configureTraining;

  /// No description provided for @startTraining.
  ///
  /// In ru, this message translates to:
  /// **'Начать тренировку'**
  String get startTraining;

  /// No description provided for @difficultyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сложность'**
  String get difficultyTitle;

  /// No description provided for @difficultyEasy.
  ///
  /// In ru, this message translates to:
  /// **'Легко'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In ru, this message translates to:
  /// **'Средне'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In ru, this message translates to:
  /// **'Сложно'**
  String get difficultyHard;

  /// No description provided for @difficultyEasyDescription.
  ///
  /// In ru, this message translates to:
  /// **'Выберите перевод немецкого слова'**
  String get difficultyEasyDescription;

  /// No description provided for @difficultyMediumDescription.
  ///
  /// In ru, this message translates to:
  /// **'Выберите артикль или немецкое слово'**
  String get difficultyMediumDescription;

  /// No description provided for @difficultyHardDescription.
  ///
  /// In ru, this message translates to:
  /// **'Введите немецкий вариант самостоятельно'**
  String get difficultyHardDescription;

  /// No description provided for @checkAnswer.
  ///
  /// In ru, this message translates to:
  /// **'Проверить'**
  String get checkAnswer;

  /// No description provided for @wordDetailsAction.
  ///
  /// In ru, this message translates to:
  /// **'О слове'**
  String get wordDetailsAction;

  /// No description provided for @continueAction.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get continueAction;

  /// No description provided for @nextQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Следующий вопрос'**
  String get nextQuestion;

  /// No description provided for @finishAction.
  ///
  /// In ru, this message translates to:
  /// **'Завершить'**
  String get finishAction;

  /// No description provided for @correctAnswerLabel.
  ///
  /// In ru, this message translates to:
  /// **'Правильный ответ'**
  String get correctAnswerLabel;

  /// No description provided for @correctAnswer.
  ///
  /// In ru, this message translates to:
  /// **'Правильно'**
  String get correctAnswer;

  /// No description provided for @wrongAnswer.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get wrongAnswer;

  /// No description provided for @knowledgeCheckComplete.
  ///
  /// In ru, this message translates to:
  /// **'Проверка завершена'**
  String get knowledgeCheckComplete;

  /// No description provided for @retryMistakes.
  ///
  /// In ru, this message translates to:
  /// **'Повторить ошибки'**
  String get retryMistakes;

  /// No description provided for @lidTitle.
  ///
  /// In ru, this message translates to:
  /// **'Leben in Deutschland'**
  String get lidTitle;

  /// No description provided for @lidTrainingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка'**
  String get lidTrainingTitle;

  /// No description provided for @lidTrainingSetupTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройка тренировки'**
  String get lidTrainingSetupTitle;

  /// No description provided for @lidMode.
  ///
  /// In ru, this message translates to:
  /// **'Режим'**
  String get lidMode;

  /// No description provided for @lidSequentialMode.
  ///
  /// In ru, this message translates to:
  /// **'Все вопросы по порядку'**
  String get lidSequentialMode;

  /// No description provided for @lidSequentialModeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Общие вопросы и вопросы выбранной земли'**
  String get lidSequentialModeDescription;

  /// No description provided for @lidExamSimulation.
  ///
  /// In ru, this message translates to:
  /// **'Симуляция экзамена'**
  String get lidExamSimulation;

  /// No description provided for @lidExamSimulationDescription.
  ///
  /// In ru, this message translates to:
  /// **'Экзамен в реалистичных условиях'**
  String get lidExamSimulationDescription;

  /// No description provided for @lidFederalState.
  ///
  /// In ru, this message translates to:
  /// **'Федеральная земля'**
  String get lidFederalState;

  /// No description provided for @lidSelectFederalState.
  ///
  /// In ru, this message translates to:
  /// **'Выберите федеральную землю'**
  String get lidSelectFederalState;

  /// No description provided for @lidStartExam.
  ///
  /// In ru, this message translates to:
  /// **'Начать экзамен'**
  String get lidStartExam;

  /// No description provided for @lidAnsweredQuestions.
  ///
  /// In ru, this message translates to:
  /// **'Отвеченные вопросы'**
  String get lidAnsweredQuestions;

  /// No description provided for @lidCorrectAnswers.
  ///
  /// In ru, this message translates to:
  /// **'Правильные ответы'**
  String get lidCorrectAnswers;

  /// No description provided for @lidAccuracy.
  ///
  /// In ru, this message translates to:
  /// **'Точность'**
  String get lidAccuracy;

  /// No description provided for @lidFavorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get lidFavorites;

  /// No description provided for @lidLearningProgress.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс обучения'**
  String get lidLearningProgress;

  /// No description provided for @lidMasteredQuestions.
  ///
  /// In ru, this message translates to:
  /// **'Освоено: {mastered} из {total}'**
  String lidMasteredQuestions(int mastered, int total);

  /// No description provided for @lidNoQuestions.
  ///
  /// In ru, this message translates to:
  /// **'Подходящие вопросы отсутствуют.'**
  String get lidNoQuestions;

  /// No description provided for @lidQuestionNumber.
  ///
  /// In ru, this message translates to:
  /// **'№ {number}'**
  String lidQuestionNumber(String number);

  /// No description provided for @lidFavoriteTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get lidFavoriteTooltip;

  /// No description provided for @lidTrainingComplete.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка завершена'**
  String get lidTrainingComplete;

  /// No description provided for @lidTrainingSummary.
  ///
  /// In ru, this message translates to:
  /// **'Вопросов: {total} · Ошибок: {mistakes}'**
  String lidTrainingSummary(int total, int mistakes);

  /// No description provided for @lidImageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Изображение {number}'**
  String lidImageLabel(int number);

  /// No description provided for @lidImageUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Изображение пока недоступно офлайн.'**
  String get lidImageUnavailable;

  /// No description provided for @lidExamTitle.
  ///
  /// In ru, this message translates to:
  /// **'Leben in Deutschland · Экзамен'**
  String get lidExamTitle;

  /// No description provided for @lidSubmitExam.
  ///
  /// In ru, this message translates to:
  /// **'Завершить экзамен'**
  String get lidSubmitExam;

  /// No description provided for @lidSaveAnswer.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить ответ'**
  String get lidSaveAnswer;

  /// No description provided for @lidExamResult.
  ///
  /// In ru, this message translates to:
  /// **'Результат экзамена'**
  String get lidExamResult;

  /// No description provided for @lidTestPassed.
  ///
  /// In ru, this message translates to:
  /// **'Тест Leben in Deutschland сдан'**
  String get lidTestPassed;

  /// No description provided for @lidTestFailed.
  ///
  /// In ru, this message translates to:
  /// **'Тест Leben in Deutschland не сдан'**
  String get lidTestFailed;

  /// No description provided for @lidCitizenshipPassed.
  ///
  /// In ru, this message translates to:
  /// **'Достигнут результат для подтверждения гражданства'**
  String get lidCitizenshipPassed;

  /// No description provided for @lidCitizenshipFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не достигнут порог в 17 баллов для гражданства'**
  String get lidCitizenshipFailed;

  /// No description provided for @lidBackToOverview.
  ///
  /// In ru, this message translates to:
  /// **'К обзору'**
  String get lidBackToOverview;

  /// No description provided for @lidViewMistakes.
  ///
  /// In ru, this message translates to:
  /// **'Посмотреть ошибки'**
  String get lidViewMistakes;

  /// No description provided for @lidYourAnswer.
  ///
  /// In ru, this message translates to:
  /// **'Ваш ответ: {answer}'**
  String lidYourAnswer(String answer);

  /// No description provided for @lidCorrectAnswerValue.
  ///
  /// In ru, this message translates to:
  /// **'Правильно: {answer}'**
  String lidCorrectAnswerValue(String answer);

  /// No description provided for @lidStatistics.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get lidStatistics;

  /// No description provided for @lidAnswers.
  ///
  /// In ru, this message translates to:
  /// **'Ответы'**
  String get lidAnswers;

  /// No description provided for @lidCorrect.
  ///
  /// In ru, this message translates to:
  /// **'Правильно'**
  String get lidCorrect;

  /// No description provided for @lidRate.
  ///
  /// In ru, this message translates to:
  /// **'Доля правильных'**
  String get lidRate;

  /// No description provided for @lidMastered.
  ///
  /// In ru, this message translates to:
  /// **'Освоено'**
  String get lidMastered;

  /// No description provided for @lidExams.
  ///
  /// In ru, this message translates to:
  /// **'Экзамены'**
  String get lidExams;

  /// No description provided for @lidNoCompletedExams.
  ///
  /// In ru, this message translates to:
  /// **'Завершённых экзаменов пока нет.'**
  String get lidNoCompletedExams;

  /// No description provided for @lidFavoritesMode.
  ///
  /// In ru, this message translates to:
  /// **'Только избранные'**
  String get lidFavoritesMode;

  /// No description provided for @lidFavoritesModeDescription.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка вопросов, добавленных в избранное'**
  String get lidFavoritesModeDescription;

  /// No description provided for @lidIncorrect.
  ///
  /// In ru, this message translates to:
  /// **'Неправильно'**
  String get lidIncorrect;

  /// No description provided for @lidUnanswered.
  ///
  /// In ru, this message translates to:
  /// **'Без ответа'**
  String get lidUnanswered;

  /// No description provided for @lidQuestionList.
  ///
  /// In ru, this message translates to:
  /// **'Список вопросов'**
  String get lidQuestionList;

  /// No description provided for @lidResetProgress.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить статистику ответов'**
  String get lidResetProgress;

  /// No description provided for @lidResetProgressTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить статистику?'**
  String get lidResetProgressTitle;

  /// No description provided for @lidResetProgressMessage.
  ///
  /// In ru, this message translates to:
  /// **'Правильные и неправильные ответы будут удалены. Избранное сохранится.'**
  String get lidResetProgressMessage;

  /// No description provided for @lidProgressReset.
  ///
  /// In ru, this message translates to:
  /// **'Статистика ответов сброшена'**
  String get lidProgressReset;

  /// No description provided for @lidAddFavoritesFirst.
  ///
  /// In ru, this message translates to:
  /// **'Сначала добавьте вопросы в избранное'**
  String get lidAddFavoritesFirst;

  /// No description provided for @lidAnsweredProgress.
  ///
  /// In ru, this message translates to:
  /// **'Отвечено: {answered} из {total}'**
  String lidAnsweredProgress(int answered, int total);

  /// No description provided for @lidContinueSession.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить сессию'**
  String get lidContinueSession;

  /// No description provided for @downloadAndroidTitle.
  ///
  /// In ru, this message translates to:
  /// **'Скачать приложение для Android'**
  String get downloadAndroidTitle;

  /// No description provided for @downloadAndroidSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'APK из последнего релиза на GitHub'**
  String get downloadAndroidSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
