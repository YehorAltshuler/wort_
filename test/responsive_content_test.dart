import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

void main() {
  testWidgets('keeps content constrained and scrollbar at the window edge', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveContent(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) => SizedBox(
                height: 50,
                child: Text('$index'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(ListView)).width, 960);
    expect(tester.getSize(find.byType(Scrollbar)).width, 1200);

    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.position.pixels, 0);
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(40, 300),
        scrollDelta: Offset(0, 300),
      ),
    );
    await tester.pump();

    expect(scrollable.position.pixels, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
