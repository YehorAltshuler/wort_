import 'dart:convert';

import 'package:asset_course_client/asset_course_client.dart';
import 'package:course_client/course_client.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum ContentSyncOutcome { skipped, notModified, updated }

class ContentSyncResult {
  const ContentSyncResult(this.outcome, {this.version});

  final ContentSyncOutcome outcome;
  final String? version;
}

class ContentSyncMetadata {
  const ContentSyncMetadata({
    this.version,
    this.lastCheckedAt,
    this.lastUpdatedAt,
    this.lastError,
  });

  factory ContentSyncMetadata.fromJson(
    Map<String, Object?> json,
  ) => ContentSyncMetadata(
    version: json['version'] as String?,
    lastCheckedAt: DateTime.tryParse(json['lastCheckedAt'] as String? ?? ''),
    lastUpdatedAt: DateTime.tryParse(json['lastUpdatedAt'] as String? ?? ''),
    lastError: json['lastError'] as String?,
  );

  final String? version;
  final DateTime? lastCheckedAt;
  final DateTime? lastUpdatedAt;
  final String? lastError;

  Map<String, Object?> toJson() => {
    if (version != null) 'version': version,
    if (lastCheckedAt != null)
      'lastCheckedAt': lastCheckedAt!.toUtc().toIso8601String(),
    if (lastUpdatedAt != null)
      'lastUpdatedAt': lastUpdatedAt!.toUtc().toIso8601String(),
    if (lastError != null) 'lastError': lastError,
  };
}

abstract interface class ContentCache {
  Future<String?> read(String key);

  Future<void> write(String key, String value);
}

class SharedPreferencesContentCache implements ContentCache {
  SharedPreferencesContentCache({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> read(String key) => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);
}

class ContentRepository implements CourseClient {
  ContentRepository({
    ContentCache? cache,
    CourseClient fallback = const AssetCourseClient(),
    http.Client? httpClient,
    Uri? manifestUri,
    DateTime Function()? now,
  }) : _cache = cache ?? SharedPreferencesContentCache(),
       _fallback = fallback,
       _http = httpClient ?? http.Client(),
       _manifestUri =
           manifestUri ??
           Uri.parse(
             'https://yehoraltshuler.github.io/wort-content/manifest.json',
           ),
       _now = now ?? DateTime.now;

  static const refreshInterval = Duration(days: 1);
  static const _bundleKey = 'wort.content.bundle.v1';
  static const _metadataKey = 'wort.content.metadata.v1';
  static const int _maximumJsonBytes = 8 * 1024 * 1024;

  final ContentCache _cache;
  final CourseClient _fallback;
  final http.Client _http;
  final Uri _manifestUri;
  final DateTime Function() _now;
  Future<ContentSyncResult>? _runningSync;
  Map<String, Object?>? _memoryBundle;

  Future<ContentSyncMetadata> loadMetadata() async {
    final value = await _cache.read(_metadataKey);
    if (value == null) return const ContentSyncMetadata();
    try {
      return ContentSyncMetadata.fromJson(
        (jsonDecode(value) as Map).cast<String, Object?>(),
      );
    } on Object {
      return const ContentSyncMetadata(lastError: 'Invalid cached metadata.');
    }
  }

  @override
  Future<List<Map<String, Object?>>> loadBooks() async {
    final bundle = await _loadBundle();
    if (bundle == null) return _fallback.loadBooks();
    return (bundle['books']! as List<Object?>).cast<Map<String, Object?>>();
  }

  @override
  Future<List<Map<String, Object?>>> loadModuleWords({
    required String bookId,
    required String moduleFile,
  }) async {
    final bundle = await _loadBundle();
    if (bundle == null) {
      return _fallback.loadModuleWords(
        bookId: bookId,
        moduleFile: moduleFile,
      );
    }
    final modules = (bundle['modules']! as Map).cast<String, Object?>();
    final records = modules['$bookId/$moduleFile'];
    return records == null
        ? const []
        : (records as List<Object?>).cast<Map<String, Object?>>();
  }

