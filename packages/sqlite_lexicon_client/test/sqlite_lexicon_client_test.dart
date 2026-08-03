import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite_lexicon_client/sqlite_lexicon_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('wort_lexicon_test');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('searches and loads details from bundled SQLite', () async {
    final source = File('../../assets/native/lexicon.db');
    final database = await source.copy('${directory.path}/lexicon.db');
    final client = SqliteLexiconClient(file: () async => database);

    final results = await client.search('haus', limit: 3);
    final details = await client.getById('haus');

    expect(results, isNotEmpty);
    expect(results.first.normalized, 'haus');
    expect(details, isNotNull);
    expect(details!.lemma, 'Haus');
    expect(details.senses, isNotEmpty);
  });
}
