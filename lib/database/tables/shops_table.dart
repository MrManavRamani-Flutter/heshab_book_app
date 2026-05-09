// lib/database/tables/shops_table.dart

import 'package:drift/drift.dart';
import 'users_table.dart';

class Shops extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  // ── Shop Fields ───────────────────────────────────────────────────────────
  // RULE-005: Every shop is owned by a user
  IntColumn get userId => integer().references(Users, #id)();

  TextColumn get shopName => text().withLength(min: 1, max: 200)();
  TextColumn get shopType => text()(); // 'big_hall', 'mix_hall', 'retail'
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get gstNumber => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // Currency
  TextColumn get currencySymbol => text().withDefault(const Constant('₹'))();
}
