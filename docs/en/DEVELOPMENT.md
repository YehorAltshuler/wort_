# Developing and releasing wort_

[Deutsch](../de/DEVELOPMENT.md) · [Русский](../ru/DEVELOPMENT.md)

## Requirements and setup

Install Flutter stable compatible with `pubspec.yaml`, Git, Chrome, Android
Studio/SDK for Android, and Xcode/CocoaPods for iOS.

```bash
git clone https://github.com/YehorAltshuler/wort_.git
cd wort_
flutter doctor
flutter pub get
```

Native builds use the `native` flavor because it contains the SQLite lexicon:

```bash
flutter run --flavor native
flutter run --flavor native -d <device-id>
```

Web does not use a flavor:

```bash
flutter run -d chrome
```

## Verification

Run before publishing:

```bash
dart format .
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release
```

Package tests can additionally be run from their package directories. Changes
to Drift Web storage should include the Chrome media-store test.

## Release builds

```bash
# Web
flutter build web --release \
  --dart-define=APK_DOWNLOAD_URL=https://github.com/YehorAltshuler/wort_/releases/latest/download/wort.apk

# Android
flutter build apk --release --flavor native

# iOS verification without signing
flutter build ios --release --flavor native --no-codesign
```

Artifacts are written below `build/web`,
`build/app/outputs/flutter-apk/app-native-release.apk`, and
`build/ios/iphoneos`. A distributable iOS archive requires an Apple Developer
team. Android release builds currently use debug signing; configure a dedicated
release keystore before public store distribution.

## CI and delivery

`.github/workflows/flutter-ci.yml` checks formatting, analysis, tests, and Web
builds on pushes and pull requests. Tags matching `v*` trigger
`publish-android-apk.yml`, which publishes `wort.apk`. Vercel builds the Web app
through `scripts/build-web.sh` and `vercel.json`.

After changing the HTML loader or PWA resources, use a hard reload or clear site
data because service-worker and HTTP caches may show an older loader.

## Safe publishing

```bash
git status
git fetch origin
git log --oneline origin/main..HEAD
git push origin main
```

Use `git push --force-with-lease origin main` only after intentionally rewriting
your own unpublished commits and after fetching. The lease rejects the update if
the remote branch has changed. Never commit build output, `.dart_tool`, signing
keys, IDE state, or local user databases.

Before tagging a release, update `version` in `pubspec.yaml`, rerun all checks,
then push the tag:

```bash
git tag v1.0.1
git push origin v1.0.1
```
