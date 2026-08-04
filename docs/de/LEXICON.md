# Wörterbuch

[English](../en/LEXICON.md) · [Русский](../ru/LEXICON.md)

## Überblick

Das Wörterbuch enthält 29.599 deutsche Einträge hinter einem gemeinsamen
`LexiconRepository`. Die Speicherung hängt von der Plattform ab:

```text
DictionaryPage → DictionaryNotifier → LexiconRepository → LexiconClient
                                                        ├─ SQLite/Drift (nativ)
                                                        └─ HTTP JSON (Web)
```

Die Suche ordnet exakte Treffer, Präfixe und Teiltreffer und nutzt danach den
Häufigkeitsrang. Riverpod ergänzt 250 ms Debounce und Request-IDs, damit ältere
asynchrone Ergebnisse keine neueren ersetzen.

## Native Plattformen

`assets/native/lexicon.db` ist ein Flavor-spezifisches Asset. Beim ersten Start
kopiert `SqliteLexiconClient` die Datei nach Application Support und öffnet sie
mit Drift in einem Hintergrund-Isolate. `lexeme_search` liefert kompakte Treffer,
`lexemes` vollständige Einträge. Android und iOS benötigen `--flavor native`.

## Web

Der Web-Client lädt `web/lexicon/index.json`, `search-index.json` und einen von
128 `details/XXX.json`-Shards. Kurze Abfragen verwenden Präfixsuche, längere den
Trigrammindex. Details werden erst nach Auswahl eines Wortes geladen; Indizes und
Shards werden in `WebLexiconClient` zwischengespeichert.

## Wortdetails

`/dictionary/word/:id` zeigt Artikel und Lemma als natürliche gemeinsame
Überschrift, Wortart, Aussprache, lokalisierte Bedeutungen, Beispiele, Formen und
Etymologie. Der Häufigkeitsrang wird bewusst nicht angezeigt. Aktionen führen zu
externen Sprachressourcen wie DWDS.

## Daten aktualisieren

Die Wörterbuchartefakte werden weiterhin von Skripten des früheren Expo-Projekts
erzeugt. Nach einer Neugenerierung müssen native Datenbank und Web-JSON
synchronisiert und anschließend Clienttests sowie Plattform-Builds ausgeführt
werden. Langfristig sollte ein gemeinsames Tool Generierung, Versions-/Prüfsummen-
Manifest und Größenmessung übernehmen.
