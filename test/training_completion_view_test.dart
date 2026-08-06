import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/l10n/generated/app_localizations.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';
import 'package:wort_flutter/widgets/training_completion_view.dart';

void main() {
  testWidgets('shows shared results and invokes completion actions', (
    tester,
  ) async {
    var secondaryPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ResponsiveContent(
            child: TrainingCompletionView(
              title: 'Complete',
              correct: 8,
              incorrect: 2,
              total: 10,
              secondaryAction: TrainingCompletionAction(
                label: 'Retry',
                onPressed: () => secondaryPressed = true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Complete'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    expect(secondaryPressed, isTrue);
    expect(tester.takeException(), isNull);
  });
}
