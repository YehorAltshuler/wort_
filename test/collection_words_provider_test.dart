import 'package:collections_repository/collections_repository.dart';
import 'package:course_repository/course_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/collections/provider/collections_provider.dart';
import 'package:wort_flutter/dictionary/provider/noun_gender_provider.dart';

void main() {
  test(
    'maps course and dictionary favorites to shared training words',
    () async {
      final collections = _MockCollectionsRepository();
      final courses = _MockCourseRepository();
      final lexicon = _MockLexiconRepository();
      when(collections.getCollections).thenAnswer(
        (_) async => const [
          WordCollection(
            id: WordCollection.favoritesId,
            name: 'Favorites',
            wordIds: ['book:module.json:0', 'lexicon:haus'],
            isFavorites: true,
          ),
        ],
      );
      when(
        () => courses.getModuleWords(
          bookId: 'book',
          moduleFile: 'module.json',
        ),
      ).thenAnswer(
        (_) async => const [
          CourseWord(
            id: 'book:module.json:0',
            type: CourseWordType.verb,
            term: 'gehen',
            translations: {
              'ru': ['идти'],
            },
          ),
        ],
      );
      when(() => lexicon.getById('haus')).thenAnswer(
        (_) async => const Lexeme(
          id: 'haus',
          lemma: 'Haus',
          normalized: 'haus',
          partOfSpeech: PartOfSpeech.noun,
          frequencyRank: 1,
          senses: [
            LexicalSense(definitions: {'ru': 'дом'}),
          ],
        ),
      );
      final container = ProviderContainer(
        overrides: [
          collectionsRepositoryProvider.overrideWithValue(collections),
          courseRepositoryProvider.overrideWithValue(courses),
          lexiconRepositoryProvider.overrideWithValue(lexicon),
          nounGenderIndexProvider.overrideWith(
            (ref) async => {
              'haus': ['das'],
            },
          ),
        ],
      );
      addTearDown(container.dispose);

      final words = await container.read(
        collectionWordsProvider(WordCollection.favoritesId).future,
      );

      expect(words, hasLength(2));
      expect(words.first.type, CourseWordType.verb);
      expect(words.last.type, CourseWordType.noun);
      expect(words.last.article, ['das']);
      expect(words.last.translationsFor('ru'), ['дом']);
    },
  );
}

class _MockCollectionsRepository extends Mock
    implements CollectionsRepository {}

class _MockCourseRepository extends Mock implements CourseRepository {}

class _MockLexiconRepository extends Mock implements LexiconRepository {}
