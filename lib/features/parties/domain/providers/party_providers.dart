// lib/features/parties/domain/providers/party_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../data/repositories/retailer_repository.dart';

part 'party_providers.g.dart';

// ── Repository Providers ───────────────────────────────────────────────────

@riverpod
SupplierRepository supplierRepository(SupplierRepositoryRef ref) {
  return sl<SupplierRepository>();
}

@riverpod
RetailerRepository retailerRepository(RetailerRepositoryRef ref) {
  return sl<RetailerRepository>();
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

// ── Retailer Providers ──────────────────────────────────────────────────────

@riverpod
Stream<List<Retailer>> shopRetailers(ShopRetailersRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(retailerRepositoryProvider).watchShopRetailers(activeShop.id);
}

@riverpod
Stream<List<Retailer>> searchRetailers(SearchRetailersRef ref, String query) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  if (query.isEmpty) {
    return ref.watch(retailerRepositoryProvider).watchShopRetailers(activeShop.id);
  }
  
  return ref.watch(retailerRepositoryProvider).searchRetailers(activeShop.id, query);
}

@riverpod
Future<Retailer?> retailerDetail(RetailerDetailRef ref, int retailerId) {
  return ref.watch(retailerRepositoryProvider).getRetailerById(retailerId);
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

@riverpod
double totalRetailerReceivable(TotalRetailerReceivableRef ref) {
  final retailersAsync = ref.watch(shopRetailersProvider);
  return retailersAsync.maybeWhen(
    data: (retailers) => retailers.fold(0.0, (sum, r) => sum + r.currentBalance),
    orElse: () => 0.0,
  );
}
