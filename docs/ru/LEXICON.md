# Словарь

[English](../en/LEXICON.md) · [Deutsch](../de/LEXICON.md)

## Обзор

Словарь содержит 29 599 немецких слов. UI и Riverpod работают с единым
`LexiconRepository`, а способ получения данных зависит от платформы.

```text
DictionaryPage
  → DictionaryNotifier
    → LexiconRepository
      → LexiconClient
        → SQLite + Drift      Android / iOS
        → HTTP JSON           Web
```

## Поиск

Ранжирование совпадает с Expo-версией:

1. точное совпадение;
2. слово начинается с запроса;
3. запрос находится внутри слова;
4. внутри группы используется `frequencyRank`.

Web использует prefix search для запросов длиной один-два символа и trigram
index для более длинных запросов. Native выполняет эквивалентный SQL-запрос к
таблице `lexeme_search`.

Riverpod provider добавляет debounce 250 мс и request ID. Debounce не запускает
поиск после каждого быстро введённого символа, а request ID не позволяет старому
асинхронному результату заменить новый.

## Native: SQLite

Исходная база находится в:

```text
assets/native/lexicon.db
```

Она объявлена flavor-specific asset `native`, поэтому не попадает в Web build.
При первом запуске `SqliteLexiconClient` копирует её в application support
directory и открывает через Drift в background isolate.

Основные таблицы:

```text
lexeme_search  # быстрые краткие результаты
lexemes        # полная карточка слова
```

Android и iOS собираются с `--flavor native`.

## Web: HTTP JSON

Web-данные находятся в:

```text
web/lexicon/index.json
web/lexicon/search-index.json
web/lexicon/details/000.json ... 127.json
```

`index.json` содержит краткие записи. `search-index.json` содержит trigram index.
Полные карточки разделены на 128 shards.

Номер shard вычисляется из нормализованного ID слова с помощью FNV-1a hash:

```text
haus → hash → shard number → details/XXX.json
```

После выбора слова браузер загружает только один нужный shard. Загруженные
индексы и shards кэшируются внутри `WebLexiconClient`.

Файлы находятся в Web static directory, а не во Flutter assets. Поэтому SQLite
не попадает в Web output, а JSON shards не попадают в APK и iOS app bundle.

## Карточка слова

Маршрут:

```text
/dictionary/word/:id
```

Карточка отображает:

- артикль и lemma одной естественной строкой, а также часть речи;
- произношение;
- локализованные значения;
- примеры;
- формы;
- этимологию;
- действия для перехода к внешним словарным ресурсам, включая DWDS.

Frequency rank намеренно не отображается в интерфейсе.

Сейчас UI сначала использует русскую локализацию и затем немецкий fallback.
После подключения app localization язык будет браться из настроек.

## Обновление данных

Словарные файлы пока генерируются скриптами Expo-проекта. После обновления
исходных данных нужно синхронизировать Flutter-копии:

```bash
cp assets/data/lexicon.db flutter_app/assets/native/lexicon.db
cp src/data/lexicon/index.json flutter_app/web/lexicon/index.json
cp src/data/lexicon/search-index.json flutter_app/web/lexicon/search-index.json
cp public/lexicon/details/*.json flutter_app/web/lexicon/details/
```

После синхронизации обязательно запустить client tests и platform builds.

## Дальнейшие улучшения

- перенести генерацию словаря в общий tool package;
- добавить manifest с версией данных и checksum;
- настроить CDN cache headers для Web shards;
- добавить обновление bundled DB при изменении версии словаря;
- измерить время первого поиска и размер release-артефактов.
