import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/citizenship_test/widgets/fullscreen_image_viewer.dart';

void main() {
  testWidgets('dismisses with a vertical swipe', (tester) async {
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                FullscreenImageViewerRoute(
                  imageProvider: MemoryImage(_imageBytes),
                  heroTag: 'image',
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(FullscreenImageViewer), findsOneWidget);

    await tester.drag(find.byType(InteractiveViewer), const Offset(0, 180));
    await tester.pumpAndSettle();

    expect(find.byType(FullscreenImageViewer), findsNothing);
  });
}

final Uint8List _imageBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8A'
  'AQUBAScY42YAAAAASUVORK5CYII=',
);
