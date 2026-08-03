# Архитектура

## Основа

Проект следует layered architecture от Very Good Ventures. Вместо Bloc в
business logic layer используется Riverpod.

```text
Presentation → Business logic → Repository → Data client
Flutter UI      Riverpod          Pure Dart    SQLite / HTTP / plugins
```

Каждый слой может обращаться только к соседнему нижнему слою. Детали SQLite,
HTTP и платформенных API не должны попадать в provider или widget.

## Структура

```text
lib/
├── app/
│   ├── provider/       # composition root и repository providers
│   ├── router/         # go_router и пути
│   └── view/           # MaterialApp
├── <feature>/
│   ├── provider/       # Riverpod state и feature logic
│   └── view/           # страницы и widgets
├── theme/
└── widgets/

packages/
├── asset_course_client/    # JSON assets учебников для всех платформ
├── course_client/          # абстрактный contract учебных данных
├── course_repository/      # модели учебников, модулей и слов
├── citizenship_test_client/ # local/remote/media контракты LiD
├── citizenship_test_repository/ # offline-first, экзамен и прогресс LiD
├── drift_citizenship_test_client/ # Drift + native/Web media
├── http_citizenship_test_client/ # remote JSON и изображения
├── lexicon_client/         # абстрактный data contract
├── lexicon_repository/     # модели и правила словаря
├── learning_progress_repository/ # Expo-compatible progress persistence
├── preferences_client/     # SharedPreferences data client
├── settings_repository/    # язык и тема приложения
├── sqlite_lexicon_client/  # Drift/SQLite для Android и iOS
└── web_lexicon_client/     # HTTP JSON для Web
```

Новый package создаётся только для самостоятельного data или repository слоя.
Небольшие presentation-компоненты остаются в основном приложении.

## Ответственность слоёв

### Presentation

- содержит Flutter widgets и управление их lifecycle;
- читает состояние Riverpod;
- передаёт пользовательские события provider;
- может содержать layout, animation и простую routing logic;
- не выполняет SQL, HTTP и преобразование domain data.

### Business logic

- реализована через `Notifier`, `AsyncNotifier` и другие Riverpod providers;
- хранит feature state;
- вызывает repositories;
- обрабатывает loading, success и error;
- не зависит от конкретного data client.

### Repository

- является источником domain data;
- преобразует raw records в domain models;
- применяет правила продукта;
- не импортирует Flutter;
- не зависит от других repositories.

### Data client

- получает сырые данные из SQLite, HTTP, файлов или platform plugins;
- не содержит feature logic;
- может зависеть от Flutter, если оборачивает Flutter platform API.

## Dependency injection

Composition root находится в `lib/app/provider`. Например, UI получает
`LexiconRepository`, не зная выбранный client:

```text
lexiconRepositoryProvider
  → createLexiconClient()
    → SqliteLexiconClient на native
    → WebLexiconClient на Web
```

Conditional imports находятся только в factory. Это не позволяет `dart:io`
попасть в Web-компиляцию.

Настройки проходят тот же путь: `PreferencesClient` изолирует platform plugin,
`SettingsRepository` хранит ключи и преобразует значения, а
`settingsProvider` предоставляет UI асинхронное состояние языка и темы.

## Навигация

`go_router` является единственным источником routing state. Корневые маршруты:

```text
/learning
/dictionary
/collections
/citizenship-test
/settings
/dictionary/word/:id
```

Пять корневых разделов отображаются через `PageView`. Нажатие на нижнее меню
меняет URL, а свайп `PageView` синхронизирует URL с текущей страницей.

Навигационное состояние не дублируется в Riverpod.

Учебный поток использует вложенные deep links `/learning/book/:bookId` и
`/learning/book/:bookId/module/:moduleFile`. Настройки занятия передаются query
parameters, а сами слова повторно берутся из repository provider.

Результат каждого ответа записывается через `learningProgressProvider` в ключ
`learningProgress`. Правильный ответ отмечает слово проверенным, неправильный
снимает отметку; module overview агрегирует эти ID по категориям слов.

## Правила для нового функционала

1. Начинать с domain model и repository API.
2. Изолировать источник данных в client package.
3. Предоставлять repository через Riverpod composition root.
4. Хранить feature state в provider.
5. Оставлять view декларативной.
6. Добавлять use case только для сложной переиспользуемой логики, объединяющей
   несколько repositories.
7. Тестировать каждый слой отдельно.
