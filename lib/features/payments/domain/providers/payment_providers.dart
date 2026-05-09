// lib/features/payments/domain/providers/payment_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/payment_repository.dart';

part 'payment_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
PaymentRepository paymentRepository(PaymentRepositoryRef ref) {
  return sl<PaymentRepository>();
}

// ── Payment List Providers ──────────────────────────────────────────────────

@riverpod
Stream<List<Payment>> shopPayments(ShopPaymentsRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(paymentRepositoryProvider).watchShopPayments(activeShop.id);
}

@riverpod
Stream<List<Payment>> partyPayments(PartyPaymentsRef ref, {int? supplierId, int? retailerId}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(paymentRepositoryProvider).watchPartyPayments(
    activeShop.id,
    supplierId: supplierId,
    retailerId: retailerId,
  );
}

// ── Cash Flow Selectors ───────────────────────────────────────────────────

@riverpod
double totalPaymentsMade(TotalPaymentsMadeRef ref) {
  final paymentsAsync = ref.watch(shopPaymentsProvider);
  return paymentsAsync.maybeWhen(
    data: (payments) => payments
        .where((p) => p.paymentDirection == 'pay')
        .fold(0.0, (sum, p) => sum + p.amount),
    orElse: () => 0.0,
  );
}

@riverpod
double totalPaymentsReceived(TotalPaymentsReceivedRef ref) {
  final paymentsAsync = ref.watch(shopPaymentsProvider);
  return paymentsAsync.maybeWhen(
    data: (payments) => payments
        .where((p) => p.paymentDirection == 'receive')
        .fold(0.0, (sum, p) => sum + p.amount),
    orElse: () => 0.0,
  );
}
