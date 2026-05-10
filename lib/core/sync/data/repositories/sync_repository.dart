// lib/core/sync/data/repositories/sync_repository.dart

import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import 'package:uuid/uuid.dart';

class SyncRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  SyncRepository(this._db);

  /// Queue an operation for synchronization
  Future<void> queueOperation({
    required String entityTable,
    required String recordUuid,
    required String operation,
    required String payloadJson,
  }) async {
    await _db.into(_db.syncQueue).insert(
          SyncQueueCompanion.insert(
            uuid: _uuid.v4(),
            entityTable: entityTable,
            recordUuid: recordUuid,
            operation: operation,
            payload: payloadJson,
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Get pending operations from the queue
  Future<List<SyncQueueData>> getPendingOperations() {
    return (_db.select(_db.syncQueue)
          ..where((t) => t.status.equals('pending') | t.status.equals('failed'))
          ..where((t) => t.retryCount.isSmallerThanValue(5))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Mark operation as synced
  Future<void> markAsSynced(int id) {
    return (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
          SyncQueueCompanion(
            status: const Value('synced'),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Mark operation as failed and increment retry count
  Future<void> markAsFailed(int id, String error) async {
    final record = await (_db.select(_db.syncQueue)..where((t) => t.id.equals(id))).getSingle();
    await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
          SyncQueueCompanion(
            status: const Value('failed'),
            retryCount: Value(record.retryCount + 1),
            errorMessage: Value(error),
            lastAttemptAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}
