import 'package:mocktail/mocktail.dart';
import 'package:preferences_client/preferences_client.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:test/test.dart';

void main() {
  late PreferencesClient client;
  late SettingsRepository repository;

  setUp(() {
    client = _MockPreferencesClient();
    repository = SettingsRepository(client: client);
  });

  test('loads stored language and theme', () async {
    when(() => client.readString(any())).thenAnswer((_) async => null);
    when(() => client.readString('appLanguage')).thenAnswer((_) async => 'ar');
    when(
      () => client.readString('themePreference'),
    ).thenAnswer((_) async => 'dark');

    final settings = await repository.load(
      fallbackLanguage: AppLanguage.english,
    );

    expect(settings.language, AppLanguage.arabic);
    expect(settings.theme, ThemePreference.dark);
  });

  test('uses platform language and system theme by default', () async {
    when(() => client.readString(any())).thenAnswer((_) async => null);

    final settings = await repository.load(
      fallbackLanguage: AppLanguage.russian,
    );

    expect(settings.language, AppLanguage.russian);
    expect(settings.theme, ThemePreference.system);
    expect(settings.textSize, TextSizePreference.standard);
  });

  test('persists Expo-compatible preference values', () async {
    when(() => client.writeString(any(), any())).thenAnswer((_) async {});

    await repository.setLanguage(AppLanguage.english);
    await repository.setTheme(ThemePreference.light);
    await repository.setTextSize(TextSizePreference.extraLarge);

    verify(() => client.writeString('appLanguage', 'en')).called(1);
    verify(() => client.writeString('themePreference', 'light')).called(1);
    verify(
      () => client.writeString('textSizePreference', 'extraLarge'),
    ).called(1);
  });

  test('loads stored text size', () async {
    when(() => client.readString(any())).thenAnswer((_) async => null);
    when(
      () => client.readString('textSizePreference'),
    ).thenAnswer((_) async => 'large');

    final settings = await repository.load(
      fallbackLanguage: AppLanguage.english,
    );

    expect(settings.textSize, TextSizePreference.large);
  });
}

class _MockPreferencesClient extends Mock implements PreferencesClient {}
