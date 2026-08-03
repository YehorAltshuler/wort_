# Leben in Deutschland

## Архитектура

UI читает каталог только из локальной Drift-базы. Remote JSON и изображения
используются только `CitizenshipTestRepository` во время синхронизации.

Единственный внешний источник приложения — опубликованный
[`bamf-lid-dataset`](https://github.com/YehorAltshuler/bamf-lid-dataset):

- `https://yehoraltshuler.github.io/bamf-lid-dataset/manifest.json`;
- `questions.json`, указанный в manifest;
- изображения из versioned paths, указанных в вопросах.

Приложение не загружает и не разбирает сайт BAMF, PDF или legacy JSON. Проверка
и подготовка исходных материалов выполняется вне приложения в dataset-проекте.

```text
UI → Riverpod → CitizenshipTestRepository
                    ├── DriftCitizenshipTestClient
                    ├── HttpCitizenshipTestClient
                    └── CitizenshipTestMediaStore
```

Контракты находятся в `citizenship_test_client`, domain и sync policy — в
`citizenship_test_repository`, реализации — в `drift_citizenship_test_client`
и `http_citizenship_test_client`.

## Локальные данные

Drift хранит поколения `staging`, `active`, `previous`, `obsolete`, вопросы,
media metadata, sync metadata, прогресс и экзаменационные сессии. Прогресс не
имеет внешнего ключа с каскадным удалением на каталог.

На Android и iOS изображения находятся в versioned-папках Application Support.
На Web они хранятся в browser Cache Storage. В Drift нет BLOB изображений.

Bundled snapshot находится в `assets/citizenship_test` и импортируется только
при пустой базе. Snapshot — точная локальная копия опубликованного manifest,
460 вопросов и 100 image-файлов; SHA-256 проверяется при импорте.

## Синхронизация

- автоматическая проверка выполняется при запуске и foreground не чаще одного
  раза за 15 дней;
- после ошибок действует cooldown 1 час, 6 часов, затем 24 часа;
- ручная проверка игнорирует интервал и cooldown;
- сначала загружается manifest с ETag и Last-Modified, затем указанный в нём
  `questions.json`, SHA-256 которого обязательно проверяется;
- новый набор активируется одной Drift-транзакцией;
- отдельные ошибки изображений дают partial update и persistent retry;
- cleanup удаляет только `obsolete`, сохраняя `active` и `previous`.

## Экзамен

Правила централизованы в `LebenInDeutschlandExamRules`: 30 общих вопросов,
3 вопроса выбранной земли, всего 33, время 60 минут. Порог теста LiD — 15,
порог подтверждения для гражданства — 17 правильных ответов.

## Drift Web

В `web/` должны присутствовать совместимые с текущим Drift файлы:

```text
web/sqlite3.wasm
web/drift_worker.js
```

Запуск и проверка:

```bash
flutter run -d chrome
flutter build web
(cd packages/drift_citizenship_test_client && \
  flutter test --platform chrome test/web_media_store_test.dart)
```

Hosting должен отдавать `.wasm` с MIME type `application/wasm`, не блокировать
Web Workers и работать через HTTPS, чтобы браузер мог использовать OPFS.

## Публикация dataset

Обновления публикуются только через `bamf-lid-dataset`. При переносе hosting
следует сохранить контракт manifest и атомарно публиковать manifest последним,
после `questions.json` и всех изображений. URL manifest меняется в одном месте —
`HttpCitizenshipTestClient`; fallback на сторонние наборы не предусмотрен.
