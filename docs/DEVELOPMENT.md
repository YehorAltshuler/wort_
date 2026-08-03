# Разработка

## Требования

- Flutter SDK, совместимый с `pubspec.yaml`;
- Xcode для iOS;
- Android SDK и Java для Android;
- Chrome для Web.

Проверка окружения:

```bash
flutter doctor -v
```

## Установка

```bash
cd flutter_app
flutter pub get
```

Локальные packages подключаются через path dependencies и не требуют
публикации в Pub.

## Запуск

```bash
# Web
flutter run -d chrome

# Android
flutter run --flavor native -d android

# iOS
flutter run --flavor native -d ios
```

Для Android определён product flavor `native`. Для iOS существуют shared scheme
`native` и конфигурации `Debug-native`, `Profile-native`, `Release-native`.

## Маршруты и deep links

Для проверки маршрутов Web можно открыть URL напрямую:

```text
/dictionary
/dictionary/word/haus
```

Статический hosting должен перенаправлять неизвестные application routes на
`index.html`, но не должен перенаправлять `/lexicon/*`.

## Анализ и форматирование

Проект использует Very Good Analysis.

```bash
dart format lib test packages
flutter analyze
```

Публичная документация для каждого widget не обязательна, остальные VGV rules
остаются включёнными.

## Тесты

```bash
# UI и providers приложения
flutter test

# Web HTTP client
(cd packages/web_lexicon_client && dart test)

# Repository mapping
(cd packages/lexicon_repository && dart test)

# Course repository mapping
(cd packages/course_repository && dart test)

# Expo-compatible learning progress
(cd packages/learning_progress_repository && flutter test)

# Settings persistence rules
(cd packages/settings_repository && flutter test)

# Native Drift client с настоящей SQLite
(cd packages/sqlite_lexicon_client && flutter test)

# Leben in Deutschland repositories, HTTP и Drift
(cd packages/citizenship_test_repository && dart test)
(cd packages/http_citizenship_test_client && dart test)
(cd packages/drift_citizenship_test_client && flutter test)

# Web Cache Storage
(cd packages/drift_citizenship_test_client && \
  flutter test --platform chrome test/web_media_store_test.dart)
```

UI-тесты подменяют repositories через `ProviderScope.overrides`. Data clients
тестируются отдельно с настоящей базой или mock HTTP client.

Исходные учебные JSON находятся в `assets/coursebooks`. Их `bookId`,
`moduleFile` и позиция слова образуют стабильный Expo-совместимый ID вида
`bookId:moduleFile:index`.

## Code generation

Drift-код генерируется внутри native client package:

```bash
cd packages/sqlite_lexicon_client
dart run build_runner build
```

Для LiD-схемы генерация запускается аналогично в
`packages/drift_citizenship_test_client`.

После изменения таблиц или Drift annotations generated-файлы необходимо
обновить и проверить анализатором.

Локализации находятся в `lib/l10n/*.arb`. После их изменения выполните:

```bash
flutter gen-l10n
```

## Сборка

```bash
# Web release
flutter build web

# Android
flutter build apk --flavor native
flutter build appbundle --flavor native

# iOS без подписи для CI-проверки
flutter build ios --flavor native --no-codesign

# iOS archive с настроенной подписью
flutter build ipa --flavor native
```

## Проверка platform assets

Web не должен содержать SQLite:

```bash
find build/web -name lexicon.db
```

Android должен содержать SQLite, но не Web shards:

```bash
unzip -l build/app/outputs/flutter-apk/app-native-release.apk \
  | grep assets/native/lexicon.db
```

iOS native build должен содержать SQLite:

```bash
find build/ios/iphoneos/Runner.app -name lexicon.db
```

## Перед pull request

1. Запустить formatter.
2. Запустить `flutter analyze`.
3. Запустить app и package tests.
4. Для platform changes собрать затронутые targets.
5. Обновить документацию при изменении архитектуры, маршрутов или команд.
