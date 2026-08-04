<div align="center">
  <img src="assets/brand/wort-feature-graphic.png" alt="wort_" width="560" />

  # wort_

  **Deutsches Wörterbuch, Kursbegleiter und gezieltes Training.**

  [![Web-App öffnen](https://img.shields.io/badge/Web_App_öffnen-EA4C89?style=for-the-badge&logo=vercel&logoColor=white)](https://wort-five.vercel.app)
  [![APK herunterladen](https://img.shields.io/badge/APK_herunterladen-242424?style=for-the-badge&logo=android&logoColor=white)](https://github.com/YehorAltshuler/wort_/releases/latest/download/wort.apk)

  [English](README.md) · [Deutsch](README.de.md) · [Русский](README.ru.md)
</div>

## Deutsch im Kontext lernen

wort_ verbindet ein Wörterbuch mit 29.599 deutschen Wörtern, Kurswortschatz,
Übungen, eigene Wortlisten und einen offlinefähigen Trainer für **Leben in
Deutschland**. Dieselbe adaptive Flutter-App läuft auf Android, iOS und im Web.

### Funktionen

- schnelle Suche, Wortdetails, Beispiele, Formen und externe Quellen;
- Wortschatz aus vier Lehrwerken und 31 Lernmodulen;
- Trainings, Übungen, Favoriten und eigene Sammlungen;
- alle 460 LiD-Fragen, Bundeslandauswahl, Prüfung, Statistik und fortsetzbare Sitzungen;
- lokale Datenspeicherung und sichere Aktualisierung des LiD-Datensatzes;
- helles/dunkles Design, Farbpaletten und adaptive Textgrößen;
- russische, englische und arabische Benutzeroberfläche.

## Lokal starten

```bash
flutter pub get
flutter run --flavor native
```

Die Web-Version läuft ohne Flavor: `flutter run -d chrome`. Einzelheiten stehen
im [Entwicklungsleitfaden](docs/de/DEVELOPMENT.md).

## Qualitätsprüfungen

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release
```

## Dokumentation

| Thema | English | Deutsch | Русский |
| --- | --- | --- | --- |
| Architektur | [Read](docs/en/ARCHITECTURE.md) | [Lesen](docs/de/ARCHITECTURE.md) | [Читать](docs/ru/ARCHITECTURE.md) |
| Entwicklung & Releases | [Read](docs/en/DEVELOPMENT.md) | [Lesen](docs/de/DEVELOPMENT.md) | [Читать](docs/ru/DEVELOPMENT.md) |
| Wörterbuch | [Read](docs/en/LEXICON.md) | [Lesen](docs/de/LEXICON.md) | [Читать](docs/ru/LEXICON.md) |
| Leben in Deutschland | [Read](docs/en/LID_TEST.md) | [Lesen](docs/de/LID_TEST.md) | [Читать](docs/ru/LID_TEST.md) |

## Auslieferung

GitHub Actions prüft Formatierung, statische Analyse, Tests und den Web-Release-
Build. Tags mit `v*` bauen `wort.apk` und hängen sie an ein GitHub Release an.
Vercel veröffentlicht die Web-App anhand von `vercel.json`.

## Lizenz

Derzeit wurde keine Open-Source-Lizenz erteilt. Quellcode und mitgelieferte
Daten unterliegen weiterhin den Rechten ihrer jeweiligen Eigentümer.
