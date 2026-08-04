import 'package:flutter_test/flutter_test.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/theme/wort_theme.dart';

void main() {
  test('text size preferences use explicit typography scales', () {
    final standard = WortTheme.light(
      ColorPalette.pink,
      TextSizePreference.standard,
    );
    final large = WortTheme.light(
      ColorPalette.pink,
      TextSizePreference.large,
    );
    final extraLarge = WortTheme.light(
      ColorPalette.pink,
      TextSizePreference.extraLarge,
    );

    expect(standard.textTheme.bodyMedium?.fontSize, 14);
    expect(large.textTheme.bodyMedium?.fontSize, 16);
    expect(extraLarge.textTheme.bodyMedium?.fontSize, 18);
  });
}
