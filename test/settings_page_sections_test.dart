import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/l10n/generated/app_localizations.dart';
import 'package:wort_flutter/settings/widgets/settings_page_sections.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('general section selects interface language', (tester) async {
    AppLanguage? selectedLanguage;
    await tester.pumpWidget(
      app(
        GeneralSettingsSection(
          settings: const AppSettings(
            language: AppLanguage.english,
            nativeLanguage: NativeLanguage.english,
            theme: ThemePreference.system,
          ),
          onLanguageChanged: (value) => selectedLanguage = value,
          onNativeLanguageChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Interface language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(selectedLanguage, AppLanguage.german);
  });

  testWidgets('content and LID sections forward their actions', (tester) async {
    var contentTapped = false;
    var lidTapped = false;
    var resetTapped = false;
    await tester.pumpWidget(
      app(
        Column(
          children: [
            ContentSettingsSection(
              status: 'Current version',
              onCatalogTap: () => contentTapped = true,
            ),
            LidSettingsSection(
              catalogStatus: 'Up to date',
              onCatalogTap: () => lidTapped = true,
              onResetProgress: () => resetTapped = true,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Content updates'));
    await tester.tap(find.text('LiD question catalog'));
    await tester.tap(find.text('Reset answer statistics'));

    expect(contentTapped, isTrue);
    expect(lidTapped, isTrue);
    expect(resetTapped, isTrue);
  });
}
