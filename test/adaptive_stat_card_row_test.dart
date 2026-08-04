import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/widgets/adaptive_stat_card_row.dart';
import 'package:wort_flutter/widgets/progress_stat_card.dart';

void main() {
  Widget app(double width) => MaterialApp(
    home: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        child: AdaptiveStatCardRow(
          firstBuilder: (context, {required fillHeight}) => ProgressStatCard(
            key: const ValueKey('first'),
            icon: Icons.check,
            label: 'Correct',
            progress: 0.5,
            progressLabel: '5 / 10',
            fillHeight: fillHeight,
          ),
          secondBuilder: (context, {required fillHeight}) => ProgressStatCard(
            key: const ValueKey('second'),
            icon: Icons.close,
            label: 'Incorrect',
            progress: 0.2,
            progressLabel: '2 / 10',
            fillHeight: fillHeight,
          ),
        ),
      ),
    ),
  );

  testWidgets('uses square cards on compact widths', (tester) async {
    await tester.pumpWidget(app(400));
    final size = tester.getSize(find.byKey(const ValueKey('first')));
    expect(size.width, closeTo(194, 0.1));
    expect(size.height, closeTo(size.width, 0.1));
  });

  testWidgets('keeps full width and content height on wide layouts', (
    tester,
  ) async {
    await tester.pumpWidget(app(800));
    final size = tester.getSize(find.byKey(const ValueKey('first')));
    expect(size.width, closeTo(394, 0.1));
    expect(size.height, lessThan(size.width));
  });
}
