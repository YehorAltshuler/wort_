import 'package:course_repository/src/course_module.dart';

class CourseBook {
  const CourseBook({
    required this.id,
    required this.title,
    required this.level,
    required this.modules,
  });

  final String id;
  final String title;
  final String level;
  final List<CourseModule> modules;
}
