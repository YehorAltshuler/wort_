@TestOn('vm')
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:drift_citizenship_test_client/src/media/native_media_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('writes, copies, reads and deletes versioned files', () async {
    final root = await Directory.systemTemp.createTemp('lid-media-test');
    addTearDown(() => root.delete(recursive: true));
    final store = NativeMediaStore(root: () async => root);
    final path = await store.write(
      datasetId: 'one',
      mediaKey: 'image.png',
      bytes: Uint8List.fromList([1, 2, 3]),
      extension: '.png',
    );
    expect(await store.read(path), [1, 2, 3]);
    await store.copy(from: path, to: 'two/image.png');
    expect(await store.read('two/image.png'), [1, 2, 3]);
    await store.deleteDataset('one');
    expect(await store.read(path), isNull);
  });
}
