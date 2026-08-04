# wort_ architecture

[Deutsch](../de/ARCHITECTURE.md) · [Русский](../ru/ARCHITECTURE.md)

## Overview

wort_ is a Flutter application for German vocabulary, course-based learning,
exercises, and **Leben in Deutschland** (LiD). It uses Riverpod for state,
GoRouter for navigation, Drift for persistent offline data, and `http` for LiD
dataset updates.

```text
lib/                    application UI and feature layer
  app/                  composition root, providers, routes
  learning/             course books, modules, word sessions
  dictionary/           dictionary search
  word_details/         word detail screen
  collections/          favorites and custom lists
  exercises/            focused exercises
  citizenship_test/     Leben in Deutschland
  settings/             user preferences
  widgets/              shared UI components
packages/               independent data/domain packages
assets/                 bundled courses, exercises, LiD snapshot, branding
web/                    loader, PWA metadata, Drift worker, Web lexicon
```

## Layers and dependencies

Feature folders contain views, Riverpod providers, and small domain models.
Widgets never access storage or HTTP directly. Providers receive repositories
from `lib/app/provider/repository_providers.dart`.

The dependency direction is:

```text
UI → provider → repository interface → client interface → implementation
```

Concrete SQLite, Drift, HTTP, and preferences implementations are connected only
in the composition root. Local packages keep dictionary, collections, settings,
course progress, and LiD responsibilities separate.

## Navigation and responsive UI

Routes are defined in `lib/app/router/app_routes.dart` and configured in
`app_router.dart`. Root destinations live in a `PageView`; navigation changes
pages with animation while feature routes use GoRouter.

Shared UI building blocks live in `lib/widgets/`. `ResponsiveContent` limits
body content to a readable 960 px width. Text size is a user preference layered
on top of the unchanged Material default type scale. Selection flows use a
shared modal bottom-sheet shell. `AdaptiveStatCardRow` changes card height—not
their intended width—at wide breakpoints. Training screens share answer,
content, and bottom-action components.

## Persistence

- native dictionary data is shipped as SQLite; Web uses indexed JSON shards;
- courses and exercises are bundled assets;
- settings and lightweight learning progress use shared preferences;
- collections use a dedicated Drift database;
- LiD questions, progress, favorites, answers, and sessions use Drift.

LiD exam and all-question sessions are resumable after closing the app. The
repository stores the queue, current position, and exam answers independently
from the replaceable question catalog.

## LiD synchronization

The bundled snapshot initializes an empty database. Later, the repository can
compare it with the published `bamf-lid-dataset`. Dataset generations move
through `staging → active → previous → obsolete`; activation is atomic and only
happens after validation. A failed image keeps the text catalog usable and is
retried separately. Images are stored outside Drift as versioned files or Web
cache entries; Drift contains metadata and local keys.

## Adding a feature

1. Add a feature folder with views and providers.
2. Define repository/client contracts before adding storage or networking.
3. Keep asynchronous work and mutations outside widget `build` methods.
4. Reuse existing layout, selection, answer, and action widgets.
5. Add routes, localized strings, and tests for the changed layer.
