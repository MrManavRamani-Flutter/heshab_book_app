// lib/database/tables/retailers_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';

class Retailers extends Table {
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
  TextColumn get notes => text().nullable()();

  // Customer type: 'big_hall', 'retailer', 'walk_in'
  TextColumn get customerType => text().withDefault(const Constant('retailer'))();

  // Credit limit (0 = no limit)
  RealColumn get creditLimit => real().withDefault(const Constant(0.0))();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  // positive = they owe you (receivable), negative = you owe them
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();
}
