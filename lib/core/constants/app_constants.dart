// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String appName = 'Heshab Book';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.manav.heshabpro';

  // Database
  static const String dbName = 'heshab_book.db';
  static const int dbVersion = 1;

  // Hive boxes
  static const String authBox = 'auth_box';
  static const String settingsBox = 'settings_box';

  // Hive keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyCurrentUserId = 'current_user_id';
  static const String keyCurrentShopId = 'current_shop_id';
  static const String keyAppLanguage = 'app_language';
  static const String keyAppTheme = 'app_theme';

  // Supported locales
  static const List<String> supportedLocales = ['en', 'hi', 'gu'];
  static const String defaultLocale = 'en';

  // Default Units
  static const List<String> defaultUnits = [
    'Piece', 'KG', 'Gram', 'Meter', 'Inch',
    'Liter', 'Box', 'Packet', 'Qty',
  ];

  // Default Categories
  static const List<String> defaultCategories = [
    'Cloth', 'Electric', 'Grocery', 'General',
  ];

  // Payment Status
  static const String statusPaid = 'paid';
  static const String statusPartial = 'partial';
  static const String statusPending = 'pending';

  // Sync Status
  static const String syncPending = 'pending';
  static const String syncSynced = 'synced';
  static const String syncFailed = 'failed';

  // Bill Types
  static const String billTypePurchase = 'purchase';
  static const String billTypeSales = 'sales';
  static const String billTypeReturn = 'return';
  static const String billTypeExpense = 'expense';

  // Stock Movement Types
  static const String stockIn = 'purchase';
  static const String stockOut = 'sale';
  static const String stockReturn = 'return';
  static const String stockDamage = 'damage';
  static const String stockAdjustment = 'adjustment';
}
