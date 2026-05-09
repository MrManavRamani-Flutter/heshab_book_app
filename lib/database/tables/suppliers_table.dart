// lib/database/tables/suppliers_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get shopId => integer().references(Shops, #id)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get shopName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get alternatePhone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get gstNumber => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get homeAddress => text().nullable()();
  TextColumn get bankName => text().nullable()();
  TextColumn get bankAccount => text().nullable()();
  TextColumn get bankIfsc => text().nullable()();
  TextColumn get notes => text().nullable()();
  // Opening balance — what you owed them when you started using app
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  // positive = you owe them, negative = they owe you
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();
}
