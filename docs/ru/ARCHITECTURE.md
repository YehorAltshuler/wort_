# Архитектура wort_

[English](../en/ARCHITECTURE.md) · [Deutsch](../de/ARCHITECTURE.md)

## Обзор

`wort_` — Flutter-приложение для немецкой лексики, обучения по учебникам,
упражнений и теста **Leben in Deutschland**. Проект использует package-based
структуру, Riverpod для состояния, GoRouter для навигации, Drift для
offline-first данных теста и `http` для его обновления.

```text
lib/                         Flutter UI и feature-слой
  app/                       composition root, providers и маршруты
  learning/                  учебники, модули и тренировка слов
  dictionary/                поиск словаря
  word_details/              карточка слова
  collections/               «Мои слова» и пользовательские списки
  exercises/                 упражнения
  citizenship_test/          Leben in Deutschland
  settings/                  настройки приложения
  widgets/                   общие UI-компоненты
packages/                    независимые data/domain-пакеты
assets/                      словарь, учебники, упражнения, LiD snapshot и бренд
web/                         HTML loader, PWA-метаданные и иконки
```

## Слои и зависимости

### UI и состояние

Feature-папки в `lib/` организованы по назначению:

- `view/` содержит экраны и feature-specific виджеты;
- `provider/` содержит Riverpod providers, `Notifier` и `AsyncNotifier`;
- `domain/` содержит небольшие UI-модели и правила feature-слоя;
- `lib/widgets/` хранит визуально переиспользуемые компоненты.

Виджеты получают состояние через Riverpod и не обращаются к хранилищу или сети
напрямую. Провайдеры используют репозитории из
`lib/app/provider/repository_providers.dart`.

### Репозитории и клиенты

Каждый пакет имеет одну ответственность:

| Пакет | Ответственность |
| --- | --- |
| `asset_course_client` | читает учебники и модули из Flutter assets |
| `course_repository` | предоставляет учебники и слова модулей |
| `lexicon_client`, `lexicon_repository` | контракт и API словаря |
| `sqlite_lexicon_client` | нативный SQLite-словарь |
| `web_lexicon_client` | словарь из разделённых JSON-shards для Web |
| `collections_client`, `collections_repository` | пользовательские списки и избранное |
| `drift_collections_client` | постоянное хранилище списков |
| `preferences_client`, `settings_repository` | настройки через `SharedPreferencesAsync` |
| `learning_progress_repository` | прогресс учебных модулей |
| `citizenship_test_client` | контракт локального хранилища LiD |
| `drift_citizenship_test_client` | Drift-реализация вопросов, сессий, прогресса и media metadata |
| `http_citizenship_test_client` | загрузка manifest и вопросов LiD через `http` |
| `citizenship_test_repository` | offline-first синхронизация, сессии и прогресс LiD |

Правило зависимостей: UI зависит от repository API, repository — от client API,
а конкретные реализации подключаются только в composition root. Не добавляйте
сеть, Drift или platform checks в `view/`.

## Навигация

`go_router` настроен в `lib/app/router/app_router.dart`.

- корневые вкладки открывают `NavigationPage` без анимации;
- feature routes передают только простые path/query параметры;
- маршрут — источник состояния навигации, а не ручные `Navigator.push` внутри
  бизнес-логики.

Все новые маршруты сначала добавляйте в `lib/app/router/app_routes.dart`, затем
в конфигурацию `GoRouter`.

## Хранение данных

### Словарь, учебники и пользовательские данные

- Android/iOS используют поставляемую SQLite-базу словаря;
- Web загружает словарь по shards и кэширует запросы на уровне клиента;
- учебники и упражнения поставляются как assets;
- настройки и лёгкий прогресс хранятся через shared preferences;
- пользовательские списки имеют отдельное Drift-хранилище.

### Leben in Deutschland

LiD всегда читает вопросы из локальной Drift-базы. При первом запуске в базу
импортируется bundled snapshot. После этого repository может неблокирующе
сверить данные с опубликованным dataset `bamf-lid-dataset`.

Синхронизация использует manifest/questions endpoint, conditional HTTP
(`ETag`/`Last-Modified`, если доступны), ограничение повторных попыток и
поколения dataset:

```text
staging -> active -> previous -> obsolete
```

Новая версия полностью валидируется до одной транзакции активации. Ошибка сети,
парсинга или одной картинки не заменяет активный текстовый набор. Прогресс,
избранное, экзаменационные сессии и ответы хранятся отдельно и ссылаются на
upstream `questionId`; очистка каталога не удаляет их каскадно.

Изображения не являются BLOB в Drift. На native они лежат в versioned файловом
хранилище, на Web — в эквивалентном persistent media store; Drift хранит только
метаданные и локальный ключ. Активное и предыдущее поколения сохраняются до
отдельной cleanup-операции.

## Тема, локализация и адаптивность

- тема Material 3 задаётся в `lib/theme/wort_theme.dart`;
- палитры `pink`, `azure`, `lime` строятся из seed, monochrome определена
  вручную;
- HTML loading screen в `web/index.html` читает сохранённые тему и палитру,
  чтобы не мигать противоположным фоном до первого Flutter frame;
- строки генерируются из `lib/l10n/`, поддерживаются русский, английский и
  арабский;
- адаптивная компоновка использует Flutter layout widgets и breakpoints,
  а не отдельную Web-ветку UI.
- `ResponsiveContent` ограничивает body шириной 960 px, настройка размера
  текста накладывается поверх неизменённой стандартной шкалы Material;
- выбор значений выполняется через общий modal bottom sheet, а тренировочные
  экраны переиспользуют общие виджеты вопросов, ответов и нижних действий.

Экзаменационные и «все вопросы» сессии LiD сохраняют очередь и текущую позицию
и могут быть продолжены после закрытия приложения. Экзамен также сохраняет
выбранные ответы.

## Как добавлять feature

1. Создайте feature-папку в `lib/<feature>/` с `view/`, `provider/` и при
   необходимости `domain/`.
2. Если нужен доступ к данным, сначала определите интерфейс client/repository в
   `packages/`, затем подключите реализацию в repository providers.
3. Держите виджеты декларативными: асинхронная работа и мутации — в notifier
   или repository.
4. Добавьте route, локализованные строки и тесты рядом с изменённым слоем.
5. Не добавляйте глобальный state manager, HTTP-клиент или database package,
   если текущие Riverpod, `http` и Drift покрывают задачу.
