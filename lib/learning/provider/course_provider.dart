import 'package:course_repository/course_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart' show FutureProviderFamily;
import 'package:wort_flutter/app/provider/repository_providers.dart';

final booksProvider = FutureProvider<List<CourseBook>>((ref) {
  return ref.watch(courseRepositoryProvider).getBooks();
});

typedef ModuleKey = ({String bookId, String moduleFile});

final FutureProviderFamily<List<CourseWord>, ModuleKey> moduleWordsProvider =
    FutureProvider.family<List<CourseWord>, ModuleKey>((
      ref,
      key,
    ) {
      return ref
          .watch(courseRepositoryProvider)
          .getModuleWords(
            bookId: key.bookId,
            moduleFile: key.moduleFile,
          );
    });
