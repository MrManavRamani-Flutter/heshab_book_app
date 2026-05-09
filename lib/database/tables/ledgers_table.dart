// lib/database/tables/ledgers_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';
import 'suppliers_table.dart';
import 'retailers_table.dart';
import 'bills_table.dart';
import 'payments_table.dart';

/// RULE-007: Ledger entries are ALWAYS auto-created.
/// Never ask user to manually create a ledger entry.
class Ledgers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get shopId => integer().references(Shops, #id)();

  // Party (one will be set)
  IntColumn get supplierId => integer().references(Suppliers, #id).nullable()();
  IntColumn get retailerId => integer().references(Retailers, #id).nullable()();

  // entry_type: 'debit', 'credit'
  // For supplier: debit = you owe more, credit = you paid
  // For retailer: debit = they owe more, credit = they paid
  TextColumn get entryType => text()();

  RealColumn get amount => real()();
  RealColumn get balanceAfter => real()();

  // Source
  TextColumn get referenceType => text()(); // 'bill', 'payment', 'adjustment'
  IntColumn get billId => integer().references(Bills, #id).nullable()();
  IntColumn get paymentId => integer().references(Payments, #id).nullable()();

  TextColumn get description => text().nullable()();
  DateTimeColumn get entryDate => dateTime()();
}
