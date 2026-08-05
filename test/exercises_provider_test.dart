import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/app/provider/repository_providers.dart';
import 'package:wort_flutter/content/content_repository.dart';
import 'package:wort_flutter/exercises/domain/exercise_models.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the fixed-preposition exercise from RN assets', () async {
    final container = ProviderContainer(
      overrides: [
        contentRepositoryProvider.overrideWithValue(
          ContentRepository(cache: _EmptyContentCache()),
        ),
      ],
    );
    addTearDown(container.dispose);

    final exercise = await container.read(
      fixedPrepositionExerciseProvider.future,
    );

    expect(exercise.catalog.id, 'fixed-preposition-verbs');
    expect(exercise.catalog.title, 'Verben mit festen Präpositionen');
    expect(exercise.words, hasLength(39));
    expect(exercise.words.first.pattern, 'warten auf + Akkusativ');
    expect(
      FixedPrepositionFilterX.fromName('incorrect'),
      FixedPrepositionFilter.incorrect,
    );
    expect(
      exercise.words.first.progressId,
      'exercise:fixed-preposition-verbs:warten:auf:Akkusativ',
    );
  });
}

class _EmptyContentCache implements ContentCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}
