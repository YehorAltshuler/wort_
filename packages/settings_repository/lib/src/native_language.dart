import 'package:settings_repository/src/app_language.dart';

enum NativeLanguage {
  russian('ru'),
  english('en'),
  arabic('ar');

  const NativeLanguage(this.code);

  final String code;

  static NativeLanguage fromCode(String? code) => switch (code) {
    'ru' => russian,
    'ar' => arabic,
    _ => english,
  };

  static NativeLanguage fromAppLanguage(AppLanguage language) =>
      switch (language) {
        AppLanguage.russian => russian,
        AppLanguage.arabic => arabic,
        AppLanguage.english || AppLanguage.german => english,
      };
}
