import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wort_flutter/widgets/async_value_view.dart';

void main() {
  testWidgets('renders loading, error, and data states', (tester) async {
    Future<void> pump(AsyncValue<String> value) => tester.pumpWidget(
      MaterialApp(
        home: AsyncValueView(
          value: value,
          errorMessage: 'Unable to load',
          data: Text.new,
        ),
      ),
    );

    await pump(const AsyncLoading());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await pump(AsyncError(StateError('failed'), StackTrace.empty));
    expect(find.text('Unable to load'), findsOneWidget);

    await pump(const AsyncData('Loaded'));
    expect(find.text('Loaded'), findsOneWidget);
  });

  testWidgets('offers retry action for an error', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AsyncValueView<String>(
          value: AsyncError(StateError('failed'), StackTrace.empty),
          errorMessage: 'Unable to load',
          retryLabel: 'Try again',
          onRetry: () => retries++,
          data: Text.new,
        ),
      ),
    );

    await tester.tap(find.text('Try again'));

    expect(retries, 1);
  });
}
