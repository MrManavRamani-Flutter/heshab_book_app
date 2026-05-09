// lib/database/tables/bills_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';
import 'suppliers_table.dart';
import 'retailers_table.dart';

/// Bill header table
class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get shopId => integer().references(Shops, #id)();

  // Bill type: 'purchase', 'sales', 'return', 'expense'
  TextColumn get billType => text()();

  // Bill number (e.g. BILL-0001, PB-2025-001)
  TextColumn get billNumber => text().unique()();
  DateTimeColumn get billDate => dateTime()();

  // Party (only one will be set based on billType)
  IntColumn get supplierId => integer().references(Suppliers, #id).nullable()();
  IntColumn get retailerId => integer().references(Retailers, #id).nullable()();

  // Amounts
  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();

  // RULE-008: pendingAmount = totalAmount - paidAmount (calculated, kept in sync)
  RealColumn get pendingAmount => real().withDefault(const Constant(0.0))();

  // Status: 'paid', 'partial', 'pending'
  TextColumn get paymentStatus => text().withDefault(const Constant('pending'))();

  TextColumn get notes => text().nullable()();
}

/// Bill items (line items per bill)
class BillItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get billId => integer().references(Bills, #id)();

  // Snapshot of product at time of billing (not FK — to preserve history)
  TextColumn get productUuid => text()();
  TextColumn get productName => text()();
  TextColumn get productCode => text().nullable()();
  TextColumn get unitName => text().nullable()();

  RealColumn get quantity => real()();
  RealColumn get purchasePrice => real().withDefault(const Constant(0.0))();
  RealColumn get salePrice => real()();
  RealColumn get discountPercent => real().withDefault(const Constant(0.0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get taxPercent => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real()();
}
