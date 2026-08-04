# Leben in Deutschland

[English](../en/LID_TEST.md) · [Русский](../ru/LID_TEST.md)

## Architektur

Die UI liest Fragen ausschließlich aus der lokalen Drift-Datenbank. Remote-JSON
und Bilder verwendet nur `CitizenshipTestRepository` während der
Synchronisierung.

```text
UI → Riverpod → CitizenshipTestRepository
                    ├─ DriftCitizenshipTestClient
                    ├─ HttpCitizenshipTestClient
                    └─ CitizenshipTestMediaStore
```

Die einzige Remote-Quelle ist das veröffentlichte
[`bamf-lid-dataset`](https://github.com/YehorAltshuler/bamf-lid-dataset).
Die App liest weder BAMF-Webseiten noch PDFs ein.

## Lokale Daten und Sitzungen

Drift speichert Kataloggenerationen, Fragen, Medien-/Sync-Metadaten, Fortschritt,
Favoriten, Prüfungen und Antworten. Native Bilder liegen in versionierten
Application-Support-Ordnern, Web-Bilder im persistenten Browsercache.

Der gebündelte Snapshot enthält 460 Fragen und 100 Bilder und initialisiert nur
eine leere Datenbank. Prüfungs- und Alle-Fragen-Sitzungen speichern Warteschlange
und aktuelle Position. Prüfungen speichern zusätzlich gewählte Antworten und
können nach dem Schließen der App fortgesetzt werden. Ein expliziter Start mit
`startNew` ersetzt die bisher aktive Sitzung.

## Synchronisierung

- automatische Prüfung beim Start/Vordergrund höchstens alle 15 Tage;
- Fehler-Cooldown: 1 Stunde, 6 Stunden, danach 24 Stunden;
- manuelle Prüfung ignoriert Intervall und Cooldown;
- `ETag`/`Last-Modified` und SHA-256 schützen Downloads;
- validierte Daten werden in einer Drift-Transaktion aktiviert;
- einzelne Bildfehler ergeben ein partielles Update und dauerhafte Wiederholung;
- jedes Bild ist auf 4 MiB begrenzt;
- Cleanup entfernt nur veraltete Generationen und behält aktive/vorherige Daten.

Sync-Metadaten speichern letzte Prüfung und letzte erfolgreiche Aktualisierung.
Ältere Datenbanken mit doppelten Metadatenzeilen werden beim Lesen eindeutig
repariert.

## Prüfungsregeln

`LebenInDeutschlandExamRules` definiert 30 allgemeine und 3 Fragen des gewählten
Bundeslandes, insgesamt 33, bei 60 Minuten. Für LiD sind 15, für den
Einbürgerungsnachweis 17 richtige Antworten erforderlich.

## Drift im Web

`web/sqlite3.wasm` und `web/drift_worker.js` müssen zur Drift-Version passen.
Hosting muss WASM als `application/wasm` ausliefern, Web Worker zulassen und für
OPFS HTTPS verwenden. Mit Web-Release-Build und Chrome-Media-Store-Test prüfen.
