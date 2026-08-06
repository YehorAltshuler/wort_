import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/l10n/generated/app_localizations.dart';
import 'package:wort_flutter/widgets/training_statistics_view.dart';

void main() {
  testWidgets('renders non-interactive shared training statistics', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TrainingStatisticsView(
            title: 'Exercise',
            total: 10,
            answered: 7,
            correct: 5,
            incorrect: 2,
            keyPrefix: 'test',
          ),
        ),
      ),
    );

    expect(find.text('Answered 7 of 10'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.byType(InkWell), findsNothing);
  });
}
