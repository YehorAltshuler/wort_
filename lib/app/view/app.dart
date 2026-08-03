import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:wort_flutter/app/router/app_router.dart';
import 'package:wort_flutter/citizenship_test/provider/citizenship_test_provider.dart';
import 'package:wort_flutter/l10n/generated/app_localizations.dart';
import 'package:wort_flutter/settings/provider/settings_provider.dart';
import 'package:wort_flutter/theme/wort_theme.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        ref.read(citizenshipSyncControllerProvider.notifier).synchronize(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(citizenshipBootstrapProvider);
    final settings = ref.watch(settingsProvider).value;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'wort_',
      theme: WortTheme.light(settings?.palette ?? ColorPalette.pink),
      darkTheme: WortTheme.dark(settings?.palette ?? ColorPalette.pink),
      themeMode: _themeMode(settings?.theme ?? ThemePreference.system),
      locale: Locale(settings?.language.code ?? 'en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }

  ThemeMode _themeMode(ThemePreference preference) => switch (preference) {
    ThemePreference.system => ThemeMode.system,
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
  };
}
