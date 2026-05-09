// lib/features/shops/domain/providers/shop_providers.dart
//
// Riverpod providers for Shop management and Active Shop tracking.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../data/repositories/shop_repository.dart';

part 'shop_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
ShopRepository shopRepository(ShopRepositoryRef ref) {
  return sl<ShopRepository>();
}

// ── All User Shops (Stream) ────────────────────────────────────────────────

@riverpod
Stream<List<Shop>> userShops(UserShopsRef ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  
  return ref.watch(shopRepositoryProvider).watchUserShops(user.id);
}

// ── Active Shop Notifier ───────────────────────────────────────────────────

@riverpod
class ActiveShop extends _$ActiveShop {
  @override
  Shop? build() {
    // Initial build: check Hive for active ID, then find in current shops
    final shopsAsync = ref.watch(userShopsProvider);
    final repository = ref.watch(shopRepositoryProvider);
    final activeId = repository.activeShopId;

    return shopsAsync.when(
      data: (shops) {
        if (shops.isEmpty) return null;
        if (activeId != null) {
          try {
            return shops.firstWhere((s) => s.id == activeId);
          } catch (_) {
            // Fallback to first shop if saved ID is invalid
            repository.setActiveShopId(shops.first.id);
            return shops.first;
          }
        }
        // No active ID yet? Set first one
        repository.setActiveShopId(shops.first.id);
        return shops.first;
      },
      loading: () => null,
      error: (e, st) => null,
    );
  }

  /// Change the active shop
  Future<void> switchShop(int shopId) async {
    await ref.read(shopRepositoryProvider).setActiveShopId(shopId);
    // State will auto-update because build() watches userShopsProvider
  }
}
