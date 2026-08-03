import 'dart:js_interop';
import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:web/web.dart' as web;

class WebMediaStore implements CitizenshipTestMediaStore {
  static const _cacheName = 'citizenship-test-media-v1';
  String _url(String relativePath) =>
      '${web.window.location.origin}/__lid_media__/$relativePath';

  Future<web.Cache> get _cache => web.window.caches.open(_cacheName).toDart;

  @override
  Future<String> write({
    required String datasetId,
    required String mediaKey,
    required Uint8List bytes,
    required String extension,
  }) async {
    final filename = mediaKey.contains('.') ? mediaKey : '$mediaKey$extension';
    final relative = '$datasetId/$filename';
    final headers = web.Headers()..set('Content-Type', _mime(extension));
    final response = web.Response(
      bytes.toJS,
      web.ResponseInit(headers: headers, status: 200),
    );
    await (await _cache).put(web.Request(_url(relative).toJS), response).toDart;
    return relative;
  }

  @override
  Future<Uint8List?> read(String relativePath) async {
    final response = await (await _cache)
        .match(web.Request(_url(relativePath).toJS))
        .toDart;
    if (response == null) return null;
    final buffer = await response.arrayBuffer().toDart;
    return buffer.toDart.asUint8List();
  }

  @override
  Future<void> copy({required String from, required String to}) async {
    final bytes = await read(from);
    if (bytes == null) throw StateError('Cached media is missing.');
    await write(
      datasetId: to.split('/').first,
      mediaKey: to.split('/').last,
      bytes: bytes,
      extension: '.jpg',
    );
  }

  @override
  Future<void> deleteDataset(String datasetId) async {
    final cache = await _cache;
    final requests = (await cache.keys().toDart).toDart;
    for (final request in requests) {
      if (request.url.contains('/__lid_media__/$datasetId/')) {
        await cache.delete(request).toDart;
      }
    }
  }

  static String _mime(String extension) =>
      extension == '.png' ? 'image/png' : 'image/jpeg';
}
