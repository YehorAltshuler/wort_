import 'package:course_client/course_client.dart';
import 'package:course_repository/src/course_book.dart';
import 'package:course_repository/src/course_module.dart';
import 'package:course_repository/src/course_word.dart';
import 'package:course_repository/src/course_word_type.dart';

class CourseRepository {
  const CourseRepository({required CourseClient client}) : _client = client;

  final CourseClient _client;

  Future<List<CourseBook>> getBooks() async {
    final records = await _client.loadBooks();
    return records.map(_mapBook).toList(growable: false);
  }

  Future<List<CourseWord>> getModuleWords({
    required String bookId,
    required String moduleFile,
  }) async {
    final records = await _client.loadModuleWords(
      bookId: bookId,
      moduleFile: moduleFile,
    );
    return [
      for (var index = 0; index < records.length; index++)
        _mapWord(records[index], '$bookId:$moduleFile:$index'),
    ];
  }

  static CourseBook _mapBook(Map<String, Object?> record) {
    final modules = record['modules']! as List<Object?>;
    return CourseBook(
      id: record['id']! as String,
      title: record['title']! as String,
      level: record['level']! as String,
      modules: modules
          .cast<Map<String, Object?>>()
          .map(
            (module) => CourseModule(
              id: module['id']! as int,
              title: module['title']! as String,
              file: module['file']! as String,
            ),
          )
          .toList(growable: false),
    );
  }

  static CourseWord _mapWord(Map<String, Object?> record, String id) {
    final translations = (record['translation']! as Map<String, Object?>).map(
      (key, value) => MapEntry(key, (value! as List<Object?>).cast<String>()),
    );
    final type = switch (record['type']) {
      'noun' => CourseWordType.noun,
      'verb' => CourseWordType.verb,
      _ => CourseWordType.other,
    };
    return CourseWord(
      id: id,
      dictionaryId: record['dictionaryId'] as String?,
      type: type,
      term: (record['word'] ?? record['infinitive'])! as String,
      article: ((record['article'] as List<Object?>?) ?? const []).cast(),
      plural: record['plural'] as String?,
      praeteritum: record['praeteritum'] as String?,
      perfekt: record['perfekt'] as String?,
      translations: translations,
    );
  }
}
