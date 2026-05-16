import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provides the SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

// Available languages: 'en', 'hi', 'gu'
class LocaleNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  
  LocaleNotifier(this._prefs) : super(_prefs.getString('selected_locale') ?? 'en');

  Future<void> setLocale(String langCode) async {
    state = langCode;
    await _prefs.setString('selected_locale', langCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

// Theme Mode (system, light, dark)
class ThemeModeNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  ThemeModeNotifier(this._prefs) : super(_prefs.getString('theme_mode') ?? 'system');

  Future<void> setThemeMode(String mode) async {
    state = mode;
    await _prefs.setString('theme_mode', mode);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

// Theme Color (hex string)
class ThemeColorNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  ThemeColorNotifier(this._prefs) : super(_prefs.getString('theme_color') ?? '0xFFC2185B'); // Default Khata Red

  Future<void> setThemeColor(String colorHex) async {
    state = colorHex;
    await _prefs.setString('theme_color', colorHex);
  }
}

final themeColorProvider = StateNotifierProvider<ThemeColorNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeColorNotifier(prefs);
});

// Notifications Enabled
class NotificationEnabledNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  NotificationEnabledNotifier(this._prefs) : super(_prefs.getBool('notifications_enabled') ?? true);

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = enabled;
    await _prefs.setBool('notifications_enabled', enabled);
  }
}

final notificationEnabledProvider = StateNotifierProvider<NotificationEnabledNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return NotificationEnabledNotifier(prefs);
});

