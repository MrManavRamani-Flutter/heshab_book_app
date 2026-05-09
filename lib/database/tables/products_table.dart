// lib/database/tables/products_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';
import 'categories_table.dart';
import 'units_table.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  // RULE-005: Shop scoped
  IntColumn get shopId => integer().references(Shops, #id)();

  // Product Info
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get code => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get description => text().nullable()();

  // Category
  IntColumn get categoryId => integer().references(Categories, #id).nullable()();
  IntColumn get subCategoryId => integer().references(SubCategories, #id).nullable()();
  IntColumn get unitId => integer().references(Units, #id).nullable()();

  // Pricing
  RealColumn get purchasePrice => real().withDefault(const Constant(0.0))();
  RealColumn get wholesalePrice => real().withDefault(const Constant(0.0))();
  RealColumn get retailPrice => real().withDefault(const Constant(0.0))();
  RealColumn get customPrice => real().withDefault(const Constant(0.0))();

  // Stock
  // RULE-002: currentStock is READ ONLY — always derived from stock_transactions
  // This field is a cached value only, updated by triggers/app logic
  RealColumn get currentStock => real().withDefault(const Constant(0.0))();
  RealColumn get minimumStockAlert => real().withDefault(const Constant(5.0))();

  // Status
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get imagePath => text().nullable()();
}
