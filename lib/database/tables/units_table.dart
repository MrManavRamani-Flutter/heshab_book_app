// lib/database/tables/units_table.dart

import 'package:drift/drift.dart';
import 'shops_table.dart';

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  IntColumn get shopId => integer().references(Shops, #id)();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get abbreviation => text().withLength(max: 10).nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
