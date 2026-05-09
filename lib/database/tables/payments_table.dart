// lib/database/tables/payments_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';
import 'bills_table.dart';
import 'suppliers_table.dart';
import 'retailers_table.dart';

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get shopId => integer().references(Shops, #id)();

  // payment_direction: 'pay' (you paid supplier) or 'receive' (you received from retailer)
  TextColumn get paymentDirection => text()();

  // Party
  IntColumn get supplierId => integer().references(Suppliers, #id).nullable()();
  IntColumn get retailerId => integer().references(Retailers, #id).nullable()();

  // Optional: linked to a specific bill
  IntColumn get billId => integer().references(Bills, #id).nullable()();

  RealColumn get amount => real()();

  // payment_mode: 'cash', 'bank', 'upi', 'cheque', 'other'
  TextColumn get paymentMode => text().withDefault(const Constant('cash'))();

  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
}
