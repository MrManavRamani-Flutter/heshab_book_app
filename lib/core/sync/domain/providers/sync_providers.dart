// lib/core/sync/domain/providers/sync_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/sync_repository.dart';

part 'sync_providers.g.dart';

@riverpod
SyncRepository syncRepository(SyncRepositoryRef ref) {
  return sl<SyncRepository>();
}

@riverpod
Stream<int> pendingSyncCount(PendingSyncCountRef ref) {
  final db = sl<AppDatabase>();
  return (db.selectOnly(db.syncQueue)
        ..addColumns([db.syncQueue.id.count()])
        ..where(db.syncQueue.status.equals('pending') | db.syncQueue.status.equals('failed')))
      .watch()
      .map((rows) => rows.first.read(db.syncQueue.id.count()) ?? 0);
}
