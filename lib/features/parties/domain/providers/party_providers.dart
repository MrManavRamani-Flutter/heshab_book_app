// lib/features/parties/domain/providers/party_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/supplier_repository.dart';

part 'party_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
SupplierRepository supplierRepository(SupplierRepositoryRef ref) {
  return sl<SupplierRepository>();
}

// ── Supplier Providers ──────────────────────────────────────────────────────

@riverpod
Stream<List<Supplier>> shopSuppliers(ShopSuppliersRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(supplierRepositoryProvider).watchShopSuppliers(activeShop.id);
}

@riverpod
Stream<List<Supplier>> searchSuppliers(SearchSuppliersRef ref, String query) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  if (query.isEmpty) {
    return ref.watch(supplierRepositoryProvider).watchShopSuppliers(activeShop.id);
  }
  
  return ref.watch(supplierRepositoryProvider).searchSuppliers(activeShop.id, query);
}

@riverpod
Future<Supplier?> supplierDetail(SupplierDetailRef ref, int supplierId) {
  return ref.watch(supplierRepositoryProvider).getSupplierById(supplierId);
}

// ── Balance Selectors ─────────────────────────────────────────────────────

@riverpod
double totalSupplierOwed(TotalSupplierOwedRef ref) {
  final suppliersAsync = ref.watch(shopSuppliersProvider);
  return suppliersAsync.maybeWhen(
    data: (suppliers) => suppliers.fold(0.0, (sum, s) => sum + s.currentBalance),
    orElse: () => 0.0,
  );
}
