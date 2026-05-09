// lib/database/tables/expenses_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get shopId => integer().references(Shops, #id)();

  // category: 'rent', 'salary', 'transport', 'electricity', 'misc', 'other'
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  RealColumn get amount => real()();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get paymentMode => text().withDefault(const Constant('cash'))();
  TextColumn get receiptPath => text().nullable()();
}
