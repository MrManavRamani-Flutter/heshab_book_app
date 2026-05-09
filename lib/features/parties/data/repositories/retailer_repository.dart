// lib/features/parties/data/repositories/retailer_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class RetailerRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  RetailerRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch all retailers for a shop
  Stream<List<Retailer>> watchShopRetailers(int shopId) {
    return (_db.select(_db.retailers)
          ..where((r) => r.shopId.equals(shopId))
          ..where((r) => r.isDeleted.equals(false))
          ..orderBy([(r) => OrderingTerm.asc(r.name)]))
        .watch();
  }

  /// Search retailers by name or phone
  Stream<List<Retailer>> searchRetailers(int shopId, String query) {
    return (_db.select(_db.retailers)
          ..where((r) => r.shopId.equals(shopId))
          ..where((r) => r.isDeleted.equals(false))
          ..where((r) =>
              r.name.contains(query) |
              (r.shopName.isNotNull() & r.shopName.contains(query)) |
              (r.phone.isNotNull() & r.phone.contains(query)))
          ..orderBy([(r) => OrderingTerm.asc(r.name)]))
        .watch();
  }

  /// Get single retailer
  Future<Retailer?> getRetailerById(int id) {
    return (_db.select(_db.retailers)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Create a new retailer with optional opening balance
  Future<int> createRetailer({
    required int shopId,
    required String name,
    String? shopName,
    String? phone,
    String? alternatePhone,
    String? email,
    String? gstNumber,
    String? address,
    String? notes,
    String customerType = 'retailer',
    double creditLimit = 0.0,
    double openingBalance = 0.0,
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      
      // 1. Insert Retailer
      final retailerId = await _db.into(_db.retailers).insert(
            RetailersCompanion.insert(
              uuid: _uuid.v4(),
              shopId: shopId,
              name: name,
              shopName: Value(shopName),
              phone: Value(phone),
              alternatePhone: Value(alternatePhone),
              email: Value(email),
              gstNumber: Value(gstNumber),
              address: Value(address),
              notes: Value(notes),
              customerType: Value(customerType),
              creditLimit: Value(creditLimit),
              openingBalance: Value(openingBalance),
              currentBalance: Value(openingBalance),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      // 2. If opening balance != 0, create Ledger entry (RULE-007)
      if (openingBalance != 0) {
        await _db.into(_db.ledgers).insert(
              LedgersCompanion.insert(
                uuid: _uuid.v4(),
                shopId: shopId,
                retailerId: Value(retailerId),
                entryType: openingBalance > 0 ? 'debit' : 'credit',
                amount: openingBalance.abs(),
                balanceAfter: openingBalance,
                referenceType: 'adjustment',
                description: const Value('Opening Balance'),
                entryDate: now,
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      }

      return retailerId;
    });
  }

  /// Update retailer details
  Future<bool> updateRetailer({
    required int id,
    String? name,
    String? shopName,
    String? phone,
    String? alternatePhone,
    String? email,
    String? gstNumber,
    String? address,
    String? notes,
    String? customerType,
    double? creditLimit,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.retailers)..where((r) => r.id.equals(id))).write(
          RetailersCompanion(
            name: name != null ? Value(name) : const Value.absent(),
            shopName: shopName != null ? Value(shopName) : const Value.absent(),
            phone: phone != null ? Value(phone) : const Value.absent(),
            alternatePhone: alternatePhone != null ? Value(alternatePhone) : const Value.absent(),
            email: email != null ? Value(email) : const Value.absent(),
            gstNumber: gstNumber != null ? Value(gstNumber) : const Value.absent(),
            address: address != null ? Value(address) : const Value.absent(),
            notes: notes != null ? Value(notes) : const Value.absent(),
            customerType: customerType != null ? Value(customerType) : const Value.absent(),
            creditLimit: creditLimit != null ? Value(creditLimit) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  /// Soft delete retailer
  Future<void> deleteRetailer(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.retailers)..where((r) => r.id.equals(id))).write(
          RetailersCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
