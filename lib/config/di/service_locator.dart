// lib/config/di/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../database/app_database.dart';
import '../../database/daos/user_dao.dart';
import '../../database/daos/shop_dao.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/shops/data/repositories/shop_repository.dart';
import '../../features/inventory/data/repositories/unit_repository.dart';
import '../../features/inventory/data/repositories/category_repository.dart';
import '../../features/inventory/data/repositories/product_repository.dart';
import '../../features/inventory/data/repositories/stock_repository.dart';
import '../../features/billing/data/repositories/bill_repository.dart';
import '../../features/payments/data/repositories/payment_repository.dart';
import '../../features/ledger/data/repositories/ledger_repository.dart';
import '../../features/expenses/data/repositories/expense_repository.dart';
import '../../features/reports/data/repositories/report_repository.dart';
import '../../features/settings/data/repositories/settings_repository.dart';
import '../../core/sync/data/repositories/sync_repository.dart';
import '../../features/parties/data/repositories/supplier_repository.dart';
import '../../features/parties/data/repositories/retailer_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── Database (Singleton) ───────────────────────────────────────────────────
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // ── DAOs (depend on AppDatabase) ───────────────────────────────────────────
  sl.registerSingleton<UserDao>(sl<AppDatabase>().userDao);
  sl.registerSingleton<ShopDao>(sl<AppDatabase>().shopDao);

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerSingleton<AuthRepository>(
    AuthRepository(
      userDao: sl<UserDao>(),
      shopDao: sl<ShopDao>(),
      authBox: Hive.box(AppConstants.authBox),
    ),
  );

  sl.registerSingleton<ShopRepository>(
    ShopRepository(
      shopDao: sl<ShopDao>(),
      authBox: Hive.box(AppConstants.authBox),
    ),
  );

  sl.registerSingleton<UnitRepository>(
    UnitRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<CategoryRepository>(
    CategoryRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<ProductRepository>(
    ProductRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<StockRepository>(
    StockRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<BillRepository>(
    BillRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<PaymentRepository>(
    PaymentRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<LedgerRepository>(
    LedgerRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<ExpenseRepository>(
    ExpenseRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<ReportRepository>(
    ReportRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<SettingsRepository>(
    SettingsRepository(
      Hive.box(AppConstants.settingsBox),
      sl<AppDatabase>(),
    ),
  );

  sl.registerSingleton<SyncRepository>(
    SyncRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<SupplierRepository>(
    SupplierRepository(sl<AppDatabase>()),
  );

  sl.registerSingleton<RetailerRepository>(
    RetailerRepository(sl<AppDatabase>()),
  );

  // ── Future: Other Repositories (added per phase) ───────────────────────────
  // Phase 4:  sl.registerSingleton<ShopRepository>(...)
  // Phase 5:  sl.registerSingleton<CategoryRepository>(...)
  // Phase 6:  sl.registerSingleton<ProductRepository>(...)
  // Phase 7:  sl.registerSingleton<SupplierRepository>(...)
  // Phase 8:  sl.registerSingleton<RetailerRepository>(...)
  // Phase 9:  sl.registerSingleton<StockRepository>(...)
  // Phase 10: sl.registerSingleton<BillRepository>(...)
  // Phase 11: sl.registerSingleton<PaymentRepository>(...)
  // Phase 12: sl.registerSingleton<LedgerRepository>(...)
  // Phase 13: sl.registerSingleton<ExpenseRepository>(...)
}
