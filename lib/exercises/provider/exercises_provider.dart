import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';

final fixedPrepositionExerciseProvider =
    FutureProvider<FixedPrepositionExercise>((ref) async {
      const root = 'assets/exercises/fixed-preposition-verbs';
      final metadata =
          jsonDecode(
                await rootBundle.loadString('$root/exercise.json'),
              )!
              as Map<String, dynamic>;
      final rawWords =
          jsonDecode(
                await rootBundle.loadString('$root/words.json'),
              )!
              as List<dynamic>;
      return FixedPrepositionExercise(
        catalog: ExerciseCatalogItem(
          id: metadata['id']! as String,
          title: metadata['title']! as String,
          descriptions: _translations(metadata['description']),
        ),
        words: rawWords
            .map((value) {
              final json = value! as Map<String, dynamic>;
              return FixedPrepositionVerb(
                verb: json['verb']! as String,
                preposition: json['preposition']! as String,
                grammaticalCase: json['case']! as String,
                translations: _translations(json['translation']),
                example: json['example']! as String,
              );
            })
            .toList(growable: false),
      );
    });

Map<String, List<String>> _translations(Object? value) =>
    (value! as Map<String, dynamic>).map(
      (language, translations) => MapEntry(
        language,
        (translations as List<dynamic>).cast<String>(),
      ),
    );
