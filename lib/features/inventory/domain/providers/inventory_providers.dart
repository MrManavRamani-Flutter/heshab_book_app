// lib/features/inventory/domain/providers/inventory_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/unit_repository.dart';
import '../../data/repositories/category_repository.dart';

part 'inventory_providers.g.dart';

// ── Repository Providers ───────────────────────────────────────────────────

@riverpod
UnitRepository unitRepository(UnitRepositoryRef ref) {
  return sl<UnitRepository>();
}

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return sl<CategoryRepository>();
}

// ── Unit Providers ─────────────────────────────────────────────────────────

@riverpod
Stream<List<Unit>> shopUnits(ShopUnitsRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(unitRepositoryProvider).watchShopUnits(activeShop.id);
}

// ── Category Providers ─────────────────────────────────────────────────────

@riverpod
Stream<List<Category>> shopCategories(ShopCategoriesRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(categoryRepositoryProvider).watchShopCategories(activeShop.id);
}

@riverpod
Stream<List<SubCategory>> subCategories(SubCategoriesRef ref, int categoryId) {
  return ref.watch(categoryRepositoryProvider).watchSubCategories(categoryId);
}
