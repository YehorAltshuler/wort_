import 'dart:convert';

import 'package:collections_client/collections_client.dart';
import 'package:preferences_client/preferences_client.dart';

class PreferencesCollectionsClient implements CollectionsClient {
  PreferencesCollectionsClient({PreferencesClient? preferences})
    : _preferences = preferences ?? PreferencesClient();

  static const _storageKey = 'wordCollections';
  final PreferencesClient _preferences;

  @override
  Future<List<CollectionRecord>> loadCollections() async {
    final state = await _load();
    return [
      CollectionRecord(
        id: 'favorites',
        name: 'Favorites',
        wordIds: state.favorites,
        isFavorites: true,
      ),
      ...state.lists.map(
        (list) => CollectionRecord(
          id: list.id,
          name: list.name,
          wordIds: list.wordIds,
          isFavorites: false,
        ),
      ),
    ];
  }

  @override
  Future<void> createList({required String id, required String name}) async {
    final state = await _load();
    await _save(
      state.copyWith(lists: [...state.lists, _StoredList(id, name, const [])]),
    );
  }

  @override
  Future<void> renameList({required String id, required String name}) async {
    final state = await _load();
    await _save(
      state.copyWith(
        lists: [
          for (final list in state.lists)
            if (list.id == id)
              _StoredList(list.id, name, list.wordIds)
            else
              list,
        ],
      ),
    );
  }

  @override
  Future<void> deleteList(String id) async {
    final state = await _load();
    await _save(
      state.copyWith(
        lists: state.lists.where((list) => list.id != id).toList(),
      ),
    );
  }

  @override
  Future<void> toggleWord({
    required String collectionId,
    required String wordId,
  }) async {
    final state = await _load();
    if (collectionId == 'favorites') {
      await _save(state.copyWith(favorites: _toggle(state.favorites, wordId)));
      return;
    }
    await _save(
      state.copyWith(
        lists: [
          for (final list in state.lists)
            if (list.id == collectionId)
              _StoredList(list.id, list.name, _toggle(list.wordIds, wordId))
            else
              list,
        ],
      ),
    );
  }

  Future<_StoredState> _load() async {
    final raw = await _preferences.readString(_storageKey);
    if (raw == null) return const _StoredState([], []);
    final json = jsonDecode(raw)! as Map<String, Object?>;
    final lists = (json['lists'] as List<Object?>? ?? const [])
        .cast<Map<String, Object?>>()
        .map(
          (list) => _StoredList(
            list['id']! as String,
            list['name']! as String,
            (list['wordIds']! as List<Object?>).cast<String>(),
          ),
        )
        .toList();
    return _StoredState(
      (json['favorites'] as List<Object?>? ?? const []).cast<String>(),
      lists,
    );
  }

  Future<void> _save(_StoredState state) {
    return _preferences.writeString(
      _storageKey,
      jsonEncode({
        'favorites': state.favorites,
        'lists': [
          for (final list in state.lists)
            {'id': list.id, 'name': list.name, 'wordIds': list.wordIds},
        ],
      }),
    );
  }

  static List<String> _toggle(List<String> ids, String id) => ids.contains(id)
      ? ids.where((value) => value != id).toList()
      : [...ids, id];
}

class _StoredState {
  const _StoredState(this.favorites, this.lists);

  final List<String> favorites;
  final List<_StoredList> lists;

  _StoredState copyWith({List<String>? favorites, List<_StoredList>? lists}) {
    return _StoredState(favorites ?? this.favorites, lists ?? this.lists);
  }
}

class _StoredList {
  const _StoredList(this.id, this.name, this.wordIds);

  final String id;
  final String name;
  final List<String> wordIds;
}
