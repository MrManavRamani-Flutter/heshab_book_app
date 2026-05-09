// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supplierRepositoryHash() =>
    r'e0d3ecd4fd3f5a784d156d04d4b6e75d5b9ab8dd';

/// See also [supplierRepository].
@ProviderFor(supplierRepository)
final supplierRepositoryProvider =
    AutoDisposeProvider<SupplierRepository>.internal(
      supplierRepository,
      name: r'supplierRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supplierRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupplierRepositoryRef = AutoDisposeProviderRef<SupplierRepository>;
String _$retailerRepositoryHash() =>
    r'dbf99e5d43406c931b7bc35600f95a410f8578fd';

/// See also [retailerRepository].
@ProviderFor(retailerRepository)
final retailerRepositoryProvider =
    AutoDisposeProvider<RetailerRepository>.internal(
      retailerRepository,
      name: r'retailerRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$retailerRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RetailerRepositoryRef = AutoDisposeProviderRef<RetailerRepository>;
String _$shopSuppliersHash() => r'fe6ccb930c9b0b40828fc8c7f0a1316321d1482e';

/// See also [shopSuppliers].
@ProviderFor(shopSuppliers)
final shopSuppliersProvider =
    AutoDisposeStreamProvider<List<Supplier>>.internal(
      shopSuppliers,
      name: r'shopSuppliersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shopSuppliersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopSuppliersRef = AutoDisposeStreamProviderRef<List<Supplier>>;
String _$searchSuppliersHash() => r'a23c1c575b05748bccef7e79bb94c6541651efb4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [searchSuppliers].
@ProviderFor(searchSuppliers)
const searchSuppliersProvider = SearchSuppliersFamily();

/// See also [searchSuppliers].
class SearchSuppliersFamily extends Family<AsyncValue<List<Supplier>>> {
  /// See also [searchSuppliers].
  const SearchSuppliersFamily();

  /// See also [searchSuppliers].
  SearchSuppliersProvider call(String query) {
    return SearchSuppliersProvider(query);
  }

  @override
  SearchSuppliersProvider getProviderOverride(
    covariant SearchSuppliersProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchSuppliersProvider';
}

/// See also [searchSuppliers].
class SearchSuppliersProvider
    extends AutoDisposeStreamProvider<List<Supplier>> {
  /// See also [searchSuppliers].
  SearchSuppliersProvider(String query)
    : this._internal(
        (ref) => searchSuppliers(ref as SearchSuppliersRef, query),
        from: searchSuppliersProvider,
        name: r'searchSuppliersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchSuppliersHash,
        dependencies: SearchSuppliersFamily._dependencies,
        allTransitiveDependencies:
            SearchSuppliersFamily._allTransitiveDependencies,
        query: query,
      );

  SearchSuppliersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    Stream<List<Supplier>> Function(SearchSuppliersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchSuppliersProvider._internal(
        (ref) => create(ref as SearchSuppliersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Supplier>> createElement() {
    return _SearchSuppliersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSuppliersProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchSuppliersRef on AutoDisposeStreamProviderRef<List<Supplier>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchSuppliersProviderElement
    extends AutoDisposeStreamProviderElement<List<Supplier>>
    with SearchSuppliersRef {
  _SearchSuppliersProviderElement(super.provider);

  @override
  String get query => (origin as SearchSuppliersProvider).query;
}

String _$supplierDetailHash() => r'0b5f078f6137b07d78365fdb24148ca6f62c5c8e';

/// See also [supplierDetail].
@ProviderFor(supplierDetail)
const supplierDetailProvider = SupplierDetailFamily();

/// See also [supplierDetail].
class SupplierDetailFamily extends Family<AsyncValue<Supplier?>> {
  /// See also [supplierDetail].
  const SupplierDetailFamily();

  /// See also [supplierDetail].
  SupplierDetailProvider call(int supplierId) {
    return SupplierDetailProvider(supplierId);
  }

  @override
  SupplierDetailProvider getProviderOverride(
    covariant SupplierDetailProvider provider,
  ) {
    return call(provider.supplierId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'supplierDetailProvider';
}

/// See also [supplierDetail].
class SupplierDetailProvider extends AutoDisposeFutureProvider<Supplier?> {
  /// See also [supplierDetail].
  SupplierDetailProvider(int supplierId)
    : this._internal(
        (ref) => supplierDetail(ref as SupplierDetailRef, supplierId),
        from: supplierDetailProvider,
        name: r'supplierDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$supplierDetailHash,
        dependencies: SupplierDetailFamily._dependencies,
        allTransitiveDependencies:
            SupplierDetailFamily._allTransitiveDependencies,
        supplierId: supplierId,
      );

  SupplierDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.supplierId,
  }) : super.internal();

  final int supplierId;

  @override
  Override overrideWith(
    FutureOr<Supplier?> Function(SupplierDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SupplierDetailProvider._internal(
        (ref) => create(ref as SupplierDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        supplierId: supplierId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Supplier?> createElement() {
    return _SupplierDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SupplierDetailProvider && other.supplierId == supplierId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, supplierId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SupplierDetailRef on AutoDisposeFutureProviderRef<Supplier?> {
  /// The parameter `supplierId` of this provider.
  int get supplierId;
}

class _SupplierDetailProviderElement
    extends AutoDisposeFutureProviderElement<Supplier?>
    with SupplierDetailRef {
  _SupplierDetailProviderElement(super.provider);

  @override
  int get supplierId => (origin as SupplierDetailProvider).supplierId;
}

String _$shopRetailersHash() => r'cb35d023dee00a3a105cf22c34ee26b2865b92df';

/// See also [shopRetailers].
@ProviderFor(shopRetailers)
final shopRetailersProvider =
    AutoDisposeStreamProvider<List<Retailer>>.internal(
      shopRetailers,
      name: r'shopRetailersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shopRetailersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopRetailersRef = AutoDisposeStreamProviderRef<List<Retailer>>;
String _$searchRetailersHash() => r'112369174b406c49f6ea18e2a8b5facea980b617';

/// See also [searchRetailers].
@ProviderFor(searchRetailers)
const searchRetailersProvider = SearchRetailersFamily();

/// See also [searchRetailers].
class SearchRetailersFamily extends Family<AsyncValue<List<Retailer>>> {
  /// See also [searchRetailers].
  const SearchRetailersFamily();

  /// See also [searchRetailers].
  SearchRetailersProvider call(String query) {
    return SearchRetailersProvider(query);
  }

  @override
  SearchRetailersProvider getProviderOverride(
    covariant SearchRetailersProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchRetailersProvider';
}

/// See also [searchRetailers].
class SearchRetailersProvider
    extends AutoDisposeStreamProvider<List<Retailer>> {
  /// See also [searchRetailers].
  SearchRetailersProvider(String query)
    : this._internal(
        (ref) => searchRetailers(ref as SearchRetailersRef, query),
        from: searchRetailersProvider,
        name: r'searchRetailersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchRetailersHash,
        dependencies: SearchRetailersFamily._dependencies,
        allTransitiveDependencies:
            SearchRetailersFamily._allTransitiveDependencies,
        query: query,
      );

  SearchRetailersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    Stream<List<Retailer>> Function(SearchRetailersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchRetailersProvider._internal(
        (ref) => create(ref as SearchRetailersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Retailer>> createElement() {
    return _SearchRetailersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchRetailersProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchRetailersRef on AutoDisposeStreamProviderRef<List<Retailer>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchRetailersProviderElement
    extends AutoDisposeStreamProviderElement<List<Retailer>>
    with SearchRetailersRef {
  _SearchRetailersProviderElement(super.provider);

  @override
  String get query => (origin as SearchRetailersProvider).query;
}

String _$retailerDetailHash() => r'f498dab12c83f4af3d1582bb1cec41a7a094d3eb';

/// See also [retailerDetail].
@ProviderFor(retailerDetail)
const retailerDetailProvider = RetailerDetailFamily();

/// See also [retailerDetail].
class RetailerDetailFamily extends Family<AsyncValue<Retailer?>> {
  /// See also [retailerDetail].
  const RetailerDetailFamily();

  /// See also [retailerDetail].
  RetailerDetailProvider call(int retailerId) {
    return RetailerDetailProvider(retailerId);
  }

  @override
  RetailerDetailProvider getProviderOverride(
    covariant RetailerDetailProvider provider,
  ) {
    return call(provider.retailerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'retailerDetailProvider';
}

/// See also [retailerDetail].
class RetailerDetailProvider extends AutoDisposeFutureProvider<Retailer?> {
  /// See also [retailerDetail].
  RetailerDetailProvider(int retailerId)
    : this._internal(
        (ref) => retailerDetail(ref as RetailerDetailRef, retailerId),
        from: retailerDetailProvider,
        name: r'retailerDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$retailerDetailHash,
        dependencies: RetailerDetailFamily._dependencies,
        allTransitiveDependencies:
            RetailerDetailFamily._allTransitiveDependencies,
        retailerId: retailerId,
      );

  RetailerDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.retailerId,
  }) : super.internal();

  final int retailerId;

  @override
  Override overrideWith(
    FutureOr<Retailer?> Function(RetailerDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RetailerDetailProvider._internal(
        (ref) => create(ref as RetailerDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        retailerId: retailerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Retailer?> createElement() {
    return _RetailerDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RetailerDetailProvider && other.retailerId == retailerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, retailerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RetailerDetailRef on AutoDisposeFutureProviderRef<Retailer?> {
  /// The parameter `retailerId` of this provider.
  int get retailerId;
}

class _RetailerDetailProviderElement
    extends AutoDisposeFutureProviderElement<Retailer?>
    with RetailerDetailRef {
  _RetailerDetailProviderElement(super.provider);

  @override
  int get retailerId => (origin as RetailerDetailProvider).retailerId;
}

String _$totalSupplierOwedHash() => r'e495b482006a8928d984d469beb5c8404b2042ae';

/// See also [totalSupplierOwed].
@ProviderFor(totalSupplierOwed)
final totalSupplierOwedProvider = AutoDisposeProvider<double>.internal(
  totalSupplierOwed,
  name: r'totalSupplierOwedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalSupplierOwedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalSupplierOwedRef = AutoDisposeProviderRef<double>;
String _$totalRetailerReceivableHash() =>
    r'2f85f16d6501ab7cde51f9dd73d6545591d83893';

/// See also [totalRetailerReceivable].
@ProviderFor(totalRetailerReceivable)
final totalRetailerReceivableProvider = AutoDisposeProvider<double>.internal(
  totalRetailerReceivable,
  name: r'totalRetailerReceivableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalRetailerReceivableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalRetailerReceivableRef = AutoDisposeProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
