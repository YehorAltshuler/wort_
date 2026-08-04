import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/widgets/dashboard_block.dart';

void main() {
  testWidgets('new-list block uses a custom dashed outline', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardAddBlock(label: 'New list', onTap: () {}),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(DashboardAddBlock),
        matching: find.byType(CustomPaint),
      ),
      findsWidgets,
    );
    expect(
      find.descendant(
        of: find.byType(DashboardAddBlock),
        matching: find.byType(InkWell),
      ),
      findsOneWidget,
    );
  });

  testWidgets('matches the height of a neighboring dashboard card on desktop', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardBlockGrid(
            children: [
              DashboardBlock(
                icon: Icons.folder,
                title: 'A list with progress',
                subtitle: '12 words · 4 confirmed',
                progress: 0.3,
                onTap: () {},
              ),
              DashboardAddBlock(label: 'New list', onTap: () {}),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(DashboardBlock)).height,
      tester.getSize(find.byType(DashboardAddBlock)).height,
    );
  });
}
