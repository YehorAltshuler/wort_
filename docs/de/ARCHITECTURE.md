# Architektur von wort_

[English](../en/ARCHITECTURE.md) · [Русский](../ru/ARCHITECTURE.md)

## Überblick

wort_ ist eine Flutter-App für deutschen Wortschatz, kursbasiertes Lernen,
Übungen und **Leben in Deutschland** (LiD). Riverpod verwaltet den Zustand,
GoRouter die Navigation, Drift persistente Offline-Daten und `http` die
Aktualisierung des LiD-Datensatzes.

```text
lib/                    UI und Feature-Schicht
  app/                  Composition Root, Provider, Routen
  learning/             Lehrwerke, Module, Worttraining
  dictionary/           Wörterbuchsuche
  word_details/         Wortdetailseite
  collections/          Favoriten und eigene Listen
  exercises/            gezielte Übungen
  citizenship_test/     Leben in Deutschland
  settings/             Benutzereinstellungen
  widgets/              gemeinsame UI-Komponenten
packages/               unabhängige Daten-/Domain-Pakete
assets/                 Kurse, Übungen, LiD-Snapshot, Branding
web/                    Loader, PWA, Drift Worker, Web-Wörterbuch
```

## Schichten und Abhängigkeiten

Feature-Ordner enthalten Views, Riverpod-Provider und kleine Domain-Modelle.
Widgets greifen nie direkt auf Speicher oder HTTP zu. Provider erhalten
Repositories aus `lib/app/provider/repository_providers.dart`.

```text
UI → Provider → Repository-Schnittstelle → Client-Schnittstelle → Implementierung
```

Konkrete SQLite-, Drift-, HTTP- und Preferences-Implementierungen werden nur im
Composition Root verbunden. Lokale Pakete trennen Wörterbuch, Sammlungen,
Einstellungen, Lernfortschritt und LiD voneinander.

## Navigation und adaptive UI

Routen stehen in `lib/app/router/app_routes.dart` und werden in
`app_router.dart` konfiguriert. Hauptziele liegen in einem `PageView` und
wechseln animiert; Feature-Routen verwenden GoRouter.

Gemeinsame Bausteine liegen in `lib/widgets/`. `ResponsiveContent` begrenzt den
Body auf lesbare 960 px. Die wählbare Textgröße baut auf der unveränderten
Material-Standardskala auf. Auswahlvorgänge nutzen eine gemeinsame modale
Bottom-Sheet-Hülle. `AdaptiveStatCardRow` passt auf breiten Bildschirmen die
Höhe, nicht die beabsichtigte Breite der Karten an. Trainings teilen Antwort-,
Inhalts- und Aktionskomponenten.

## Persistenz

- natives Wörterbuch als SQLite, Web-Wörterbuch als indizierte JSON-Shards;
- Kurse und Übungen als gebündelte Assets;
- Einstellungen und leichter Lernfortschritt in Shared Preferences;
- Sammlungen in einer eigenen Drift-Datenbank;
- LiD-Fragen, Fortschritt, Favoriten, Antworten und Sitzungen in Drift.

Prüfungs- und Alle-Fragen-Sitzungen von LiD können nach dem Schließen der App
fortgesetzt werden. Warteschlange, Position und Prüfungsantworten werden
unabhängig vom austauschbaren Fragenkatalog gespeichert.

## LiD-Synchronisierung

Ein gebündelter Snapshot initialisiert eine leere Datenbank. Später vergleicht
das Repository ihn mit `bamf-lid-dataset`. Generationen durchlaufen
`staging → active → previous → obsolete`; erst vollständig validierte Daten
werden atomar aktiviert. Fehlende Bilder blockieren den Textkatalog nicht und
werden separat erneut geladen. Bilder liegen als versionierte Dateien bzw.
Web-Cache-Einträge außerhalb von Drift.

## Neues Feature hinzufügen

1. Feature-Ordner mit Views und Providern anlegen.
2. Repository-/Client-Verträge vor Speicher oder Netzwerk definieren.
3. Asynchrone Arbeit und Mutationen aus `build` heraushalten.
4. Bestehende Layout-, Auswahl-, Antwort- und Aktionswidgets wiederverwenden.
5. Routen, lokalisierte Texte und Tests für die geänderte Schicht ergänzen.
