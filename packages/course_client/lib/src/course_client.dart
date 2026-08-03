abstract interface class CourseClient {
  Future<List<Map<String, Object?>>> loadBooks();

  Future<List<Map<String, Object?>>> loadModuleWords({
    required String bookId,
    required String moduleFile,
  });
}
