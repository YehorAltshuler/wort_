import 'package:shared_preferences/shared_preferences.dart';

class PreferencesClient {
  PreferencesClient({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  Future<String?> readString(String key) => _preferences.getString(key);

  Future<void> writeString(String key, String value) {
    return _preferences.setString(key, value);
  }
}
