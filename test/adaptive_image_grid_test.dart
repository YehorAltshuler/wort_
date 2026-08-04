import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/citizenship_test/widgets/adaptive_image_grid.dart';

void main() {
  Future<int> columnCount(
    WidgetTester tester, {
    required double width,
    required int itemCount,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: width,
            child: CitizenshipAdaptiveImageGrid(
              itemCount: itemCount,
              childAspectRatio: 1,
              itemBuilder: (context, index) => Text('$index'),
            ),
          ),
        ),
      ),
    );
    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    return delegate.crossAxisCount;
  }

  testWidgets('uses one full-width column for a single image', (tester) async {
    expect(await columnCount(tester, width: 800, itemCount: 1), 1);
  });

  testWidgets('uses one row for four images on desktop', (tester) async {
    expect(await columnCount(tester, width: 800, itemCount: 4), 4);
  });

  testWidgets('keeps the two-column grid on mobile', (tester) async {
    expect(await columnCount(tester, width: 400, itemCount: 4), 2);
  });
}
