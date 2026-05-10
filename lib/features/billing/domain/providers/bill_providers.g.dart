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
String _$shopBillsHash() => r'ecaaa8aa24a43a56b677ee5ea31934c68d8e29da';

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
  ShopBillsProvider call({
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ShopBillsProvider(
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  ShopBillsProvider getProviderOverride(covariant ShopBillsProvider provider) {
    return call(
      type: provider.type,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
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
  ShopBillsProvider({String? type, DateTime? startDate, DateTime? endDate})
    : this._internal(
        (ref) => shopBills(
          ref as ShopBillsRef,
          type: type,
          startDate: startDate,
          endDate: endDate,
        ),
        from: shopBillsProvider,
        name: r'shopBillsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopBillsHash,
        dependencies: ShopBillsFamily._dependencies,
        allTransitiveDependencies: ShopBillsFamily._allTransitiveDependencies,
        type: type,
        startDate: startDate,
        endDate: endDate,
      );

  ShopBillsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;

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
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Bill>> createElement() {
    return _ShopBillsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopBillsProvider &&
        other.type == type &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopBillsRef on AutoDisposeStreamProviderRef<List<Bill>> {
  /// The parameter `type` of this provider.
  String? get type;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _ShopBillsProviderElement
    extends AutoDisposeStreamProviderElement<List<Bill>>
    with ShopBillsRef {
  _ShopBillsProviderElement(super.provider);

  @override
  String? get type => (origin as ShopBillsProvider).type;
  @override
  DateTime? get startDate => (origin as ShopBillsProvider).startDate;
  @override
  DateTime? get endDate => (origin as ShopBillsProvider).endDate;
}

String _$recentTransactionsHash() =>
    r'cf2e66ce22742174dc7e6d3a4b2f4fdab23ba4ab';

/// See also [recentTransactions].
@ProviderFor(recentTransactions)
final recentTransactionsProvider =
    AutoDisposeStreamProvider<List<Bill>>.internal(
      recentTransactions,
      name: r'recentTransactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentTransactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentTransactionsRef = AutoDisposeStreamProviderRef<List<Bill>>;
String _$purchaseBillsHash() => r'898e7d8b14832ccd52e4c6def72c80e8385c915b';

/// See also [purchaseBills].
@ProviderFor(purchaseBills)
const purchaseBillsProvider = PurchaseBillsFamily();

/// See also [purchaseBills].
class PurchaseBillsFamily extends Family<AsyncValue<List<Bill>>> {
  /// See also [purchaseBills].
  const PurchaseBillsFamily();

  /// See also [purchaseBills].
  PurchaseBillsProvider call({DateTime? startDate, DateTime? endDate}) {
    return PurchaseBillsProvider(startDate: startDate, endDate: endDate);
  }

  @override
  PurchaseBillsProvider getProviderOverride(
    covariant PurchaseBillsProvider provider,
  ) {
    return call(startDate: provider.startDate, endDate: provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'purchaseBillsProvider';
}

/// See also [purchaseBills].
class PurchaseBillsProvider extends AutoDisposeStreamProvider<List<Bill>> {
  /// See also [purchaseBills].
  PurchaseBillsProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        (ref) => purchaseBills(
          ref as PurchaseBillsRef,
          startDate: startDate,
          endDate: endDate,
        ),
        from: purchaseBillsProvider,
        name: r'purchaseBillsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$purchaseBillsHash,
        dependencies: PurchaseBillsFamily._dependencies,
        allTransitiveDependencies:
            PurchaseBillsFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  PurchaseBillsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    Stream<List<Bill>> Function(PurchaseBillsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PurchaseBillsProvider._internal(
        (ref) => create(ref as PurchaseBillsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Bill>> createElement() {
    return _PurchaseBillsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseBillsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PurchaseBillsRef on AutoDisposeStreamProviderRef<List<Bill>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _PurchaseBillsProviderElement
    extends AutoDisposeStreamProviderElement<List<Bill>>
    with PurchaseBillsRef {
  _PurchaseBillsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as PurchaseBillsProvider).startDate;
  @override
  DateTime? get endDate => (origin as PurchaseBillsProvider).endDate;
}

String _$salesBillsHash() => r'9f690b4fd5ea14ebb183af61b8bb33dcddad6cdf';

/// See also [salesBills].
@ProviderFor(salesBills)
const salesBillsProvider = SalesBillsFamily();

/// See also [salesBills].
class SalesBillsFamily extends Family<AsyncValue<List<Bill>>> {
  /// See also [salesBills].
  const SalesBillsFamily();

  /// See also [salesBills].
  SalesBillsProvider call({DateTime? startDate, DateTime? endDate}) {
    return SalesBillsProvider(startDate: startDate, endDate: endDate);
  }

  @override
  SalesBillsProvider getProviderOverride(
    covariant SalesBillsProvider provider,
  ) {
    return call(startDate: provider.startDate, endDate: provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'salesBillsProvider';
}

/// See also [salesBills].
class SalesBillsProvider extends AutoDisposeStreamProvider<List<Bill>> {
  /// See also [salesBills].
  SalesBillsProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        (ref) => salesBills(
          ref as SalesBillsRef,
          startDate: startDate,
          endDate: endDate,
        ),
        from: salesBillsProvider,
        name: r'salesBillsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$salesBillsHash,
        dependencies: SalesBillsFamily._dependencies,
        allTransitiveDependencies: SalesBillsFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  SalesBillsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    Stream<List<Bill>> Function(SalesBillsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SalesBillsProvider._internal(
        (ref) => create(ref as SalesBillsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Bill>> createElement() {
    return _SalesBillsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesBillsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SalesBillsRef on AutoDisposeStreamProviderRef<List<Bill>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _SalesBillsProviderElement
    extends AutoDisposeStreamProviderElement<List<Bill>>
    with SalesBillsRef {
  _SalesBillsProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as SalesBillsProvider).startDate;
  @override
  DateTime? get endDate => (origin as SalesBillsProvider).endDate;
}

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

String _$totalSalesAmountHash() => r'518fa3fe2867b0abdafbea64862d28f68f3af9f3';

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
    r'bbe2578667ba96fcb08d7d129d818dbd80d83678';

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
