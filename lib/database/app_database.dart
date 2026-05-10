// lib/database/app_database.dart
//
// RULE-009: Use Drift with AppDatabase as a singleton (via GetIt).
// All table access goes through this class and its DAOs.

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Tables
import 'tables/users_table.dart';
import 'tables/shops_table.dart';
import 'tables/categories_table.dart';
import 'tables/units_table.dart';
import 'tables/products_table.dart';
import 'tables/suppliers_table.dart';
import 'tables/retailers_table.dart';
import 'tables/stock_transactions_table.dart';
import 'tables/bills_table.dart';
import 'tables/payments_table.dart';
import 'tables/ledgers_table.dart';
import 'tables/expenses_table.dart';
import 'tables/sync_queue_table.dart';

// DAOs
import 'daos/user_dao.dart';
import 'daos/shop_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Shops,
    Categories,
    SubCategories,
    Units,
    Products,
    StockTransactions,
    Suppliers,
    Retailers,
    Bills,
    BillItems,
    Payments,
    Ledgers,
    Expenses,
    SyncQueue,
  ],
  daos: [
    UserDao,
    ShopDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations will be added here as schemaVersion increases.
        // NEVER modify existing columns — always add new ones.
      },
      beforeOpen: (details) async {
        // Enable foreign keys (IMPORTANT for SQLite)
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'heshab_book');
}
