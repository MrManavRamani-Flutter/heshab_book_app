// lib/features/billing/domain/providers/bill_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/bill_repository.dart';

part 'bill_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
BillRepository billRepository(BillRepositoryRef ref) {
  return sl<BillRepository>();
}

// ── Bill List Providers ────────────────────────────────────────────────────

@riverpod
Stream<List<Bill>> shopBills(ShopBillsRef ref, {String? type, DateTime? startDate, DateTime? endDate}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(billRepositoryProvider).watchBills(
    activeShop.id, 
    type: type,
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Stream<List<Bill>> recentTransactions(RecentTransactionsRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  // Watch all bills and take top 5
  return ref.watch(billRepositoryProvider).watchBills(activeShop.id).map((list) {
    if (list.length > 5) return list.sublist(0, 5);
    return list;
  });
}

@riverpod
Stream<List<Bill>> purchaseBills(PurchaseBillsRef ref, {DateTime? startDate, DateTime? endDate}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  return ref.watch(billRepositoryProvider).watchBills(
    activeShop.id, 
    type: 'purchase',
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Stream<List<Bill>> salesBills(SalesBillsRef ref, {DateTime? startDate, DateTime? endDate}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  return ref.watch(billRepositoryProvider).watchBills(
    activeShop.id, 
    type: 'sales',
    startDate: startDate,
    endDate: endDate,
  );
}

// ── Bill Detail Provider ───────────────────────────────────────────────────

@riverpod
Future<({Bill bill, List<BillItem> items})?> billDetail(BillDetailRef ref, int billId) {
  return ref.watch(billRepositoryProvider).getBillWithItems(billId);
}

// ── Financial Summary Selectors ───────────────────────────────────────────

@riverpod
double totalSalesAmount(TotalSalesAmountRef ref) {
  final billsAsync = ref.watch(salesBillsProvider());
  return billsAsync.maybeWhen(
    data: (bills) => bills.fold(0.0, (sum, b) => sum + b.totalAmount),
    orElse: () => 0.0,
  );
}

@riverpod
double totalPurchaseAmount(TotalPurchaseAmountRef ref) {
  final billsAsync = ref.watch(purchaseBillsProvider());
  return billsAsync.maybeWhen(
    data: (bills) => bills.fold(0.0, (sum, b) => sum + b.totalAmount),
    orElse: () => 0.0,
  );
}
