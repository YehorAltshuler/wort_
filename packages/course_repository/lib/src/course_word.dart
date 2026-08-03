import 'package:course_repository/src/course_word_type.dart';

class CourseWord {
  const CourseWord({
    required this.id,
    required this.type,
    required this.term,
    required this.translations,
    this.dictionaryId,
    this.article = const [],
    this.plural,
    this.praeteritum,
    this.perfekt,
  });

  final String id;
  final String? dictionaryId;
  final CourseWordType type;
  final String term;
  final List<String> article;
  final String? plural;
  final String? praeteritum;
  final String? perfekt;
  final Map<String, List<String>> translations;

  List<String> translationsFor(String languageCode) {
    return translations[languageCode] ?? translations['en'] ?? const [];
  }
}
