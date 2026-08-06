import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wort_flutter/app/view/app.dart';
import 'package:wort_flutter/learning/provider/course_provider.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

  final container = ProviderContainer();
  unawaited(_preloadBooks(container));
  try {
    await container.read(settingsProvider.future);
  } on Object {
    // The app can still start with its built-in appearance defaults.
  }

  runApp(UncontrolledProviderScope(container: container, child: const App()));
  binding.allowFirstFrame();
}

Future<void> _preloadBooks(ProviderContainer container) async {
  try {
    await container.read(booksProvider.future);
  } on Object {
    // The page keeps its regular error and retry state as a fallback.
  }
}
