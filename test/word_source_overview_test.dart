import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_progress_repository/learning_progress_repository.dart';
import 'package:wort_flutter/l10n/generated/app_localizations.dart';
import 'package:wort_flutter/learning/provider/course_word_filter.dart';
import 'package:wort_flutter/learning/widgets/word_source_overview.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';

void main() {
  testWidgets('hides word categories that have no words', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(960, 700);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WordSourceOverview(
            words: const [
              CourseWord(
                id: 'haus',
                type: CourseWordType.noun,
                term: 'Haus',
                translations: {
                  'en': ['house'],
                },
              ),
            ],
            progress: const LearningProgress(),
            title: 'Favorites',
            icon: Icons.bookmark,
            selectedFilter: CourseWordFilter.all,
            onFilterSelected: (_) {},
            onViewWords: () {},
          ),
        ),
      ),
    );

    expect(find.text('All words'), findsOneWidget);
    expect(find.text('Nouns'), findsOneWidget);
    expect(find.text('Verbs'), findsNothing);
    expect(find.text('Other'), findsNothing);
    final cardSize = tester.getSize(find.byType(ProgressStatCard).first);
    expect(cardSize.width, greaterThan(400));
    expect(cardSize.height, lessThan(250));
  });
}
