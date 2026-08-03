import 'package:course_client/course_client.dart';
import 'package:course_repository/course_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  test('maps books, modules and words while preserving stable ids', () async {
    final client = _MockCourseClient();
    final repository = CourseRepository(client: client);
    when(client.loadBooks).thenAnswer(
      (_) async => [
        {
          'id': 'book-a1',
          'title': 'Book A1',
          'level': 'A1',
          'modules': [
            {'id': 1, 'title': 'Module 1', 'file': 'module1.json'},
          ],
        },
      ],
    );
    when(
      () => client.loadModuleWords(
        bookId: 'book-a1',
        moduleFile: 'module1.json',
      ),
    ).thenAnswer(
      (_) async => [
        {
          'dictionaryId': 'haus',
          'type': 'noun',
          'article': ['das'],
          'word': 'Haus',
          'plural': 'Häuser',
          'translation': {
            'ru': ['дом'],
            'en': ['house'],
          },
        },
      ],
    );

    final books = await repository.getBooks();
    final words = await repository.getModuleWords(
      bookId: 'book-a1',
      moduleFile: 'module1.json',
    );

    expect(books.single.modules.single.file, 'module1.json');
    expect(words.single.id, 'book-a1:module1.json:0');
    expect(words.single.dictionaryId, 'haus');
    expect(words.single.translationsFor('ru'), ['дом']);
  });
}

class _MockCourseClient extends Mock implements CourseClient {}
