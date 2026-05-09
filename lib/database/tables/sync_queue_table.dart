// lib/database/tables/sync_queue_table.dart

import 'package:drift/drift.dart';

/// Future cloud sync queue — every offline write is queued here
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Which table and record to sync
  TextColumn get entityTable => text()();
  TextColumn get recordUuid => text()();

  // operation: 'insert', 'update', 'delete'
  TextColumn get operation => text()();

  // JSON payload of the record
  TextColumn get payload => text()();

  // status: 'pending', 'syncing', 'synced', 'failed'
  TextColumn get status => text().withDefault(const Constant('pending'))();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
}
