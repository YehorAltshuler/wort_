import 'package:collections_repository/collections_repository.dart';
import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/app/router/app_routes.dart';
import 'package:wort_flutter/app/view/app.dart';
import 'package:wort_flutter/content/content_provider.dart';
import 'package:wort_flutter/content/content_repository.dart';
import 'package:wort_flutter/widgets/training_progress_indicator.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(AppLanguage.english);
    registerFallbackValue(const LearningProgress());
  });

  testWidgets('shows the primary application sections', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final repository = _MockLexiconRepository();
    final courseRepository = _MockCourseRepository();
    final collectionsRepository = _MockCollectionsRepository();
    final settingsRepository = _MockSettingsRepository();
    final progressRepository = _MockLearningProgressRepository();
    final contentRepository = _MockContentRepository();
    when(
      () => contentRepository.loadExercise(any()),
    ).thenAnswer((_) async => null);
    when(
      contentRepository.loadMetadata,
    ).thenAnswer((_) async => const ContentSyncMetadata());
    when(progressRepository.load).thenAnswer(
      (_) async => const LearningProgress(),
    );
    when(
      () => progressRepository.recordResult(
        current: any(named: 'current'),
        wordId: any(named: 'wordId'),
        correct: any(named: 'correct'),
      ),
    ).thenAnswer((invocation) async {
      return invocation.namedArguments[#current]! as LearningProgress;
    });
    when(
      () => settingsRepository.load(
        fallbackLanguage: any(named: 'fallbackLanguage'),
      ),
    ).thenAnswer(
      (_) async => const AppSettings(
        language: AppLanguage.russian,
        nativeLanguage: NativeLanguage.russian,
        theme: ThemePreference.system,
      ),
    );
    when(
      () => repository.search(any(), limit: any(named: 'limit')),
    ).thenAnswer(
      (_) async => const [
        Lexeme(
          id: 'haus',
          lemma: 'Haus',
          normalized: 'haus',
          partOfSpeech: PartOfSpeech.noun,
          frequencyRank: 42,
        ),
      ],
    );
    when(courseRepository.getBooks).thenAnswer(
      (_) async => const [
        CourseBook(
          id: 'book',
          title: 'Testbuch A1',
          level: 'A1',
          modules: [
            CourseModule(id: 1, title: 'Modul 1: Hallo', file: 'module1.json'),
          ],
        ),
        CourseBook(
          id: AppRoute.lidVocabularyBookId,
          title: 'Leben in Deutschland',
          level: 'LiD',
          modules: [
            CourseModule(
              id: 1,
              title: 'Modul 1: Grundrechte und Demokratie',
              file: 'module0.json',
            ),
          ],
        ),
      ],
    );
    when(collectionsRepository.getCollections).thenAnswer(
      (_) async => const [
        WordCollection(
          id: WordCollection.favoritesId,
          name: 'Favorites',
          wordIds: ['book:module1.json:0'],
          isFavorites: true,
        ),
      ],
    );
    when(
      () => collectionsRepository.toggleWord(any(), any()),
    ).thenAnswer((_) async {});
    when(
      () => collectionsRepository.createList(any()),
    ).thenAnswer((_) async => 'new-list');
    when(
      () => courseRepository.getModuleWords(
        bookId: any(named: 'bookId'),
        moduleFile: any(named: 'moduleFile'),
      ),
    ).thenAnswer(
      (_) async => const [
        CourseWord(
          id: 'book:module1.json:0',
          type: CourseWordType.noun,
          term: 'Haus',
          article: ['das'],
          translations: {
            'ru': ['дом'],
          },
        ),
        CourseWord(
          id: 'book:module1.json:1',
          type: CourseWordType.verb,
          term: 'gehen',
          translations: {
            'ru': ['идти'],
          },
        ),
      ],
    );
    when(() => repository.getById('haus')).thenAnswer(
      (_) async => const Lexeme(
        id: 'haus',
        lemma: 'Haus',
        normalized: 'haus',
        partOfSpeech: PartOfSpeech.noun,
        frequencyRank: 42,
        pronunciation: ['haʊ̯s'],
        senses: [
          LexicalSense(
            definitions: {'ru': 'дом'},
            examples: ['Das ist mein Haus.'],
          ),
        ],
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lexiconRepositoryProvider.overrideWithValue(repository),
          courseRepositoryProvider.overrideWithValue(courseRepository),
          collectionsRepositoryProvider.overrideWithValue(
            collectionsRepository,
          ),
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          learningProgressRepositoryProvider.overrideWithValue(
            progressRepository,
          ),
          contentBootstrapProvider.overrideWith((ref) async {}),
          contentRepositoryProvider.overrideWithValue(contentRepository),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    tester.view.physicalSize = const Size(400, 800);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);

    expect(find.text('Учёба'), findsOneWidget);
    expect(find.text('Словарь'), findsOneWidget);
    expect(find.text('Мои слова'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Учебники'), findsOneWidget);
    expect(find.text('Упражнения'), findsOneWidget);
    expect(find.text('Leben in Deutschland'), findsOneWidget);

    await tester.tap(find.text('Мои слова'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Избранное').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Слова'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.folder_special));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Избранное').last);
    await tester.pumpAndSettle();
    verify(
      () => collectionsRepository.toggleWord(
        WordCollection.favoritesId,
        'book:module1.json:0',
      ),
    ).called(1);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Новый список'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Test list');
    await tester.tap(find.text('Создать'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    verify(() => collectionsRepository.createList('Test list')).called(1);

    await tester.tap(find.text('Учёба'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Упражнения'));
    await tester.pumpAndSettle();
    expect(find.text('Verben mit festen Präpositionen'), findsOneWidget);
    await tester.tap(find.text('Verben mit festen Präpositionen'));
    await tester.pumpAndSettle();
    expect(find.text('Прогресс обучения'), findsOneWidget);
    expect(find.text('Verben mit festen Präpositionen'), findsOneWidget);
    expect(find.text('Правильные ответы'), findsOneWidget);
    expect(find.text('Неправильно'), findsOneWidget);
    for (final key in const [
      ValueKey('exercise-all-stat'),
      ValueKey('exercise-correct-stat'),
      ValueKey('exercise-incorrect-stat'),
    ]) {
      expect(
        find.descendant(of: find.byKey(key), matching: find.byType(InkWell)),
        findsNothing,
      );
    }
    expect(find.text('Akkusativ'), findsNothing);
    expect(find.text('Dativ'), findsNothing);
    expect(find.text('Настроить тренировку'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Leben in Deutschland'));
    await tester.pumpAndSettle();
    expect(find.text('Тест LiD'), findsOneWidget);
    expect(find.text('Лексика LiD'), findsOneWidget);
    await tester.tap(find.text('Лексика LiD'));
    await tester.pumpAndSettle();
    expect(find.text('Grundrechte und Demokratie'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Учебники'));
    await tester.pumpAndSettle();
    expect(find.text('Testbuch A1'), findsOneWidget);

    await tester.tap(find.text('Testbuch A1'));
    await tester.pumpAndSettle();
    expect(find.text('Modul 1'), findsOneWidget);
    expect(find.text('Hallo'), findsOneWidget);

    await tester.tap(find.text('Hallo'));
    await tester.pumpAndSettle();
    expect(find.text('Прогресс обучения'), findsOneWidget);

    await tester.tap(find.text('Существительные'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Слова'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Слова'));
    await tester.pumpAndSettle();
    expect(find.text('Существительные'), findsOneWidget);
    expect(find.text('Haus'), findsOneWidget);
    expect(find.text('gehen'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Настроить тренировку'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Начать тренировку'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(TrainingProgressIndicator),
      ),
      findsOneWidget,
    );
    final detailsButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'О слове'),
    );
    final continueButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Продолжить'),
    );
    expect(detailsButton.onPressed, isNull);
    expect(continueButton.onPressed, isNull);

    await tester.tap(find.text('дом'));
    await tester.pumpAndSettle();
    expect(find.text('Правильно'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Продолжить'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Словарь'));
    await tester.pumpAndSettle();

    expect(find.text('Поиск'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'haus');
    await tester.pumpAndSettle();

    expect(find.text('Haus'), findsWidgets);

    await tester.tap(find.text('Haus').first);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('дом'), findsOneWidget);
    expect(find.text('Das ist mein Haus.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Словарные источники'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.widgetWithText(OutlinedButton, 'Wiktionary'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'DWDS'), findsOneWidget);
  });
}

class _MockLexiconRepository extends Mock implements LexiconRepository {}

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _MockCourseRepository extends Mock implements CourseRepository {}

class _MockCollectionsRepository extends Mock
    implements CollectionsRepository {}

class _MockLearningProgressRepository extends Mock
    implements LearningProgressRepository {}

class _MockContentRepository extends Mock implements ContentRepository {}
