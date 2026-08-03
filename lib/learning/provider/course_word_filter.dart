import 'package:course_repository/course_repository.dart';

enum CourseWordFilter { all, noun, verb, other }

extension CourseWordFilterX on CourseWordFilter {
  List<CourseWord> apply(List<CourseWord> words) => switch (this) {
    CourseWordFilter.all => words,
    CourseWordFilter.noun =>
      words.where((word) => word.type == CourseWordType.noun).toList(),
    CourseWordFilter.verb =>
      words.where((word) => word.type == CourseWordType.verb).toList(),
    CourseWordFilter.other =>
      words.where((word) => word.type == CourseWordType.other).toList(),
  };

  static CourseWordFilter fromName(String value) => switch (value) {
    'noun' => CourseWordFilter.noun,
    'verb' => CourseWordFilter.verb,
    'other' => CourseWordFilter.other,
    _ => CourseWordFilter.all,
  };
}
