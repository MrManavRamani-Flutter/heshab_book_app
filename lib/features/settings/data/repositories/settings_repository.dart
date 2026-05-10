// lib/features/settings/data/repositories/settings_repository.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../database/app_database.dart';
import 'package:drift/drift.dart';

class SettingsRepository {
  final Box _box;
  final AppDatabase _db;

  static const String _themeKey = 'theme_mode';
  static const String _langKey = 'language_code';
  static const String _authBioKey = 'biometric_enabled';

  SettingsRepository(this._box, this._db);

  // ── User Preferences (Hive) ──────────────────────────────────────────────

  String getThemeMode() => _box.get(_themeKey, defaultValue: 'system');
  Future<void> setThemeMode(String mode) => _box.put(_themeKey, mode);

  String getLanguageCode() => _box.get(_langKey, defaultValue: 'en');
  Future<void> setLanguageCode(String code) => _box.put(_langKey, code);

  bool isBiometricEnabled() => _box.get(_authBioKey, defaultValue: false);
  Future<void> setBiometricEnabled(bool enabled) => _box.put(_authBioKey, enabled);

  // ── Shop Profile (Drift) ──────────────────────────────────────────────────

  Future<bool> updateShopProfile({
    required int shopId,
    String? shopName,
    String? address,
    String? phone,
    String? email,
    String? gstNumber,
    String? logoPath,
    String? currencySymbol,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.shops)..where((s) => s.id.equals(shopId))).write(
          ShopsCompanion(
            shopName: shopName != null ? Value(shopName) : const Value.absent(),
            address: address != null ? Value(address) : const Value.absent(),
            phone: phone != null ? Value(phone) : const Value.absent(),
            email: email != null ? Value(email) : const Value.absent(),
            gstNumber: gstNumber != null ? Value(gstNumber) : const Value.absent(),
            logoPath: logoPath != null ? Value(logoPath) : const Value.absent(),
            currencySymbol: currencySymbol != null ? Value(currencySymbol) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  // ── Data Management ───────────────────────────────────────────────────────

  /// Note: Real implementation would involve file pickers and sqlite file manipulation.
  Future<String?> exportBackup() async {
    // Logic to copy heshab_book.sqlite to a public folder
    return null;
  }
}
