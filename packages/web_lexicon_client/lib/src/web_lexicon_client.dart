import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lexicon_client/lexicon_client.dart';

class WebLexiconClient implements LexiconClient {
  WebLexiconClient({http.Client? httpClient, Uri? baseUri})
    : _httpClient = httpClient ?? http.Client(),
      _baseUri = baseUri ?? Uri.base.resolve('/');

  final http.Client _httpClient;
  final Uri _baseUri;
  Future<_SearchData>? _searchData;
  final Map<int, Future<Map<String, dynamic>>> _detailShards = {};

  @override
  Future<List<LexiconRecord>> search(String query, {int limit = 20}) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty || limit <= 0) return const [];

    final data = await (_searchData ??= _loadSearchData());
    final candidates = normalized.runes.length < 3
        ? data.findPrefixCandidates(normalized)
        : data.findTrigramCandidates(normalized);
    final matches =
        candidates
            .map((index) => data.entries[index])
            .where((entry) => entry.normalized.contains(normalized))
            .toList()
          ..sort((first, second) => _compare(first, second, normalized));
    return matches.take(limit).toList(growable: false);
  }

  @override
  Future<LexiconDetailsRecord?> getById(String id) async {
    final normalized = id.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    final shardId = _shardId(normalized);
    final shard = await (_detailShards[shardId] ??= _loadShard(shardId));
    final value = shard[normalized];
    if (value is! Map<String, dynamic>) return null;
    return _detailsFromJson(normalized, value);
  }

  Future<_SearchData> _loadSearchData() async {
    final responses = await Future.wait([
      _httpClient.get(_resolve('lexicon/index.json')),
      _httpClient.get(_resolve('lexicon/search-index.json')),
    ]);
    responses.forEach(_ensureSuccessful);
    return _SearchData.fromJson(responses[0].body, responses[1].body);
  }

  Future<Map<String, dynamic>> _loadShard(int shardId) async {
    final formattedId = shardId.toString().padLeft(3, '0');
    final response = await _httpClient.get(
      _resolve('lexicon/details/$formattedId.json'),
    );
    _ensureSuccessful(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Uri _resolve(String path) => _baseUri.resolve(path);

  static void _ensureSuccessful(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'Unable to load lexicon data (${response.statusCode})',
        response.request?.url,
      );
    }
  }

  static int _shardId(String value) {
    var hash = 2166136261;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }
    return hash % 128;
  }

  static int _compare(
    LexiconRecord first,
    LexiconRecord second,
    String query,
  ) {
    final priorityDifference =
        _priority(first.normalized, query) -
        _priority(second.normalized, query);
    return priorityDifference != 0
        ? priorityDifference
        : first.frequencyRank.compareTo(second.frequencyRank);
  }

  static int _priority(String value, String query) {
    if (value == query) return 0;
    if (value.startsWith(query)) return 1;
    return 2;
  }

  static LexiconDetailsRecord _detailsFromJson(
    String id,
    Map<String, dynamic> value,
  ) {
    final rawForms = value['forms'] as Map<String, dynamic>? ?? const {};
    return LexiconDetailsRecord(
      id: id,
      lemma: value['lemma']! as String,
      partOfSpeech: value['partOfSpeech'] as String? ?? 'other',
      frequencyRank: value['frequencyRank'] as int? ?? 0,
      pronunciation: (value['pronunciation'] as List<dynamic>? ?? const [])
          .cast<String>(),
      forms: rawForms.map(
        (key, forms) => MapEntry(key, (forms as List<dynamic>).cast<String>()),
      ),
      senses: (value['senses'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>(),
      etymology: value['etymology'] as String?,
      localizations:
          value['localizations'] as Map<String, dynamic>? ?? const {},
    );
  }
}

class _SearchData {
  const _SearchData({
    required this.entries,
    required this.grams,
    required this.sortedIds,
  });

  factory _SearchData.fromJson(String indexJson, String searchIndexJson) {
    final rawEntries = jsonDecode(indexJson) as List<dynamic>;
    final rawSearchIndex = jsonDecode(searchIndexJson) as Map<String, dynamic>;
    final rawGrams = rawSearchIndex['grams']! as Map<String, dynamic>;
    return _SearchData(
      entries: rawEntries
          .map((value) {
            final entry = value! as Map<String, dynamic>;
            return LexiconRecord(
              id: entry['id']! as String,
              lemma: entry['lemma']! as String,
              normalized: entry['normalized']! as String,
              partOfSpeech: entry['partOfSpeech']! as String,
              frequencyRank: entry['frequencyRank']! as int,
            );
          })
          .toList(growable: false),
      grams: rawGrams.map(
        (gram, ids) => MapEntry(gram, (ids! as List<dynamic>).cast<int>()),
      ),
      sortedIds: (rawSearchIndex['sortedIds']! as List<dynamic>).cast<int>(),
    );
  }

  final List<LexiconRecord> entries;
  final Map<String, List<int>> grams;
  final List<int> sortedIds;

  List<int> findPrefixCandidates(String query) {
    var low = 0;
    var high = sortedIds.length;
    while (low < high) {
      final middle = (low + high) ~/ 2;
      if (entries[sortedIds[middle]].normalized.compareTo(query) < 0) {
        low = middle + 1;
      } else {
        high = middle;
      }
    }
    final matches = <int>[];
    for (var position = low; position < sortedIds.length; position++) {
      final id = sortedIds[position];
      if (!entries[id].normalized.startsWith(query)) break;
      matches.add(id);
    }
    return matches;
  }

  List<int> findTrigramCandidates(String query) {
    final characters = query.runes.toList(growable: false);
    final queryGrams = [
      for (var index = 0; index <= characters.length - 3; index++)
        String.fromCharCodes(characters.sublist(index, index + 3)),
    ];
    final postingLists = <List<int>>[];
    for (final gram in queryGrams) {
      final postingList = grams[gram];
      if (postingList == null) return const [];
      postingLists.add(postingList);
    }
    postingLists.sort((first, second) => first.length.compareTo(second.length));
    var candidates = postingLists.first;
    for (final postingList in postingLists.skip(1)) {
      final allowed = postingList.toSet();
      candidates = candidates.where(allowed.contains).toList(growable: false);
      if (candidates.isEmpty) break;
    }
    return candidates;
  }
}
