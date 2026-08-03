enum AppLanguage {
  russian('ru'),
  english('en'),
  arabic('ar');

  const AppLanguage(this.code);

  final String code;

  static AppLanguage fromCode(String? code) => switch (code) {
    'ru' => russian,
    'ar' => arabic,
    _ => english,
  };
}
