import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/dictionary/provider/noun_gender_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads noun articles from the bundled gender index', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final index = await container.read(nounGenderIndexProvider.future);

    expect(nounArticles(index, 'Haus'), ['das']);
  });
}
