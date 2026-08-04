# Dictionary

[Deutsch](../de/LEXICON.md) · [Русский](../ru/LEXICON.md)

## Overview

The dictionary contains 29,599 German entries behind one `LexiconRepository`.
The storage implementation depends on the platform:

```text
DictionaryPage → DictionaryNotifier → LexiconRepository → LexiconClient
                                                        ├─ SQLite/Drift (native)
                                                        └─ HTTP JSON (Web)
```

Search ranks exact matches, prefixes, and substring matches, then uses frequency
rank within each group. Riverpod applies a 250 ms debounce and request IDs to
prevent stale asynchronous results from replacing newer searches.

## Native

`assets/native/lexicon.db` is a flavor-specific asset. On first launch,
`SqliteLexiconClient` copies it to Application Support and opens it with Drift
in a background isolate. `lexeme_search` serves compact results and `lexemes`
stores full records. Android and iOS must be built with `--flavor native`.

## Web

The Web client loads `web/lexicon/index.json`, `search-index.json`, and one of
128 `details/XXX.json` shards. One- and two-character queries use prefix search;
longer queries use the trigram index. Full details are fetched only after a word
is selected, and loaded indexes/shards are cached by `WebLexiconClient`.

## Word details

`/dictionary/word/:id` displays the article and lemma as one natural heading,
part of speech, pronunciation, localized meanings, examples, forms, and
etymology. Frequency rank is intentionally not shown. Actions link to external
lexical resources such as DWDS.

## Updating the data

Dictionary artifacts are still produced by the former Expo project's scripts.
After regenerating them, synchronize the native database and Web JSON files,
then run client tests and both platform builds. A future shared tool should own
generation, version/checksum manifests, and artifact-size measurements.
