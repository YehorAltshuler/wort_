import 'package:collections_repository/collections_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart' show FutureProviderFamily;
import 'package:wort_flutter/app/provider/repository_providers.dart';

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
    this.articles = const [],
    this.dictionaryId,
  });

  final String id;
  final String term;
  final Map<String, List<String>> translations;
  final List<String> articles;
  final String? dictionaryId;

  String translationFor(String languageCode) =>
      (translations[languageCode] ?? translations['en'] ?? const []).join(', ');
}

final FutureProviderFamily<SavedWord?, String> savedWordProvider =
    FutureProvider.family<SavedWord?, String>((ref, id) async {
      if (id.startsWith('lexicon:')) {
        final lexemeId = id.substring('lexicon:'.length);
        final lexeme = await ref
            .read(lexiconRepositoryProvider)
            .getById(lexemeId);
        if (lexeme == null) return null;
        return SavedWord(
          id: id,
          term: lexeme.lemma,
          dictionaryId: lexeme.id,
          translations: {
            for (final entry in lexeme.localizations.entries)
              entry.key: [
                for (final sense in entry.value.senses)
                  for (final definition in sense.definitions.values) definition,
              ],
          },
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
        translations: word.translations,
        articles: word.article,
      );
    });
