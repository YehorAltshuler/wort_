import 'package:collections_repository/collections_repository.dart';
import 'package:course_repository/course_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexicon_repository/lexicon_repository.dart';
import 'package:riverpod/misc.dart' show FutureProviderFamily;
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/dictionary/provider/noun_gender_provider.dart';

final collectionsProvider =
    AsyncNotifierProvider<CollectionsNotifier, List<WordCollection>>(
      CollectionsNotifier.new,
    );

class CollectionsNotifier extends AsyncNotifier<List<WordCollection>> {
  CollectionsRepository get _repository =>
      ref.read(collectionsRepositoryProvider);

  @override
  Future<List<WordCollection>> build() => _repository.getCollections();

  Future<void> createList(String name) async {
    await _mutate(() => _repository.createList(name));
  }

  Future<void> createListWithWord(String name, String wordId) async {
    await _mutate(() async {
      final id = await _repository.createList(name);
      if (id != null) await _repository.toggleWord(id, wordId);
    });
  }

  Future<void> renameList(String id, String name) async {
    await _mutate(() => _repository.renameList(id, name));
  }

  Future<void> deleteList(String id) async {
    await _mutate(() => _repository.deleteList(id));
  }

  Future<void> toggleWord(String collectionId, String wordId) async {
    await _mutate(() => _repository.toggleWord(collectionId, wordId));
  }

  Future<void> _mutate(Future<void> Function() operation) async {
    try {
      await operation();
      state = AsyncData(await _repository.getCollections());
    } on Object catch (error, stackTrace) {
      state = AsyncError<List<WordCollection>>(error, stackTrace);
    }
  }
}

extension CollectionsValueX on List<WordCollection> {
  WordCollection? byId(String id) {
    for (final collection in this) {
      if (collection.id == id) return collection;
    }
    return null;
  }
}

class SavedWord {
  const SavedWord({
    required this.id,
    required this.term,
    required this.translations,
    required this.type,
    this.articles = const [],
    this.dictionaryId,
  });

  final String id;
  final String term;
  final Map<String, List<String>> translations;
  final CourseWordType type;
  final List<String> articles;
  final String? dictionaryId;

  String translationFor(String languageCode) =>
      (translations[languageCode] ?? translations['en'] ?? const []).join(', ');

  CourseWord toCourseWord() => CourseWord(
    id: id,
    dictionaryId: dictionaryId,
    type: type,
    term: term,
    translations: translations,
    article: articles,
  );
}

final FutureProviderFamily<SavedWord?, String> savedWordProvider =
    FutureProvider.family<SavedWord?, String>((ref, id) async {
      if (id.startsWith('lexicon:')) {
        final lexemeId = id.substring('lexicon:'.length);
        final lexeme = await ref
            .read(lexiconRepositoryProvider)
            .getById(lexemeId);
        if (lexeme == null) return null;
        final type = switch (lexeme.partOfSpeech) {
          PartOfSpeech.noun => CourseWordType.noun,
          PartOfSpeech.verb => CourseWordType.verb,
          PartOfSpeech.other => CourseWordType.other,
        };
        final genderIndex = type == CourseWordType.noun
            ? await ref.read(nounGenderIndexProvider.future)
            : const <String, List<String>>{};
        return SavedWord(
          id: id,
          term: lexeme.lemma,
          dictionaryId: lexeme.id,
          type: type,
          articles: nounArticles(genderIndex, lexeme.lemma),
          translations: _lexemeTranslations(lexeme),
        );
      }
      final parts = id.split(':');
      if (parts.length != 3) return null;
      final words = await ref
          .read(courseRepositoryProvider)
          .getModuleWords(
            bookId: parts[0],
            moduleFile: parts[1],
          );
      final index = int.tryParse(parts[2]);
      if (index == null || index < 0 || index >= words.length) return null;
      final word = words[index];
      return SavedWord(
        id: id,
        term: word.term,
        dictionaryId: word.dictionaryId,
        type: word.type,
        translations: word.translations,
        articles: word.article,
      );
    });

Map<String, List<String>> _lexemeTranslations(Lexeme lexeme) {
  final translations = <String, List<String>>{};
  void add(String language, Iterable<String> values) {
    final target = translations.putIfAbsent(language, () => []);
    for (final value in values) {
      if (value.isNotEmpty && !target.contains(value)) target.add(value);
    }
  }

  for (final sense in lexeme.senses) {
    for (final entry in sense.definitions.entries) {
      add(entry.key, [entry.value]);
    }
    for (final entry in sense.translations.entries) {
      add(entry.key, entry.value);
    }
  }
  for (final localization in lexeme.localizations.entries) {
    for (final sense in localization.value.senses) {
      add(localization.key, sense.definitions.values);
      add(localization.key, sense.translations[localization.key] ?? const []);
    }
  }
  return translations;
}

final FutureProviderFamily<List<CourseWord>, String> collectionWordsProvider =
    FutureProvider.family<List<CourseWord>, String>((ref, collectionId) async {
      final collections = await ref.watch(collectionsProvider.future);
      final collection = collections.byId(collectionId);
      if (collection == null) return const [];
      final words = await Future.wait([
        for (final id in collection.wordIds)
          ref.watch(savedWordProvider(id).future),
      ]);
      return [
        for (final word in words)
          if (word != null) word.toCourseWord(),
      ];
    });
