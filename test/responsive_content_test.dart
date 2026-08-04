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
    expect(tester.takeException(), isNull);
  });
}
