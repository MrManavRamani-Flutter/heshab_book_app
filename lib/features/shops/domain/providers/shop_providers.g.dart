// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopRepositoryHash() => r'516760b32931ecc6761d5c181fa0a8ab37f30156';

/// See also [shopRepository].
@ProviderFor(shopRepository)
final shopRepositoryProvider = AutoDisposeProvider<ShopRepository>.internal(
  shopRepository,
  name: r'shopRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shopRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopRepositoryRef = AutoDisposeProviderRef<ShopRepository>;
String _$userShopsHash() => r'1db9f5643e59537e00efbadfd8ce981959417188';

/// See also [userShops].
@ProviderFor(userShops)
final userShopsProvider = AutoDisposeStreamProvider<List<Shop>>.internal(
  userShops,
  name: r'userShopsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userShopsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserShopsRef = AutoDisposeStreamProviderRef<List<Shop>>;
String _$activeShopHash() => r'96673f648eab7d1f77402a380e276518903d4980';

/// See also [ActiveShop].
@ProviderFor(ActiveShop)
final activeShopProvider =
    AutoDisposeNotifierProvider<ActiveShop, Shop?>.internal(
      ActiveShop.new,
      name: r'activeShopProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeShopHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveShop = AutoDisposeNotifier<Shop?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
