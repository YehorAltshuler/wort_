import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/exercises/provider/exercises_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the fixed-preposition exercise from RN assets', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final exercise = await container.read(
      fixedPrepositionExerciseProvider.future,
    );

    expect(exercise.catalog.id, 'fixed-preposition-verbs');
    expect(exercise.catalog.title, 'Verben mit festen Präpositionen');
    expect(exercise.words, hasLength(39));
    expect(exercise.words.first.pattern, 'warten auf + Akkusativ');
  });
}
