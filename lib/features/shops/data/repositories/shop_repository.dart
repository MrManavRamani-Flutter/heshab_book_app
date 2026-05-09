// lib/features/shops/data/repositories/shop_repository.dart
//
// Handles Shop CRUD operations.
// Uses ShopDao for SQLite access and Hive for active shop persistence.

import 'package:drift/drift.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/shop_dao.dart';

class ShopRepository {
  final ShopDao _shopDao;
  final Box _authBox;
  final _uuid = const Uuid();

  ShopRepository({
    required ShopDao shopDao,
    required Box authBox,
  })  : _shopDao = shopDao,
        _authBox = authBox;

  // ── Active Shop ────────────────────────────────────────────────────────────

  /// Get the ID of the currently active shop from Hive
  int? get activeShopId => _authBox.get(AppConstants.keyCurrentShopId);

  /// Set the active shop ID in Hive
  Future<void> setActiveShopId(int shopId) async {
    await _authBox.put(AppConstants.keyCurrentShopId, shopId);
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  /// Stream of all shops for a specific user
  Stream<List<Shop>> watchUserShops(int userId) {
    return _shopDao.watchShopsByUser(userId);
  }

  /// Get list of shops once
  Future<List<Shop>> getUserShops(int userId) {
    return _shopDao.getShopsByUser(userId);
  }

  /// Get a single shop by ID
  Future<Shop?> getShop(int id) {
    return _shopDao.getShopById(id);
  }

  /// Create a new shop
  Future<int> createShop({
    required int userId,
    required String name,
    required String type,
    String? phone,
    String? address,
    String? gstNumber,
  }) async {
    final now = DateTime.now();
    final newId = await _shopDao.insertShop(
      ShopsCompanion.insert(
        uuid: _uuid.v4(),
        userId: userId,
        shopName: name,
        shopType: type,
        phone: Value(phone),
        address: Value(address),
        gstNumber: Value(gstNumber),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    // If this is the first shop, make it active
    if (activeShopId == null) {
      await setActiveShopId(newId);
    }

    return newId;
  }

  /// Update existing shop
  Future<bool> updateShop({
    required int id,
    String? name,
    String? type,
    String? phone,
    String? address,
    String? gstNumber,
  }) async {
    final existing = await _shopDao.getShopById(id);
    if (existing == null) return false;

    final now = DateTime.now();
    return _shopDao.updateShop(
      ShopsCompanion(
        id: Value(id),
        shopName: name != null ? Value(name) : const Value.absent(),
        shopType: type != null ? Value(type) : const Value.absent(),
        phone: phone != null ? Value(phone) : const Value.absent(),
        address: address != null ? Value(address) : const Value.absent(),
        gstNumber: gstNumber != null ? Value(gstNumber) : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  /// Soft delete a shop
  Future<void> deleteShop(int id) async {
    await _shopDao.softDeleteShop(id);
    
    // If the active shop was deleted, clear it or pick another
    if (activeShopId == id) {
      await _authBox.delete(AppConstants.keyCurrentShopId);
    }
  }
}
