# Разработка и релизы wort_

[English](../en/DEVELOPMENT.md) · [Deutsch](../de/DEVELOPMENT.md)

## Требования

- Flutter stable с Dart, совместимый с SDK из `pubspec.yaml`;
- Android Studio и Android SDK для Android-эмулятора/устройства;
- Xcode и CocoaPods для iOS;
- Chrome для Web;
- Git.

Проверьте окружение:

```bash
flutter doctor
flutter --version
```

## Первичный запуск

```bash
git clone https://github.com/YehorAltshuler/wort_.git
cd wort_
flutter pub get
```

Нативная конфигурация использует flavor `native`, поскольку в неё входит
локальная SQLite-база словаря:

```bash
flutter run --flavor native
flutter run --flavor native -d <android-device-id>
flutter run --flavor native -d <ios-device-id>
```

Для VS Code: выберите Android-эмулятор или iOS Simulator в статусной строке,
откройте `lib/main.dart` и нажмите **Run and Debug**. При необходимости сначала
запустите эмулятор из Device Manager/Simulator.

Web не использует flavor:

```bash
flutter run -d chrome
```

## Проверки перед изменением и перед push

```bash
dart format .
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Проверяйте изменённую feature точечно во время разработки, а полный `flutter
test` запускайте перед публикацией. Для изменений Web дополнительно соберите
release-версию:

```bash
flutter build web --release
```

Для нативной проверки LiD и словаря запускайте как минимум Android и iOS:

```bash
flutter run --flavor native -d <android-device-id>
flutter run --flavor native -d <ios-device-id>
```

## Сборки

### Web

```bash
flutter build web --release \
  --dart-define=APK_DOWNLOAD_URL=https://github.com/YehorAltshuler/wort_/releases/latest/download/wort.apk
```

Результат находится в `build/web`. Vercel выполняет этот шаг сам через
`scripts/build-web.sh`; конфигурация находится в `vercel.json`.

После изменения `web/index.html` или PWA-ресурсов делайте hard reload в
браузере либо очистите site data: service worker и HTTP cache могут показывать
старую загрузочную страницу.

### Android APK

```bash
flutter build apk --release --flavor native
```

APK: `build/app/outputs/flutter-apk/app-native-release.apk`.

GitHub Actions автоматически строит APK при push тега `v*` и прикрепляет его
как `wort.apk` к GitHub Release. До публичного распространения нужно заменить
debug signing на отдельный release keystore и GitHub Secrets.

### iOS

```bash
flutter build ios --release --flavor native
```

Для подписи и распространения требуется настроенная команда Apple Developer в
Xcode.

## Правильный push

Обычные изменения публикуйте линейной историей:

```bash
git status
git fetch origin
git pull --rebase origin main
dart format .
flutter analyze
flutter test
git add <files>
git commit -m "Describe the change"
git push origin main
```

Не добавляйте в коммит `build/`, `.dart_tool/`, IDE-файлы, ключи подписи или
локальные базы с пользовательскими данными. Перед `git add` всегда смотрите
`git diff` и `git status`.

### Когда допустим `--force-with-lease`

`git push --force-with-lease` нужен только после осознанного переписывания
своих ещё не согласованных коммитов: например, после `git commit --amend` или
интерактивного rebase. Он безопаснее `--force`, потому что отклонит push, если
удалённая ветка изменилась после последнего `git fetch`.

```bash
git fetch origin
git log --oneline origin/main..HEAD
git push --force-with-lease origin main
```

Никогда не используйте `--force` и не применяйте `--force-with-lease`, пока не
проверили, что чужие commits не будут удалены. Для production-проектов
предпочтительны pull request и обычный push; `main` этого проекта допускает
`--force-with-lease` только по явному согласованию.

## CI и публикация

- `.github/workflows/flutter-ci.yml` запускается на push в `main` и pull
  request: форматирование, analyzer, тесты и Web build.
- `.github/workflows/publish-android-apk.yml` запускается на теге `v*` и
  публикует APK в GitHub Release.
- Vercel реагирует на репозиторий и собирает `build/web` согласно
  `vercel.json`.

Перед релизным тегом убедитесь, что версия в `pubspec.yaml` обновлена и все
проверки прошли. Пример:

```bash
git tag v1.0.1
git push origin v1.0.1
```
