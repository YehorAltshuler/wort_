import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/widgets/selection_bottom_sheet.dart';

void main() {
  testWidgets('selection sheet marks and returns the selected option', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () async {
                result = await showSelectionBottomSheet<String>(
                  context: context,
                  title: 'Text size',
                  values: const ['standard', 'large', 'extraLarge'],
                  label: (value) => value,
                  selectedValue: 'large',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.tap(find.text('extraLarge'));
    await tester.pumpAndSettle();
    expect(result, 'extraLarge');
    expect(tester.takeException(), isNull);
  });
}
