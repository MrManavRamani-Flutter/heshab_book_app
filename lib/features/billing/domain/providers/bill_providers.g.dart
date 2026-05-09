// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billRepositoryHash() => r'2bee195fd0aa0feaceda077d3feadf123751da3b';

/// See also [billRepository].
@ProviderFor(billRepository)
final billRepositoryProvider = AutoDisposeProvider<BillRepository>.internal(
  billRepository,
  name: r'billRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$billRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BillRepositoryRef = AutoDisposeProviderRef<BillRepository>;
String _$shopBillsHash() => r'6f9bebd4b44653b49ce10379810f7a1c5432b2a9';

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

/// See also [shopBills].
@ProviderFor(shopBills)
const shopBillsProvider = ShopBillsFamily();

/// See also [shopBills].
class ShopBillsFamily extends Family<AsyncValue<List<Bill>>> {
  /// See also [shopBills].
  const ShopBillsFamily();

  /// See also [shopBills].
  ShopBillsProvider call({String? type}) {
    return ShopBillsProvider(type: type);
  }

  @override
  ShopBillsProvider getProviderOverride(covariant ShopBillsProvider provider) {
    return call(type: provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shopBillsProvider';
}

/// See also [shopBills].
class ShopBillsProvider extends AutoDisposeStreamProvider<List<Bill>> {
  /// See also [shopBills].
  ShopBillsProvider({String? type})
    : this._internal(
        (ref) => shopBills(ref as ShopBillsRef, type: type),
        from: shopBillsProvider,
        name: r'shopBillsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopBillsHash,
        dependencies: ShopBillsFamily._dependencies,
        allTransitiveDependencies: ShopBillsFamily._allTransitiveDependencies,
        type: type,
      );

  ShopBillsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String? type;

  @override
  Override overrideWith(
    Stream<List<Bill>> Function(ShopBillsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopBillsProvider._internal(
        (ref) => create(ref as ShopBillsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Bill>> createElement() {
    return _ShopBillsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopBillsProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopBillsRef on AutoDisposeStreamProviderRef<List<Bill>> {
  /// The parameter `type` of this provider.
  String? get type;
}

class _ShopBillsProviderElement
    extends AutoDisposeStreamProviderElement<List<Bill>>
    with ShopBillsRef {
  _ShopBillsProviderElement(super.provider);

  @override
  String? get type => (origin as ShopBillsProvider).type;
}

String _$purchaseBillsHash() => r'd6433771a53ef9b6fe81425da44e9e326f79c787';

/// See also [purchaseBills].
@ProviderFor(purchaseBills)
final purchaseBillsProvider = AutoDisposeStreamProvider<List<Bill>>.internal(
  purchaseBills,
  name: r'purchaseBillsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$purchaseBillsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PurchaseBillsRef = AutoDisposeStreamProviderRef<List<Bill>>;
String _$salesBillsHash() => r'fcabb251c97fda96ca6364bb93eeabdd5df42cfe';

/// See also [salesBills].
@ProviderFor(salesBills)
final salesBillsProvider = AutoDisposeStreamProvider<List<Bill>>.internal(
  salesBills,
  name: r'salesBillsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$salesBillsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SalesBillsRef = AutoDisposeStreamProviderRef<List<Bill>>;
String _$billDetailHash() => r'4cd7b1d8024bbea73591f7ac9ec77b8b0916b0e1';

/// See also [billDetail].
@ProviderFor(billDetail)
const billDetailProvider = BillDetailFamily();

/// See also [billDetail].
class BillDetailFamily
    extends Family<AsyncValue<({Bill bill, List<BillItem> items})?>> {
  /// See also [billDetail].
  const BillDetailFamily();

  /// See also [billDetail].
  BillDetailProvider call(int billId) {
    return BillDetailProvider(billId);
  }

  @override
  BillDetailProvider getProviderOverride(
    covariant BillDetailProvider provider,
  ) {
    return call(provider.billId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'billDetailProvider';
}

/// See also [billDetail].
class BillDetailProvider
    extends AutoDisposeFutureProvider<({Bill bill, List<BillItem> items})?> {
  /// See also [billDetail].
  BillDetailProvider(int billId)
    : this._internal(
        (ref) => billDetail(ref as BillDetailRef, billId),
        from: billDetailProvider,
        name: r'billDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$billDetailHash,
        dependencies: BillDetailFamily._dependencies,
        allTransitiveDependencies: BillDetailFamily._allTransitiveDependencies,
        billId: billId,
      );

  BillDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.billId,
  }) : super.internal();

  final int billId;

  @override
  Override overrideWith(
    FutureOr<({Bill bill, List<BillItem> items})?> Function(
      BillDetailRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BillDetailProvider._internal(
        (ref) => create(ref as BillDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        billId: billId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<({Bill bill, List<BillItem> items})?>
  createElement() {
    return _BillDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillDetailProvider && other.billId == billId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, billId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BillDetailRef
    on AutoDisposeFutureProviderRef<({Bill bill, List<BillItem> items})?> {
  /// The parameter `billId` of this provider.
  int get billId;
}

class _BillDetailProviderElement
    extends
        AutoDisposeFutureProviderElement<({Bill bill, List<BillItem> items})?>
    with BillDetailRef {
  _BillDetailProviderElement(super.provider);

  @override
  int get billId => (origin as BillDetailProvider).billId;
}

String _$totalSalesAmountHash() => r'e7412607a83e1c05b3f68dfb5ea0aaf34eb33e73';

/// See also [totalSalesAmount].
@ProviderFor(totalSalesAmount)
final totalSalesAmountProvider = AutoDisposeProvider<double>.internal(
  totalSalesAmount,
  name: r'totalSalesAmountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalSalesAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalSalesAmountRef = AutoDisposeProviderRef<double>;
String _$totalPurchaseAmountHash() =>
    r'40a408e6c3fce1dc4fe52fde3fbd34904b0e300c';

/// See also [totalPurchaseAmount].
@ProviderFor(totalPurchaseAmount)
final totalPurchaseAmountProvider = AutoDisposeProvider<double>.internal(
  totalPurchaseAmount,
  name: r'totalPurchaseAmountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalPurchaseAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalPurchaseAmountRef = AutoDisposeProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
