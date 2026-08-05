// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'wort_';

  @override
  String get learningTab => 'التعلّم';

  @override
  String get dictionaryTab => 'القاموس';

  @override
  String get collectionsTab => 'كلماتي';

  @override
  String get settingsTab => 'الإعدادات';

  @override
  String get homeTagline => 'العثور على الكلمة لا يكفي — يجب تذكّرها.';

  @override
  String get booksTitle => 'الكتب والوحدات';

  @override
  String get booksSubtitle => 'تعلّم مفردات الدورة خطوة بخطوة';

  @override
  String get knowledgeCheckTitle => 'اختبار المعرفة';

  @override
  String get exercisesTitle => 'تمارين';

  @override
  String get fixedPrepositionEasyDescription => 'اختر الترجمة والحالة الصحيحة';

  @override
  String get fixedPrepositionHardDescription => 'اختر حرف الجر والحالة الصحيحة';

  @override
  String get fixedPrepositionPrompt => 'أدخل حرف الجر الثابت وحدد الحالة';

  @override
  String get chooseTranslationAndCase => 'اختر الترجمة والحالة';

  @override
  String get preposition => 'حرف الجر';

  @override
  String get translationTitle => 'الترجمة';

  @override
  String get grammaticalCase => 'الحالة الإعرابية';

  @override
  String get knowledgeCheckSubtitle => 'استرجاع نشط ومراجعة الأخطاء';

  @override
  String get citizenshipTestSubtitle =>
      'التحضير للاختبار الرسمي والتدرب على الامتحان';

  @override
  String get lidTestChoiceTitle => 'اختبار LiD';

  @override
  String get lidTestChoiceSubtitle => 'الأسئلة والإحصاءات ومحاكاة الامتحان';

  @override
  String get lidVocabularyChoiceTitle => 'مفردات LiD';

  @override
  String get lidVocabularyChoiceSubtitle =>
      'تعلّم كلمات من دليل الحياة في ألمانيا';

  @override
  String get progressTitle => 'التقدّم';

  @override
  String get progressSubtitle => 'الكلمات المتعلّمة والنشاط الأخير';

  @override
  String get dictionaryTitle => 'القاموس';

  @override
  String get dictionaryHint => 'بحث';

  @override
  String get dictionaryPrompt => 'ابدأ بكتابة كلمة ألمانية';

  @override
  String get dictionaryEmpty => 'لم يتم العثور على نتائج';

  @override
  String get dictionaryLoadError => 'تعذّر تحميل القاموس';

  @override
  String get collectionsTitle => 'كلماتي';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesSubtitle => 'كلمات للتدريب الشخصي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get themeTitle => 'المظهر';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get textSizeTitle => 'حجم النص';

  @override
  String get textSizeStandard => 'قياسي';

  @override
  String get textSizeLarge => 'كبير';

  @override
  String get textSizeExtraLarge => 'كبير جدًا';

  @override
  String get wordLoadError => 'تعذّر تحميل الكلمة';

  @override
  String get wordNotFound => 'الكلمة غير موجودة';

  @override
  String get noun => 'اسم';

  @override
  String get verb => 'فعل';

  @override
  String get otherPartOfSpeech => 'نوع آخر من الكلام';

  @override
  String frequencyRank(int rank) {
    return 'الترتيب $rank';
  }

  @override
  String get meaningsTitle => 'المعاني';

  @override
  String get formsTitle => 'الصيغ';

  @override
  String get etymologyTitle => 'أصل الكلمة';

  @override
  String get dictionarySources => 'مصادر القاموس';

  @override
  String get wiktionaryAttribution =>
      'محتوى Wiktionary/Kaikki متاح بموجب ترخيص CC BY-SA.';

  @override
  String get externalLinkError => 'تعذر فتح القاموس الخارجي.';

  @override
  String get coursebooksTitle => 'الكتب الدراسية';

  @override
  String get modulesTitle => 'الوحدات';

  @override
  String get modulesCount => 'وحدات';

  @override
  String get generalSettingsSection => 'عام';

  @override
  String get learningSettingsSection => 'التعلم';

  @override
  String get appearanceSettingsSection => 'المظهر';

  @override
  String get lidSettingsSection => 'Leben in Deutschland';

  @override
  String get lidCatalogTitle => 'دليل أسئلة LiD';

  @override
  String get lidCatalogUpToDate => 'الأسئلة محدّثة';

  @override
  String get lidCatalogCheckRecommended => 'يُنصح بالتحقق من التحديثات';

  @override
  String get lidCatalogStatusUnknown => 'لم يتم التحقق من حالة التحديث بعد';

  @override
  String get lidCatalogInstalledNotChecked =>
      'تم تثبيت الدليل المحلي، ولم يكتمل التحقق عبر الإنترنت بعد';

  @override
  String get lidCatalogCheckFailed => 'تعذر التحقق من حداثة الأسئلة';

  @override
  String get lidCatalogChecking => 'جارٍ التحقق من التحديثات…';

  @override
  String lidCatalogQuestions(int count) {
    return 'الأسئلة في الدليل: $count';
  }

  @override
  String lidCatalogLastChecked(String value) {
    return 'آخر تحقق: $value';
  }

  @override
  String lidCatalogLastUpdated(String value) {
    return 'آخر تحديث: $value';
  }

  @override
  String get lidCatalogUsingLocal => 'يتم استخدام النسخة المحلية المحفوظة.';

  @override
  String get lidCatalogCheckAction => 'تحقق';

  @override
  String get lidCatalogNoChanges => 'دليل الأسئلة محدّث بالفعل.';

  @override
  String get lidCatalogUpdated => 'تم تحديث دليل الأسئلة.';

  @override
  String lidCatalogPartiallyUpdated(int count) {
    return 'تم تحديث الدليل، لكن تعذر تنزيل $count صورة.';
  }

  @override
  String get lidCatalogCheckError =>
      'تعذر التحقق من التحديثات. ما زالت النسخة المحلية متاحة.';

  @override
  String addedToList(String name) {
    return 'تمت الإضافة إلى «$name».';
  }

  @override
  String get wordsCount => 'كلمة';

  @override
  String get courseLoadError => 'تعذّر تحميل المواد التعليمية';

  @override
  String get allWords => 'كل الكلمات';

  @override
  String get nouns => 'الأسماء';

  @override
  String get verbs => 'الأفعال';

  @override
  String get otherWords => 'أخرى';

  @override
  String get viewWords => 'الكلمات';

  @override
  String get configureSession => 'إعداد الجلسة';

  @override
  String get sessionSetupTitle => 'إعداد الجلسة';

  @override
  String get sessionSize => 'عدد الكلمات';

  @override
  String get startSession => 'بدء الجلسة';

  @override
  String get showTranslation => 'إظهار الترجمة';

  @override
  String get nextWord => 'الكلمة التالية';

  @override
  String get finishSession => 'إنهاء';

  @override
  String get sessionComplete => 'اكتملت الجلسة';

  @override
  String get backToModule => 'العودة إلى الوحدة';

  @override
  String get noWords => 'لا توجد كلمات في هذه الفئة بعد';

  @override
  String get invalidCourseRoute => 'المادة التعليمية غير موجودة';

  @override
  String get customLists => 'قوائمي';

  @override
  String get confirmedByTest => 'تم تأكيدها بالاختبار';

  @override
  String get newList => 'قائمة جديدة';

  @override
  String get listName => 'اسم القائمة';

  @override
  String get create => 'إنشاء';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get collectionEmpty => 'لا توجد كلمات في هذه المجموعة بعد';

  @override
  String get collectionsLoadError => 'تعذّر تحميل المجموعات';

  @override
  String get addToCollections => 'إضافة إلى القوائم';

  @override
  String get addToFavorites => 'إضافة إلى المفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get paletteTitle => 'لوحة الألوان';

  @override
  String get palettePink => 'وردي';

  @override
  String get paletteAzure => 'أزرق سماوي';

  @override
  String get paletteLime => 'ليموني';

  @override
  String get paletteMonochrome => 'أحادي اللون';

  @override
  String get nounIndicatorTitle => 'مؤشر أداة التعريف';

  @override
  String get nounIndicatorV1 => 'علامة عمودية';

  @override
  String get nounIndicatorV2 => 'شارة ملونة';

  @override
  String get learningProgress => 'تقدم التعلم';

  @override
  String get startKnowledgeCheck => 'بدء اختبار المعرفة';

  @override
  String get configureTraining => 'إعداد التدريب';

  @override
  String get startTraining => 'ابدأ التدريب';

  @override
  String get difficultyTitle => 'الصعوبة';

  @override
  String get difficultyEasy => 'سهل';

  @override
  String get difficultyMedium => 'متوسط';

  @override
  String get difficultyHard => 'صعب';

  @override
  String get difficultyEasyDescription => 'اختر ترجمة الكلمة الألمانية';

  @override
  String get difficultyMediumDescription =>
      'اختر أداة التعريف أو الكلمة الألمانية';

  @override
  String get difficultyHardDescription => 'أدخل الصيغة الألمانية بنفسك';

  @override
  String get checkAnswer => 'تحقق';

  @override
  String get wordDetailsAction => 'تفاصيل الكلمة';

  @override
  String get continueAction => 'متابعة';

  @override
  String get nextQuestion => 'السؤال التالي';

  @override
  String get finishAction => 'إنهاء';

  @override
  String get correctAnswerLabel => 'الإجابة الصحيحة';

  @override
  String get correctAnswer => 'صحيح';

  @override
  String get wrongAnswer => 'خطأ';

  @override
  String get knowledgeCheckComplete => 'اكتمل اختبار المعرفة';

  @override
  String get retryMistakes => 'إعادة الأخطاء';

  @override
  String get lidTitle => 'الحياة في ألمانيا';

  @override
  String get lidTrainingTitle => 'التدريب';

  @override
  String get lidTrainingSetupTitle => 'إعداد التدريب';

  @override
  String get lidMode => 'الوضع';

  @override
  String get lidSequentialMode => 'جميع الأسئلة بالترتيب';

  @override
  String get lidSequentialModeDescription =>
      'الأسئلة العامة وأسئلة الولاية المحددة';

  @override
  String get lidExamSimulation => 'محاكاة الاختبار';

  @override
  String get lidExamSimulationDescription => 'اختبار في ظروف واقعية';

  @override
  String get lidFederalState => 'الولاية الاتحادية';

  @override
  String get lidSelectFederalState => 'اختر الولاية الاتحادية';

  @override
  String get lidStartExam => 'بدء الاختبار';

  @override
  String get lidAnsweredQuestions => 'الأسئلة المجابة';

  @override
  String get lidCorrectAnswers => 'الإجابات الصحيحة';

  @override
  String get lidAccuracy => 'الدقة';

  @override
  String get lidFavorites => 'المفضلة';

  @override
  String get lidLearningProgress => 'تقدم التعلم';

  @override
  String lidMasteredQuestions(int mastered, int total) {
    return 'تم إتقان $mastered من $total سؤالاً';
  }

  @override
  String get lidNoQuestions => 'لا توجد أسئلة مناسبة متاحة.';

  @override
  String lidQuestionNumber(String number) {
    return 'رقم $number';
  }

  @override
  String get lidFavoriteTooltip => 'المفضلة';

  @override
  String get lidTrainingComplete => 'اكتمل التدريب';

  @override
  String lidTrainingSummary(int total, int mistakes) {
    return '$total سؤالاً · $mistakes أخطاء';
  }

  @override
  String lidImageLabel(int number) {
    return 'الصورة $number';
  }

  @override
  String get lidImageUnavailable => 'الصورة غير متاحة دون اتصال حتى الآن.';

  @override
  String get lidExamTitle => 'الحياة في ألمانيا · الاختبار';

  @override
  String get lidSubmitExam => 'تسليم الاختبار';

  @override
  String get lidSaveAnswer => 'حفظ الإجابة';

  @override
  String get lidExamResult => 'نتيجة الاختبار';

  @override
  String get lidTestPassed => 'تم اجتياز اختبار الحياة في ألمانيا';

  @override
  String get lidTestFailed => 'لم يتم اجتياز اختبار الحياة في ألمانيا';

  @override
  String get lidCitizenshipPassed => 'تم بلوغ الحد المطلوب لإثبات الجنسية';

  @override
  String get lidCitizenshipFailed => 'لم يتم بلوغ حد 17 نقطة للجنسية';

  @override
  String get lidBackToOverview => 'العودة إلى النظرة العامة';

  @override
  String get lidViewMistakes => 'مراجعة الأخطاء';

  @override
  String lidYourAnswer(String answer) {
    return 'إجابتك: $answer';
  }

  @override
  String lidCorrectAnswerValue(String answer) {
    return 'الصحيح: $answer';
  }

  @override
  String get lidStatistics => 'الإحصاءات';

  @override
  String get lidAnswers => 'الإجابات';

  @override
  String get lidCorrect => 'صحيح';

  @override
  String get lidRate => 'نسبة الصحة';

  @override
  String get lidMastered => 'تم إتقانه';

  @override
  String get lidExams => 'الاختبارات';

  @override
  String get lidNoCompletedExams => 'لا يوجد اختبار مكتمل بعد.';

  @override
  String get lidFavoritesMode => 'المفضلة فقط';

  @override
  String get lidFavoritesModeDescription =>
      'التدرب على الأسئلة المضافة إلى المفضلة';

  @override
  String get lidIncorrect => 'غير صحيح';

  @override
  String get lidUnanswered => 'دون إجابة';

  @override
  String get lidQuestionList => 'قائمة الأسئلة';

  @override
  String get lidResetProgress => 'إعادة تعيين إحصاءات الإجابات';

  @override
  String get lidResetProgressTitle => 'إعادة تعيين الإحصاءات؟';

  @override
  String get lidResetProgressMessage =>
      'ستُحذف الإجابات الصحيحة والخاطئة مع الاحتفاظ بالمفضلة.';

  @override
  String get lidProgressReset => 'تمت إعادة تعيين إحصاءات الإجابات';

  @override
  String get lidAddFavoritesFirst => 'أضف أسئلة إلى المفضلة أولاً';

  @override
  String lidAnsweredProgress(int answered, int total) {
    return 'تمت الإجابة عن $answered من $total';
  }

  @override
  String get lidContinueSession => 'متابعة الجلسة';

  @override
  String get downloadAndroidTitle => 'تنزيل تطبيق Android';

  @override
  String get downloadAndroidSubtitle => 'ملف APK من أحدث إصدار على GitHub';
}