  Future<Map<String, Object?>?> loadExercise(String exerciseId) async {
    final bundle = await _loadBundle();
    if (bundle == null) return null;
    final exercises = (bundle['exercises']! as Map).cast<String, Object?>();
    return (exercises[exerciseId] as Map?)?.cast<String, Object?>();
  }

  Future<ContentSyncResult> synchronize({bool manual = false}) {
    final running = _runningSync;
    if (running != null) return running;
    final result = _synchronize(manual: manual);
    _runningSync = result;
    return result.whenComplete(() => _runningSync = null);
  }

  Future<ContentSyncResult> _synchronize({required bool manual}) async {
    final now = _now();
    final oldMetadata = await loadMetadata();
    if (!manual &&
        oldMetadata.lastCheckedAt != null &&
        now.difference(oldMetadata.lastCheckedAt!) < refreshInterval) {
      return ContentSyncResult(
        ContentSyncOutcome.skipped,
        version: oldMetadata.version,
      );
    }
    try {
      final manifest = await _fetchJson(_manifestUri);
      _expectSchema(manifest, 'manifest');
      final version = _string(manifest, 'datasetVersion', 'manifest');
      final catalogReference = _map(manifest, 'catalog', 'manifest');
      if (oldMetadata.version == version && await _loadBundle() != null) {
        await _saveMetadata(
          ContentSyncMetadata(
            version: version,
            lastCheckedAt: now,
            lastUpdatedAt: oldMetadata.lastUpdatedAt,
          ),
        );
        return ContentSyncResult(
          ContentSyncOutcome.notModified,
          version: version,
        );
      }

      final catalogUri = _safeResolve(
        _manifestUri,
        _string(catalogReference, 'url', 'catalog reference'),
      );
      final catalogBytes = await _fetchBytes(catalogUri);
      _verifyHash(
        catalogBytes,
        _string(catalogReference, 'sha256', 'catalog reference'),
        'catalog',
      );
      final catalog = _decodeMap(catalogBytes, 'catalog');
      _expectSchema(catalog, 'catalog');
      final sources = _list(catalog, 'sources', 'catalog');
      final books = <Map<String, Object?>>[];
      final modules = <String, Object?>{};
      final exercises = <String, Object?>{};

      for (final rawSource in sources) {
        final source = (rawSource! as Map).cast<String, Object?>();
        final sourceId = _string(source, 'id', 'source');
        final sourceType = _string(source, 'type', sourceId);
        final descriptorUri = _safeResolve(
          _manifestUri,
          _string(source, 'url', sourceId),
        );
        final descriptorBytes = await _fetchBytes(descriptorUri);
        _verifyHash(
          descriptorBytes,
          _string(source, 'sha256', sourceId),
          sourceId,
        );
        final descriptor = _decodeMap(descriptorBytes, sourceId);
        _expectSchema(descriptor, sourceId);
        if (sourceType == 'coursebook') {
          final moduleRecords = <Map<String, Object?>>[];
          for (final rawModule in _list(descriptor, 'modules', sourceId)) {
            final module = (rawModule! as Map).cast<String, Object?>();
            final url = _string(module, 'url', '$sourceId module');
            final moduleBytes = await _fetchBytes(
              _safeResolve(_manifestUri, url),
            );
            _verifyHash(
              moduleBytes,
              _string(module, 'sha256', '$sourceId module'),
              url,
            );
            final words = _decodeList(moduleBytes, url);
            final filename = Uri.parse(url).pathSegments.last;
            modules['$sourceId/$filename'] = words;
            moduleRecords.add({
              'id': moduleRecords.length + 1,
              'title': _string(module, 'title', '$sourceId module'),
              'file': filename,
            });
          }
          books.add({
            'id': sourceId,
            'title': _string(descriptor, 'title', sourceId),
            'level': _string(descriptor, 'level', sourceId),
            'modules': moduleRecords,
          });
        } else if (sourceType == 'exercise') {
          final wordsReference = _map(descriptor, 'words', sourceId);
          final wordsUrl = _string(wordsReference, 'url', sourceId);
          final wordBytes = await _fetchBytes(
            _safeResolve(_manifestUri, wordsUrl),
          );
          _verifyHash(
            wordBytes,
            _string(wordsReference, 'sha256', sourceId),
            wordsUrl,
          );
          exercises[sourceId] = {
            'metadata': descriptor,
            'words': _decodeList(wordBytes, wordsUrl),
          };
        } else {
          throw FormatException('Unsupported content source: $sourceType');
        }
      }

      final bundle = <String, Object?>{
        'version': version,
        'books': books,
        'modules': modules,
        'exercises': exercises,
      };
      await _cache.write(_bundleKey, jsonEncode(bundle));
      _memoryBundle = bundle;
      await _saveMetadata(
        ContentSyncMetadata(
          version: version,
          lastCheckedAt: now,
          lastUpdatedAt: now,
        ),
      );
      return ContentSyncResult(ContentSyncOutcome.updated, version: version);
    } on Object catch (error) {
      await _saveMetadata(
        ContentSyncMetadata(
          version: oldMetadata.version,
          lastCheckedAt: now,
          lastUpdatedAt: oldMetadata.lastUpdatedAt,
          lastError: error.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<Map<String, Object?>?> _loadBundle() async {
    if (_memoryBundle case final bundle?) return bundle;
    final value = await _cache.read(_bundleKey);
    if (value == null) return null;
    try {
      final bundle = (jsonDecode(value) as Map).cast<String, Object?>();
      if (bundle['books'] is! List ||
          bundle['modules'] is! Map ||
          bundle['exercises'] is! Map) {
        return null;
      }
      return _memoryBundle = bundle;
    } on Object {
      return null;
    }
  }

  Future<void> _saveMetadata(ContentSyncMetadata metadata) =>
      _cache.write(_metadataKey, jsonEncode(metadata.toJson()));

  Future<Map<String, Object?>> _fetchJson(Uri uri) async =>
      _decodeMap(await _fetchBytes(uri), uri.toString());

  Future<List<int>> _fetchBytes(Uri uri) async {
    if (uri.scheme != 'https' || uri.host != _manifestUri.host) {
      throw FormatException('Unsafe content URL: $uri');
    }
    final response = await _http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Content request failed with HTTP ${response.statusCode}.',
        uri,
      );
    }
    if (response.bodyBytes.isEmpty ||
        response.bodyBytes.length > _maximumJsonBytes) {
      throw const FormatException('Content response size is invalid.');
    }
    return response.bodyBytes;
  }

  Uri _safeResolve(Uri base, String relative) {
    final resolved = base.resolve(relative);
    if (resolved.scheme != 'https' || resolved.host != base.host) {
      throw FormatException('Unsafe content reference: $relative');
    }
    return resolved;
  }

  Map<String, Object?> _decodeMap(List<int> bytes, String context) {
    try {
      return (jsonDecode(utf8.decode(bytes)) as Map).cast<String, Object?>();
    } on Object {
      throw FormatException('$context is not a valid JSON object.');
    }
  }

  List<Object?> _decodeList(List<int> bytes, String context) {
    try {
      return jsonDecode(utf8.decode(bytes))! as List<Object?>;
    } on Object {
      throw FormatException('$context is not a valid JSON array.');
    }
  }

  void _verifyHash(List<int> bytes, String expected, String context) {
    if (sha256.convert(bytes).toString() != expected) {
      throw FormatException('$context checksum mismatch.');
    }
  }

  void _expectSchema(Map<String, Object?> json, String context) {
    if (json['schemaVersion'] != 1) {
      throw FormatException('$context schema is not supported.');
    }
  }

  String _string(Map<String, Object?> map, String key, String context) {
    final value = map[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('$context.$key is invalid.');
    }
    return value;
  }

  Map<String, Object?> _map(
    Map<String, Object?> map,
    String key,
    String context,
  ) {
    final value = map[key];
    if (value is! Map) throw FormatException('$context.$key is invalid.');
    return value.cast<String, Object?>();
  }

  List<Object?> _list(
    Map<String, Object?> map,
    String key,
    String context,
  ) {
    final value = map[key];
    if (value is! List) throw FormatException('$context.$key is invalid.');
    return value;
  }
}
