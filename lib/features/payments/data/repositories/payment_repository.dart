// lib/features/payments/data/repositories/payment_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class PaymentRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  PaymentRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch payments for a shop
  Stream<List<Payment>> watchShopPayments(int shopId) {
    return (_db.select(_db.payments)
          ..where((p) => p.shopId.equals(shopId))
          ..where((p) => p.isDeleted.equals(false))
          ..orderBy([(p) => OrderingTerm.desc(p.paymentDate)]))
        .watch();
  }

  /// Watch payments for a specific party
  Stream<List<Payment>> watchPartyPayments(int shopId, {int? supplierId, int? retailerId}) {
    final query = _db.select(_db.payments)
      ..where((p) => p.shopId.equals(shopId))
      ..where((p) => p.isDeleted.equals(false));
    
    if (supplierId != null) {
      query.where((p) => p.supplierId.equals(supplierId));
    } else if (retailerId != null) {
      query.where((p) => p.retailerId.equals(retailerId));
    }
    
    return (query..orderBy([(p) => OrderingTerm.desc(p.paymentDate)])).watch();
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Record a payment and update ledger (RULE-007)
  Future<int> recordPayment({
    required int shopId,
    required String direction, // 'pay' or 'receive'
    int? supplierId,
    int? retailerId,
    int? billId,
    required double amount,
    String paymentMode = 'cash',
    required DateTime paymentDate,
    String? referenceNumber,
    String? notes,
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      
      // 1. Insert Payment Record
      final paymentId = await _db.into(_db.payments).insert(
            PaymentsCompanion.insert(
              uuid: _uuid.v4(),
              shopId: shopId,
              paymentDirection: direction,
              supplierId: Value(supplierId),
              retailerId: Value(retailerId),
              billId: Value(billId),
              amount: amount,
              paymentMode: Value(paymentMode),
              paymentDate: paymentDate,
              referenceNumber: Value(referenceNumber),
              notes: Value(notes),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      // 2. Update Party Balance & Create Ledger Entry
      if (supplierId != null || retailerId != null) {
        final isSupplier = supplierId != null;
        final partyId = isSupplier ? supplierId : retailerId!;
        
        // Get current party balance
        double currentPartyBalance = 0;
        if (isSupplier) {
          final s = await (_db.select(_db.suppliers)..where((s) => s.id.equals(partyId))).getSingle();
          currentPartyBalance = s.currentBalance;
        } else {
          final r = await (_db.select(_db.retailers)..where((r) => r.id.equals(partyId))).getSingle();
          currentPartyBalance = r.currentBalance;
        }

        // Calculate balance after payment
        // For 'pay' (to supplier): balance decreases (you owe less)
        // For 'receive' (from retailer): balance decreases (they owe you less)
        final balanceAfter = currentPartyBalance - amount;

        // Create Ledger entry (RULE-007)
        await _db.into(_db.ledgers).insert(
              LedgersCompanion.insert(
                uuid: _uuid.v4(),
                shopId: shopId,
                supplierId: Value(supplierId),
                retailerId: Value(retailerId),
                paymentId: Value(paymentId),
                billId: Value(billId),
                entryType: 'credit', // Credit reduces the balance in this system's logic
                amount: amount,
                balanceAfter: balanceAfter,
                referenceType: 'payment',
                description: Value(notes ?? 'Payment recorded'),
                entryDate: paymentDate,
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // Update Party Balance cache
        if (isSupplier) {
          await (_db.update(_db.suppliers)..where((s) => s.id.equals(partyId))).write(
                SuppliersCompanion(currentBalance: Value(balanceAfter), updatedAt: Value(now)),
              );
        } else {
          await (_db.update(_db.retailers)..where((r) => r.id.equals(partyId))).write(
                RetailersCompanion(currentBalance: Value(balanceAfter), updatedAt: Value(now)),
              );
        }

        // 3. If linked to a bill, update bill's paidAmount and pendingAmount (RULE-008)
        if (billId != null) {
          final bill = await (_db.select(_db.bills)..where((b) => b.id.equals(billId))).getSingle();
          final newPaidAmount = bill.paidAmount + amount;
          final newPendingAmount = bill.totalAmount - newPaidAmount;
          
          await (_db.update(_db.bills)..where((b) => b.id.equals(billId))).write(
                BillsCompanion(
                  paidAmount: Value(newPaidAmount),
                  pendingAmount: Value(newPendingAmount),
                  paymentStatus: Value(newPendingAmount <= 0 ? 'paid' : (newPaidAmount > 0 ? 'partial' : 'pending')),
                  updatedAt: Value(now),
                ),
              );
        }
      }

      return paymentId;
    });
  }

  /// Soft delete payment
  Future<void> deletePayment(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.payments)..where((p) => p.id.equals(id))).write(
          PaymentsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
