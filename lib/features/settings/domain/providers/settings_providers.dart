// lib/features/settings/domain/providers/settings_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../data/repositories/settings_repository.dart';

part 'settings_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return sl<SettingsRepository>();
}

// ── Theme Provider ─────────────────────────────────────────────────────────

@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  String build() {
    return ref.watch(settingsRepositoryProvider).getThemeMode();
  }

  Future<void> updateMode(String mode) async {
    await ref.read(settingsRepositoryProvider).setThemeMode(mode);
    ref.invalidateSelf();
  }
}

// ── Language Provider ──────────────────────────────────────────────────────

@riverpod
class AppLanguage extends _$AppLanguage {
  @override
  String build() {
    return ref.watch(settingsRepositoryProvider).getLanguageCode();
  }

  Future<void> updateLanguage(String code) async {
    await ref.read(settingsRepositoryProvider).setLanguageCode(code);
    ref.invalidateSelf();
  }
}

// ── Biometric Provider ─────────────────────────────────────────────────────

@riverpod
class BiometricAuth extends _$BiometricAuth {
  @override
  bool build() {
    return ref.watch(settingsRepositoryProvider).isBiometricEnabled();
  }

  Future<void> toggle(bool enabled) async {
    await ref.read(settingsRepositoryProvider).setBiometricEnabled(enabled);
    ref.invalidateSelf();
  }
}
