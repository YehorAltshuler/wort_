import 'package:asset_course_client/asset_course_client.dart';
import 'package:course_repository/course_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads every bundled coursebook module', () async {
    const repository = CourseRepository(client: AssetCourseClient());
    final books = await repository.getBooks();

    expect(books, hasLength(4));
    for (final book in books) {
      expect(book.modules, isNotEmpty);
      for (final module in book.modules) {
        final words = await repository.getModuleWords(
          bookId: book.id,
          moduleFile: module.file,
        );
        expect(words, isNotEmpty, reason: '${book.id}/${module.file}');
      }
    }
  });
}
