import 'package:citizenship_test_client/citizenship_test_client.dart';
import 'package:citizenship_test_repository/citizenship_test_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/citizenship_test/widgets/citizenship_question_list_sheet.dart';
import 'package:wort_flutter/l10n/generated/app_localizations.dart';

void main() {
  final questions = List.generate(310, _question);

  testWidgets('opens at the current question', (tester) async {
    await tester.pumpWidget(
      _testApp(
        CitizenshipQuestionListSheet(
          questions: questions,
          currentIndex: 249,
          progress: const [],
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question 250'), findsOneWidget);
    final scrollable = tester.state<ScrollableState>(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(scrollable.position.pixels, greaterThan(19000));
  });

  testWidgets('jumps to an entered question number', (tester) async {
    int? selected;
    await tester.pumpWidget(
      _testApp(
        CitizenshipQuestionListSheet(
          questions: questions,
          currentIndex: 0,
          progress: const [],
          onSelected: (value) => selected = value,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '250');
    await tester.testTextInput.receiveAction(TextInputAction.go);

    expect(selected, 249);
  });

  testWidgets('shows validation for an out-of-range number', (tester) async {
    await tester.pumpWidget(
      _testApp(
        CitizenshipQuestionListSheet(
          questions: questions,
          currentIndex: 0,
          progress: const [],
          onSelected: (_) {},
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '311');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pump();

    expect(find.text('Enter a number from 1 to 310'), findsOneWidget);
  });
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SizedBox(height: 600, child: child)),
);

CitizenshipQuestion _question(int index) => CitizenshipQuestion.fromRecord(
  QuestionRecord(
    id: 'q$index',
    num: '${index + 1}',
    question: 'Question ${index + 1}',
    answers: const ['A', 'B', 'C', 'D'],
    correctAnswer: 0,
    sortOrder: index,
    scope: QuestionScope.general,
  ),
);
