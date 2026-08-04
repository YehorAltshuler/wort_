class ExerciseCatalogItem {
  const ExerciseCatalogItem({
    required this.id,
    required this.title,
    required this.descriptions,
  });

  final String id;
  final String title;
  final Map<String, List<String>> descriptions;

  String descriptionFor(String languageCode) =>
      (descriptions[languageCode] ?? descriptions['en'] ?? const [])
          .firstOrNull ??
      '';
}

class FixedPrepositionVerb {
  const FixedPrepositionVerb({
    required this.verb,
    required this.preposition,
    required this.grammaticalCase,
    required this.translations,
    required this.example,
  });

  final String verb;
  final String preposition;
  final String grammaticalCase;
  final Map<String, List<String>> translations;
  final String example;

  String translationFor(String languageCode) =>
      (translations[languageCode] ?? translations['en'] ?? const [])
          .firstOrNull ??
      '';

  String get pattern => '$verb $preposition + $grammaticalCase';

  String get progressId =>
      'exercise:fixed-preposition-verbs:$verb:$preposition:$grammaticalCase';
}

class FixedPrepositionExercise {
  const FixedPrepositionExercise({required this.catalog, required this.words});

  final ExerciseCatalogItem catalog;
  final List<FixedPrepositionVerb> words;
}

enum FixedPrepositionFilter { all, correct, incorrect }

extension FixedPrepositionFilterX on FixedPrepositionFilter {
  static FixedPrepositionFilter fromName(String value) => switch (value) {
    'correct' => FixedPrepositionFilter.correct,
    'incorrect' => FixedPrepositionFilter.incorrect,
    _ => FixedPrepositionFilter.all,
  };
}
