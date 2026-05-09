// lib/features/billing/data/repositories/bill_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class BillRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  BillRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch bills for a shop, filtered by type and date
  Stream<List<Bill>> watchBills(int shopId, {String? type, DateTime? startDate, DateTime? endDate}) {
    final query = _db.select(_db.bills)
      ..where((b) => b.shopId.equals(shopId))
      ..where((b) => b.isDeleted.equals(false));
    
    if (type != null) {
      query.where((b) => b.billType.equals(type));
    }

    if (startDate != null) {
      query.where((b) => b.billDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((b) => b.billDate.isSmallerOrEqualValue(endDate));
    }
    
    return (query..orderBy([(b) => OrderingTerm.desc(b.billDate)])).watch();
  }

  /// Get bill with its items
  Future<({Bill bill, List<BillItem> items})?> getBillWithItems(int billId) async {
    final bill = await (_db.select(_db.bills)..where((b) => b.id.equals(billId))).getSingleOrNull();
    if (bill == null) return null;
    
    final items = await (_db.select(_db.billItems)..where((bi) => bi.billId.equals(billId))).get();
    return (bill: bill, items: items);
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Create a complete bill with items, stock updates, and ledger entries.
  /// This is a high-level transaction (RULE-002, RULE-007, RULE-008).
  Future<int> createBill({
    required int shopId,
    required String billType, // 'purchase', 'sales', 'return'
    required DateTime billDate,
    int? supplierId,
    int? retailerId,
    required List<BillItemsCompanion> items,
    double discountAmount = 0.0,
    double taxAmount = 0.0,
    double paidAmount = 0.0,
    String? notes,
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      
      // 1. Calculate totals
      double subtotal = 0;
      for (final item in items) {
        subtotal += item.totalAmount.value;
      }
      final totalAmount = subtotal - discountAmount + taxAmount;
      final pendingAmount = totalAmount - paidAmount;

      // 2. Generate sequential Bill Number (Temporary logic: prefix + count)
      final count = await (_db.select(_db.bills)..where((b) => b.shopId.equals(shopId))).get().then((v) => v.length);
      final prefix = billType == 'purchase' ? 'PB' : (billType == 'sales' ? 'SB' : 'RB');
      final billNumber = '$prefix-${now.year}-${(count + 1).toString().padLeft(4, '0')}';

      // 3. Insert Bill Header
      final billId = await _db.into(_db.bills).insert(
            BillsCompanion.insert(
              uuid: _uuid.v4(),
              shopId: shopId,
              billType: billType,
              billNumber: billNumber,
              billDate: billDate,
              supplierId: Value(supplierId),
              retailerId: Value(retailerId),
              subtotal: Value(subtotal),
              discountAmount: Value(discountAmount),
              taxAmount: Value(taxAmount),
              totalAmount: Value(totalAmount),
              paidAmount: Value(paidAmount),
              pendingAmount: Value(pendingAmount),
              paymentStatus: Value(pendingAmount <= 0 ? 'paid' : (paidAmount > 0 ? 'partial' : 'pending')),
              notes: Value(notes),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      // 4. Insert Bill Items & Update Stock (RULE-002)
      for (var item in items) {
        // Save item
        await _db.into(_db.billItems).insert(item.copyWith(
              uuid: Value(_uuid.v4()),
              billId: Value(billId),
              createdAt: Value(now),
              updatedAt: Value(now),
            ));

        // Update Stock
        // For 'sales': stock decreases (OUT)
        // For 'purchase': stock increases (IN)
        // For 'return': if sales return, stock increases (IN)
        final isOut = billType == 'sales';
        final productUuid = item.productUuid.value;
        
        // Find product by UUID to get ID and current stock
        final product = await (_db.select(_db.products)..where((p) => p.uuid.equals(productUuid))).getSingle();
        
        final change = isOut ? -item.quantity.value : item.quantity.value;
        final stockBefore = product.currentStock;
        final stockAfter = stockBefore + change;

        // Transaction record
        await _db.into(_db.stockTransactions).insert(
              StockTransactionsCompanion.insert(
                uuid: _uuid.v4(),
                shopId: shopId,
                productId: product.id,
                billId: Value(billId),
                transactionType: billType,
                quantity: change,
                stockBefore: stockBefore,
                stockAfter: stockAfter,
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // Update product cache
        await (_db.update(_db.products)..where((p) => p.id.equals(product.id))).write(
              ProductsCompanion(currentStock: Value(stockAfter), updatedAt: Value(now)),
            );
      }

      // 5. Update Party Balance & Ledger (RULE-007)
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

        // Calculate balance after bill
        // For purchase (supplier): balance increases (you owe more)
        // For sales (retailer): balance increases (they owe you more)
        final balanceAfter = currentPartyBalance + totalAmount;

        // Create Ledger entry
        await _db.into(_db.ledgers).insert(
              LedgersCompanion.insert(
                uuid: _uuid.v4(),
                shopId: shopId,
                supplierId: Value(supplierId),
                retailerId: Value(retailerId),
                billId: Value(billId),
                entryType: 'debit', // Simplified for now
                amount: totalAmount,
                balanceAfter: balanceAfter,
                referenceType: 'bill',
                entryDate: billDate,
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

        // 6. If paidAmount > 0, we would usually record a Payment entry too.
        // For Phase 10 simplicity, we assume bill is created and payment might follow,
        // but if paidAmount is provided here, it reduces the balance immediately.
        if (paidAmount > 0) {
           final finalBalance = balanceAfter - paidAmount;
           
           await _db.into(_db.ledgers).insert(
              LedgersCompanion.insert(
                uuid: _uuid.v4(),
                shopId: shopId,
                supplierId: Value(supplierId),
                retailerId: Value(retailerId),
                // reference this bill in payment? 
                entryType: 'credit', 
                amount: paidAmount,
                balanceAfter: finalBalance,
                referenceType: 'payment',
                description: Value('Paid against bill $billNumber'),
                entryDate: billDate,
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

           if (isSupplier) {
            await (_db.update(_db.suppliers)..where((s) => s.id.equals(partyId))).write(
                  SuppliersCompanion(currentBalance: Value(finalBalance), updatedAt: Value(now)),
                );
          } else {
            await (_db.update(_db.retailers)..where((r) => r.id.equals(partyId))).write(
                  RetailersCompanion(currentBalance: Value(finalBalance), updatedAt: Value(now)),
                );
          }
        }
      }

      return billId;
    });
  }

  /// Soft delete bill
  Future<void> deleteBill(int id) async {
    final now = DateTime.now();
    // Note: In real app, deleting a bill should reverse stock and ledger.
    // For now, we just mark as deleted.
    await (_db.update(_db.bills)..where((b) => b.id.equals(id))).write(
          BillsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
