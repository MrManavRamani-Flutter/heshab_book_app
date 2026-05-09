// lib/database/tables/users_table.dart

import 'package:drift/drift.dart';

class Users extends Table {
  // ── Base Fields (RULE-004: Every table must have these) ───────────────────
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  // ── User Fields ───────────────────────────────────────────────────────────
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get mobile => text().withLength(min: 10, max: 15).nullable()();
  TextColumn get email => text().withLength(max: 200).nullable()();
  TextColumn get passwordHash => text()();        // RULE: Always hash, never plaintext
  TextColumn get profilePhoto => text().nullable()();
  TextColumn get preferredLanguage => text().withDefault(const Constant('en'))();
}
