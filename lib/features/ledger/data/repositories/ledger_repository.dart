// lib/features/ledger/data/repositories/ledger_repository.dart

import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';

class LedgerRepository {
  final AppDatabase _db;

  LedgerRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch ledger entries for a party, with optional date filtering
  Stream<List<Ledger>> watchPartyLedger(
    int shopId, {
    int? supplierId,
    int? retailerId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = _db.select(_db.ledgers)
      ..where((l) => l.shopId.equals(shopId))
      ..where((l) => l.isDeleted.equals(false));

    if (supplierId != null) {
      query.where((l) => l.supplierId.equals(supplierId));
    } else if (retailerId != null) {
      query.where((l) => l.retailerId.equals(retailerId));
    }

    if (startDate != null) {
      query.where((l) => l.entryDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((l) => l.entryDate.isSmallerOrEqualValue(endDate));
    }

    return (query..orderBy([(l) => OrderingTerm.asc(l.entryDate), (l) => OrderingTerm.asc(l.id)])).watch();
  }

  /// Get summary of ledger (Total Debit, Total Credit, Opening, Closing)
  Future<({double totalDebit, double totalCredit, double closingBalance})> getLedgerSummary(
    int shopId, {
    int? supplierId,
    int? retailerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final entries = await watchPartyLedger(
      shopId,
      supplierId: supplierId,
      retailerId: retailerId,
      startDate: startDate,
      endDate: endDate,
    ).first;

    double debit = 0;
    double credit = 0;
    
    for (final entry in entries) {
      if (entry.entryType == 'debit') {
        debit += entry.amount;
      } else {
        credit += entry.amount;
      }
    }

    final closing = entries.isNotEmpty ? entries.last.balanceAfter : 0.0;

    return (
      totalDebit: debit,
      totalCredit: credit,
      closingBalance: closing,
    );
  }

  // ── Mutations ────────────────────────────────────────────────────────────
  // Note: Most ledger entries are auto-created by Billing/Payment repositories.
  // We only add manual adjustment capability here.

  Future<int> addManualAdjustment({
    required int shopId,
    int? supplierId,
    int? retailerId,
    required double amount,
    required String entryType, // 'debit' or 'credit'
    required DateTime date,
    String? description,
  }) async {
    // Implement manual adjustment if needed, but per RULE-007, 
    // it's better to keep this minimal.
    // For now, we leave it for the future or handled by specific features.
    return 0; 
  }
}
