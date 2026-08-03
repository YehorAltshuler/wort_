import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:lexicon_client/lexicon_client.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_lexicon_client/src/lexicon_database.dart';

class SqliteLexiconClient implements LexiconClient {
  SqliteLexiconClient({AssetBundle? assetBundle, Future<File> Function()? file})
    : _assetBundle = assetBundle ?? rootBundle,
      _file = file;

  static const _assetPath = 'assets/native/lexicon.db';

  final AssetBundle _assetBundle;
  final Future<File> Function()? _file;
  Future<LexiconDatabase>? _database;

  @override
  Future<List<LexiconRecord>> search(String query, {int limit = 20}) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty || limit <= 0) return const [];
    final database = await (_database ??= _openDatabase());
    final rows = await database
        .customSelect(
          '''
      SELECT id, lemma, part_of_speech, frequency_rank
      FROM lexeme_search
      WHERE instr(id, ?) > 0
      ORDER BY
        CASE WHEN id = ? THEN 0
             WHEN id LIKE ? THEN 1
             ELSE 2 END,
        frequency_rank
      LIMIT ?
      ''',
          variables: [
            Variable<String>(normalized),
            Variable<String>(normalized),
            Variable<String>('$normalized%'),
            Variable<int>(limit),
          ],
        )
        .get();
    return rows
        .map(
          (row) => LexiconRecord(
            id: row.read<String>('id'),
            lemma: row.read<String>('lemma'),
            normalized: row.read<String>('id'),
            partOfSpeech: row.readNullable<String>('part_of_speech') ?? 'other',
            frequencyRank: row.read<int>('frequency_rank'),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<LexiconDetailsRecord?> getById(String id) async {
    final normalized = id.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    final database = await (_database ??= _openDatabase());
    final row = await database
        .customSelect(
          'SELECT * FROM lexemes WHERE id = ? LIMIT 1',
          variables: [Variable<String>(normalized)],
        )
        .getSingleOrNull();
    if (row == null) return null;
    return LexiconDetailsRecord(
      id: row.read<String>('id'),
      lemma: row.read<String>('lemma'),
      partOfSpeech: row.readNullable<String>('part_of_speech') ?? 'other',
      frequencyRank: row.read<int>('frequency_rank'),
      pronunciation: _decodeList(row.readNullable<String>('pronunciation')),
      forms: _decodeStringLists(row.readNullable<String>('forms')),
      senses: _decodeObjectList(row.readNullable<String>('senses')),
      etymology: row.readNullable<String>('etymology'),
      localizations: _decodeObject(row.readNullable<String>('localizations')),
    );
  }

  Future<LexiconDatabase> _openDatabase() async {
    final providedFile = _file;
    if (providedFile != null) {
      return LexiconDatabase(
        NativeDatabase.createInBackground(await providedFile()),
      );
    }
    final directory = await getApplicationSupportDirectory();
    final file = File(path.join(directory.path, 'lexicon.db'));
    if (!file.existsSync()) {
      await file.parent.create(recursive: true);
      final bytes = await _assetBundle.load(_assetPath);
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    }
    return LexiconDatabase(NativeDatabase.createInBackground(file));
  }

  static List<String> _decodeList(String? value) {
    return (jsonDecode(value ?? '[]') as List<dynamic>).cast<String>();
  }

  static List<Map<String, dynamic>> _decodeObjectList(String? value) {
    return (jsonDecode(value ?? '[]') as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  static Map<String, dynamic> _decodeObject(String? value) {
    return jsonDecode(value ?? '{}') as Map<String, dynamic>;
  }

  static Map<String, List<String>> _decodeStringLists(String? value) {
    return _decodeObject(value).map(
      (key, values) => MapEntry(key, (values as List<dynamic>).cast<String>()),
    );
  }
}
