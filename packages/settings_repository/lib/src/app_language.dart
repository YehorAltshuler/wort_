enum AppLanguage {
  russian('ru'),
  english('en'),
  german('de'),
  arabic('ar');

  const AppLanguage(this.code);

  final String code;

  static AppLanguage fromCode(String? code) => switch (code) {
    'ru' => russian,
    'de' => german,
    'ar' => arabic,
    _ => english,
  };
}
