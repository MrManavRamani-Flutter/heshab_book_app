// lib/database/daos/shop_dao.dart

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/shops_table.dart';

part 'shop_dao.g.dart';

@DriftAccessor(tables: [Shops])
class ShopDao extends DatabaseAccessor<AppDatabase> with _$ShopDaoMixin {
  ShopDao(super.db);

  /// Get all active shops for a user
  Stream<List<Shop>> watchShopsByUser(int userId) {
    return (select(shops)
          ..where((s) => s.userId.equals(userId))
          ..where((s) => s.isDeleted.equals(false))
          ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]))
        .watch();
  }

  /// Get all shops for a user (once)
  Future<List<Shop>> getShopsByUser(int userId) {
    return (select(shops)
          ..where((s) => s.userId.equals(userId))
          ..where((s) => s.isDeleted.equals(false)))
        .get();
  }

  /// Get shop by ID
  Future<Shop?> getShopById(int id) {
    return (select(shops)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  /// Insert new shop — returns new ID
  Future<int> insertShop(ShopsCompanion entry) {
    return into(shops).insert(entry);
  }

  /// Update shop
  Future<bool> updateShop(ShopsCompanion entry) async {
    final count = await (update(shops)..where((s) => s.id.equals(entry.id.value))).write(entry);
    return count > 0;
  }

  /// Count shops for a user
  Future<int> countShopsForUser(int userId) async {
    final shops = await getShopsByUser(userId);
    return shops.length;
  }

  /// Soft delete
  Future<void> softDeleteShop(int id) {
    return (update(shops)..where((s) => s.id.equals(id))).write(
      ShopsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
