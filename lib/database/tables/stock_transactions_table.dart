// lib/database/tables/stock_transactions_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';
import 'products_table.dart';
import 'bills_table.dart';

/// RULE-002: Stock is NEVER edited directly.
/// Every stock change creates a record here.
/// currentStock on Products is a cached derived value.
class StockTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get shopId => integer().references(Shops, #id)();
  IntColumn get productId => integer().references(Products, #id)();

  // type: 'purchase', 'sale', 'return', 'damage', 'adjustment'
  TextColumn get transactionType => text()();

  // positive = stock in, negative = stock out
  RealColumn get quantity => real()();

  // Optional: linked to a bill
  IntColumn get billId => integer().references(Bills, #id).nullable()();

  // Stock snapshot for audit
  RealColumn get stockBefore => real()();
  RealColumn get stockAfter => real()();

  TextColumn get notes => text().nullable()();
}
