// lib/features/inventory/data/repositories/unit_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class UnitRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  UnitRepository(this._db);

  /// Get all units for a specific shop
  Stream<List<Unit>> watchShopUnits(int shopId) {
    return (_db.select(_db.units)
          ..where((u) => u.shopId.equals(shopId))
          ..where((u) => u.isDeleted.equals(false))
          ..orderBy([(u) => OrderingTerm.asc(u.name)]))
        .watch();
  }

  /// Create a new unit
  Future<int> createUnit({
    required int shopId,
    required String name,
    String? abbreviation,
  }) async {
    final now = DateTime.now();
    return _db.into(_db.units).insert(
          UnitsCompanion.insert(
            uuid: _uuid.v4(),
            shopId: shopId,
            name: name,
            abbreviation: Value(abbreviation),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  /// Update unit
  Future<bool> updateUnit({
    required int id,
    String? name,
    String? abbreviation,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.units)..where((u) => u.id.equals(id))).write(
          UnitsCompanion(
            name: name != null ? Value(name) : const Value.absent(),
            abbreviation: abbreviation != null ? Value(abbreviation) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  /// Soft delete unit
  Future<void> deleteUnit(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.units)..where((u) => u.id.equals(id))).write(
          UnitsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
