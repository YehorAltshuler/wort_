# Entwicklung und Releases von wort_

[English](../en/DEVELOPMENT.md) · [Русский](../ru/DEVELOPMENT.md)

## Voraussetzungen und Einrichtung

Benötigt werden Flutter stable passend zu `pubspec.yaml`, Git, Chrome, Android
Studio/SDK für Android sowie Xcode/CocoaPods für iOS.

```bash
git clone https://github.com/YehorAltshuler/wort_.git
cd wort_
flutter doctor
flutter pub get
```

Native Builds verwenden wegen der SQLite-Wortdatenbank den Flavor `native`:

```bash
flutter run --flavor native
flutter run --flavor native -d <device-id>
```

Die Web-Version verwendet keinen Flavor: `flutter run -d chrome`.

## Prüfungen

Vor der Veröffentlichung ausführen:

```bash
dart format .
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release
```

Pakettests können zusätzlich in den jeweiligen Paketordnern laufen. Änderungen
am Drift-Webspeicher sollten den Chrome-Test des Media Store einschließen.

## Release Builds

```bash
# Web
flutter build web --release \
  --dart-define=APK_DOWNLOAD_URL=https://github.com/YehorAltshuler/wort_/releases/latest/download/wort.apk

# Android
flutter build apk --release --flavor native

# iOS-Prüfung ohne Signatur
flutter build ios --release --flavor native --no-codesign
```

Artefakte liegen unter `build/web`,
`build/app/outputs/flutter-apk/app-native-release.apk` und
`build/ios/iphoneos`. Ein verteilbares iOS-Archiv benötigt ein Apple-Developer-
Team. Android nutzt derzeit Debug-Signierung; vor einer Store-Veröffentlichung
ist ein eigener Release-Keystore einzurichten.

## CI und Auslieferung

`.github/workflows/flutter-ci.yml` prüft Formatierung, Analyse, Tests und Web-
Build bei Pushes und Pull Requests. Tags `v*` starten
`publish-android-apk.yml` und veröffentlichen `wort.apk`. Vercel baut die
Web-App über `scripts/build-web.sh` und `vercel.json`.

Nach Änderungen am HTML-Loader oder an PWA-Ressourcen ist ein Hard Reload bzw.
das Löschen der Website-Daten nötig, da Caches eine ältere Version zeigen können.

## Sicher veröffentlichen

```bash
git status
git fetch origin
git log --oneline origin/main..HEAD
git push origin main
```

`git push --force-with-lease origin main` nur nach bewusstem Umschreiben eigener,
noch unveröffentlichter Commits und nach `git fetch` verwenden. Der Lease lehnt
den Push ab, wenn sich die Remote-Branch geändert hat. Build-Ausgaben,
`.dart_tool`, Signaturschlüssel, IDE-Zustand und lokale Nutzerdatenbanken gehören
nicht in Git.

Vor einem Release-Tag die Version in `pubspec.yaml` erhöhen und alle Prüfungen
erneut ausführen.
