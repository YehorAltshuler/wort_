import 'dart:convert';

import 'package:course_client/course_client.dart';
import 'package:flutter/services.dart';

class AssetCourseClient implements CourseClient {
  const AssetCourseClient({AssetBundle? bundle}) : _bundle = bundle;

  static const _bookIds = [
    'schritte-plus-neu-a1-1',
    'schritte-plus-neu-a1-2',
    'schritte-plus-neu-a2-1',
    'schritt-für-schritt-zum-dtz',
  ];

  final AssetBundle? _bundle;

  AssetBundle get _assets => _bundle ?? rootBundle;

  @override
  Future<List<Map<String, Object?>>> loadBooks() async {
    return Future.wait([
      for (final id in _bookIds)
        _loadObject('assets/coursebooks/$id/book.json'),
    ]);
  }

  @override
  Future<List<Map<String, Object?>>> loadModuleWords({
    required String bookId,
    required String moduleFile,
  }) async {
    if (!_bookIds.contains(bookId) ||
        !RegExp(r'^module\d+\.json$').hasMatch(moduleFile)) {
      return const [];
    }
    final value =
        jsonDecode(
              await _assets.loadString(
                'assets/coursebooks/$bookId/$moduleFile',
              ),
            )!
            as List<Object?>;
    return value.cast<Map<String, Object?>>();
  }

  Future<Map<String, Object?>> _loadObject(String path) async {
    return jsonDecode(await _assets.loadString(path))! as Map<String, Object?>;
  }
}
