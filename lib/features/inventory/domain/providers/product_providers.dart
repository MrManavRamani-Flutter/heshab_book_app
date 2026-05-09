// lib/features/inventory/domain/providers/product_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/product_repository.dart';

part 'product_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return sl<ProductRepository>();
}

// ── Product Providers ──────────────────────────────────────────────────────

@riverpod
Stream<List<Product>> shopProducts(ShopProductsRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(productRepositoryProvider).watchShopProducts(activeShop.id);
}

@riverpod
Stream<List<Product>> searchProducts(SearchProductsRef ref, String query) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  if (query.isEmpty) {
    return ref.watch(productRepositoryProvider).watchShopProducts(activeShop.id);
  }
  
  return ref.watch(productRepositoryProvider).searchProducts(activeShop.id, query);
}

@riverpod
Future<Product?> productDetail(ProductDetailRef ref, int productId) {
  return ref.watch(productRepositoryProvider).getProductById(productId);
}

// ── Stock Status Selectors ────────────────────────────────────────────────

@riverpod
List<Product> lowStockProducts(LowStockProductsRef ref) {
  final productsAsync = ref.watch(shopProductsProvider);
  return productsAsync.maybeWhen(
    data: (products) => products.where((p) => p.currentStock <= p.minimumStockAlert).toList(),
    orElse: () => [],
  );
}
