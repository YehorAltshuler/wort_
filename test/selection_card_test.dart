import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/widgets/selection_card.dart';

void main() {
  testWidgets('keeps the word count badge compact on a narrow row', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: SelectionCard(
              title: 'All words',
              selected: true,
              onTap: () {},
              leading: Icons.layers_outlined,
              badge: '310',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.layers_outlined), findsOneWidget);
    expect(find.text('310'), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_checked_rounded), findsOneWidget);
    expect(tester.getSize(find.text('310')).height, lessThan(28));
  });
}
