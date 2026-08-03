@TestOn('browser')
library;

import 'dart:typed_data';

import 'package:drift_citizenship_test_client/src/media/web_media_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persists versioned media in browser Cache Storage', () async {
    final store = WebMediaStore();
    final path = await store.write(
      datasetId: 'web-test',
      mediaKey: 'image.png',
      bytes: Uint8List.fromList([1, 2, 3]),
      extension: '.png',
    );
    expect(await store.read(path), [1, 2, 3]);
    await store.copy(from: path, to: 'web-test-copy/image.png');
    expect(await store.read('web-test-copy/image.png'), [1, 2, 3]);
    await store.deleteDataset('web-test');
    expect(await store.read(path), isNull);
    await store.deleteDataset('web-test-copy');
  });
}
