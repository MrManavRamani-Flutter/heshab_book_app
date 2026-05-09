// lib/features/parties/data/repositories/supplier_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class SupplierRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  SupplierRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch all suppliers for a shop
  Stream<List<Supplier>> watchShopSuppliers(int shopId) {
    return (_db.select(_db.suppliers)
          ..where((s) => s.shopId.equals(shopId))
          ..where((s) => s.isDeleted.equals(false))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .watch();
  }

  /// Search suppliers by name or phone
  Stream<List<Supplier>> searchSuppliers(int shopId, String query) {
    return (_db.select(_db.suppliers)
          ..where((s) => s.shopId.equals(shopId))
          ..where((s) => s.isDeleted.equals(false))
          ..where((s) =>
              s.name.contains(query) |
              (s.shopName.isNotNull() & s.shopName.contains(query)) |
              (s.phone.isNotNull() & s.phone.contains(query)))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .watch();
  }

  /// Get single supplier
  Future<Supplier?> getSupplierById(int id) {
    return (_db.select(_db.suppliers)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Create a new supplier with optional opening balance
  Future<int> createSupplier({
    required int shopId,
    required String name,
    String? shopName,
    String? phone,
    String? alternatePhone,
    String? email,
    String? gstNumber,
    String? address,
    String? homeAddress,
    String? bankName,
    String? bankAccount,
    String? bankIfsc,
    String? notes,
    double openingBalance = 0.0,
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      
      // 1. Insert Supplier
      final supplierId = await _db.into(_db.suppliers).insert(
            SuppliersCompanion.insert(
              uuid: _uuid.v4(),
              shopId: shopId,
              name: name,
              shopName: Value(shopName),
              phone: Value(phone),
              alternatePhone: Value(alternatePhone),
              email: Value(email),
              gstNumber: Value(gstNumber),
              address: Value(address),
              homeAddress: Value(homeAddress),
              bankName: Value(bankName),
              bankAccount: Value(bankAccount),
              bankIfsc: Value(bankIfsc),
              notes: Value(notes),
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
                supplierId: Value(supplierId),
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

      return supplierId;
    });
  }

  /// Update supplier details
  Future<bool> updateSupplier({
    required int id,
    String? name,
    String? shopName,
    String? phone,
    String? alternatePhone,
    String? email,
    String? gstNumber,
    String? address,
    String? homeAddress,
    String? bankName,
    String? bankAccount,
    String? bankIfsc,
    String? notes,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
          SuppliersCompanion(
            name: name != null ? Value(name) : const Value.absent(),
            shopName: shopName != null ? Value(shopName) : const Value.absent(),
            phone: phone != null ? Value(phone) : const Value.absent(),
            alternatePhone: alternatePhone != null ? Value(alternatePhone) : const Value.absent(),
            email: email != null ? Value(email) : const Value.absent(),
            gstNumber: gstNumber != null ? Value(gstNumber) : const Value.absent(),
            address: address != null ? Value(address) : const Value.absent(),
            homeAddress: homeAddress != null ? Value(homeAddress) : const Value.absent(),
            bankName: bankName != null ? Value(bankName) : const Value.absent(),
            bankAccount: bankAccount != null ? Value(bankAccount) : const Value.absent(),
            bankIfsc: bankIfsc != null ? Value(bankIfsc) : const Value.absent(),
            notes: notes != null ? Value(notes) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  /// Soft delete supplier
  Future<void> deleteSupplier(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
          SuppliersCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
