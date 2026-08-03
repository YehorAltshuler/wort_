<div align="center">
  <img src="assets/brand/wort-feature-graphic.png" alt="wort_" width="480" />

  # wort_

  **Немецкий словарь, учебники и осмысленные тренировки**

  [![Web](https://img.shields.io/badge/Открыть_Web-EA4C89?style=for-the-badge&logo=vercel&logoColor=white)](https://wort-five.vercel.app)
  [![APK](https://img.shields.io/badge/Скачать_APK-242424?style=for-the-badge&logo=android&logoColor=white)](https://github.com/YehorAltshuler/wort_/releases/latest/download/wort.apk)
</div>

## Возможности

- немецкий словарь, избранное и пользовательские списки;
- обучение по учебникам и упражнения;
- offline-first тест Leben in Deutschland;
- Android, iOS и адаптивная Web-версия;
- русский, английский и арабский интерфейс.

## Запуск

```bash
flutter pub get
flutter run --flavor native
```

Web запускается командой `flutter run -d chrome`.

## Проверки

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Публикация

- Vercel собирает приложение по `vercel.json`.
- `.github/workflows/flutter-ci.yml` проверяет каждый push и pull request.
- Тег `v*` запускает `.github/workflows/publish-android-apk.yml` и прикрепляет `wort.apk` к GitHub Release.
- `APK_DOWNLOAD_URL` переопределяет адрес кнопки скачивания в Web.

Release-сборка Android пока подписывается debug-ключом. Перед публичным распространением необходимо настроить отдельный release keystore через GitHub Secrets.
