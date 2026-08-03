import 'dart:io';
import 'dart:typed_data';

import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class NativeMediaStore implements CitizenshipTestMediaStore {
  NativeMediaStore({Future<Directory> Function()? root}) : _providedRoot = root;
  final Future<Directory> Function()? _providedRoot;

  Future<Directory> get _root async {
    final base =
        await (_providedRoot?.call() ?? getApplicationSupportDirectory());
    final directory = Directory(path.join(base.path, 'citizenship_test_media'));
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<String> write({
    required String datasetId,
    required String mediaKey,
    required Uint8List bytes,
    required String extension,
  }) async {
    final root = await _root;
    final filename = path.extension(mediaKey).isEmpty
        ? '$mediaKey$extension'
        : mediaKey;
    final relative = path.join(datasetId, filename);
    final file = File(path.join(root.path, relative));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return relative;
  }

  @override
  Future<Uint8List?> read(String relativePath) async {
    final root = await _root;
    final file = File(path.join(root.path, relativePath));
    return file.existsSync() ? file.readAsBytes() : null;
  }

  @override
  Future<void> copy({required String from, required String to}) async {
    final root = await _root;
    final source = File(path.join(root.path, from));
    final target = File(path.join(root.path, to));
    await target.parent.create(recursive: true);
    await source.copy(target.path);
  }

  @override
  Future<void> deleteDataset(String datasetId) async {
    final root = await _root;
    final directory = Directory(path.join(root.path, datasetId));
    if (directory.existsSync()) await directory.delete(recursive: true);
  }
}
