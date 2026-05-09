// lib/features/ledger/domain/providers/ledger_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/ledger_repository.dart';

part 'ledger_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
LedgerRepository ledgerRepository(LedgerRepositoryRef ref) {
  return sl<LedgerRepository>();
}

// ── Ledger History Providers ───────────────────────────────────────────────

@riverpod
Stream<List<Ledger>> partyLedger(
  PartyLedgerRef ref, {
  int? supplierId,
  int? retailerId,
  DateTime? startDate,
  DateTime? endDate,
}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(ledgerRepositoryProvider).watchPartyLedger(
    activeShop.id,
    supplierId: supplierId,
    retailerId: retailerId,
    startDate: startDate,
    endDate: endDate,
  );
}

// ── Ledger Summary Provider ────────────────────────────────────────────────

@riverpod
Future<({double totalDebit, double totalCredit, double closingBalance})> ledgerSummary(
  LedgerSummaryRef ref, {
  int? supplierId,
  int? retailerId,
  DateTime? startDate,
  DateTime? endDate,
}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) {
    return Future.value((totalDebit: 0.0, totalCredit: 0.0, closingBalance: 0.0));
  }
  
  return ref.watch(ledgerRepositoryProvider).getLedgerSummary(
    activeShop.id,
    supplierId: supplierId,
    retailerId: retailerId,
    startDate: startDate,
    endDate: endDate,
  );
}
