import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/widgets/responsive_content.dart';

void main() {
  testWidgets('keeps content constrained and scrollbar at the window edge', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveContent(
            child: Builder(
              builder: (context) => ListView.builder(
                padding: ResponsiveContent.insets(context, EdgeInsets.zero),
                itemCount: 100,
                itemBuilder: (context, index) => SizedBox(
                  key: index == 0 ? const ValueKey('first-item') : null,
                  height: 50,
                  child: Text('$index'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.getSize(find.byType(ListView)).width, 1200);
    expect(tester.getSize(find.byType(Scrollbar)).width, 1200);
    expect(tester.getSize(find.byKey(const ValueKey('first-item'))).width, 960);

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

    scrollable.position.jumpTo(0);
    await tester.dragFrom(const Offset(40, 300), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(scrollable.position.pixels, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
