// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ledgerRepositoryHash() => r'08780b5f3c4079ba4c98c29161e68a86f9bdc471';

/// See also [ledgerRepository].
@ProviderFor(ledgerRepository)
final ledgerRepositoryProvider = AutoDisposeProvider<LedgerRepository>.internal(
  ledgerRepository,
  name: r'ledgerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ledgerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LedgerRepositoryRef = AutoDisposeProviderRef<LedgerRepository>;
String _$partyLedgerHash() => r'4ddcd6571439bb29a4b2998741359b20e2969df7';

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

/// See also [partyLedger].
@ProviderFor(partyLedger)
const partyLedgerProvider = PartyLedgerFamily();

/// See also [partyLedger].
class PartyLedgerFamily extends Family<AsyncValue<List<Ledger>>> {
  /// See also [partyLedger].
  const PartyLedgerFamily();

  /// See also [partyLedger].
  PartyLedgerProvider call({
    int? supplierId,
    int? retailerId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PartyLedgerProvider(
      supplierId: supplierId,
      retailerId: retailerId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  PartyLedgerProvider getProviderOverride(
    covariant PartyLedgerProvider provider,
  ) {
    return call(
      supplierId: provider.supplierId,
      retailerId: provider.retailerId,
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
  String? get name => r'partyLedgerProvider';
}

/// See also [partyLedger].
class PartyLedgerProvider extends AutoDisposeStreamProvider<List<Ledger>> {
  /// See also [partyLedger].
  PartyLedgerProvider({
    int? supplierId,
    int? retailerId,
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
         (ref) => partyLedger(
           ref as PartyLedgerRef,
           supplierId: supplierId,
           retailerId: retailerId,
           startDate: startDate,
           endDate: endDate,
         ),
         from: partyLedgerProvider,
         name: r'partyLedgerProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$partyLedgerHash,
         dependencies: PartyLedgerFamily._dependencies,
         allTransitiveDependencies:
             PartyLedgerFamily._allTransitiveDependencies,
         supplierId: supplierId,
         retailerId: retailerId,
         startDate: startDate,
         endDate: endDate,
       );

  PartyLedgerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.supplierId,
    required this.retailerId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final int? supplierId;
  final int? retailerId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    Stream<List<Ledger>> Function(PartyLedgerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PartyLedgerProvider._internal(
        (ref) => create(ref as PartyLedgerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        supplierId: supplierId,
        retailerId: retailerId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Ledger>> createElement() {
    return _PartyLedgerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PartyLedgerProvider &&
        other.supplierId == supplierId &&
        other.retailerId == retailerId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, supplierId.hashCode);
    hash = _SystemHash.combine(hash, retailerId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PartyLedgerRef on AutoDisposeStreamProviderRef<List<Ledger>> {
  /// The parameter `supplierId` of this provider.
  int? get supplierId;

  /// The parameter `retailerId` of this provider.
  int? get retailerId;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _PartyLedgerProviderElement
    extends AutoDisposeStreamProviderElement<List<Ledger>>
    with PartyLedgerRef {
  _PartyLedgerProviderElement(super.provider);

  @override
  int? get supplierId => (origin as PartyLedgerProvider).supplierId;
  @override
  int? get retailerId => (origin as PartyLedgerProvider).retailerId;
  @override
  DateTime? get startDate => (origin as PartyLedgerProvider).startDate;
  @override
  DateTime? get endDate => (origin as PartyLedgerProvider).endDate;
}

String _$ledgerSummaryHash() => r'3170da0004a90ebdd43afd0b74ca58589a670150';

/// See also [ledgerSummary].
@ProviderFor(ledgerSummary)
const ledgerSummaryProvider = LedgerSummaryFamily();

/// See also [ledgerSummary].
class LedgerSummaryFamily
    extends
        Family<
          AsyncValue<
            ({double totalDebit, double totalCredit, double closingBalance})
          >
        > {
  /// See also [ledgerSummary].
  const LedgerSummaryFamily();

  /// See also [ledgerSummary].
  LedgerSummaryProvider call({
    int? supplierId,
    int? retailerId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return LedgerSummaryProvider(
      supplierId: supplierId,
      retailerId: retailerId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  LedgerSummaryProvider getProviderOverride(
    covariant LedgerSummaryProvider provider,
  ) {
    return call(
      supplierId: provider.supplierId,
      retailerId: provider.retailerId,
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
  String? get name => r'ledgerSummaryProvider';
}

/// See also [ledgerSummary].
class LedgerSummaryProvider
    extends
        AutoDisposeFutureProvider<
          ({double totalDebit, double totalCredit, double closingBalance})
        > {
  /// See also [ledgerSummary].
  LedgerSummaryProvider({
    int? supplierId,
    int? retailerId,
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
         (ref) => ledgerSummary(
           ref as LedgerSummaryRef,
           supplierId: supplierId,
           retailerId: retailerId,
           startDate: startDate,
           endDate: endDate,
         ),
         from: ledgerSummaryProvider,
         name: r'ledgerSummaryProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$ledgerSummaryHash,
         dependencies: LedgerSummaryFamily._dependencies,
         allTransitiveDependencies:
             LedgerSummaryFamily._allTransitiveDependencies,
         supplierId: supplierId,
         retailerId: retailerId,
         startDate: startDate,
         endDate: endDate,
       );

  LedgerSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.supplierId,
    required this.retailerId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final int? supplierId;
  final int? retailerId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<({double totalDebit, double totalCredit, double closingBalance})>
    Function(LedgerSummaryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LedgerSummaryProvider._internal(
        (ref) => create(ref as LedgerSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        supplierId: supplierId,
        retailerId: retailerId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    ({double totalDebit, double totalCredit, double closingBalance})
  >
  createElement() {
    return _LedgerSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LedgerSummaryProvider &&
        other.supplierId == supplierId &&
        other.retailerId == retailerId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, supplierId.hashCode);
    hash = _SystemHash.combine(hash, retailerId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LedgerSummaryRef
    on
        AutoDisposeFutureProviderRef<
          ({double totalDebit, double totalCredit, double closingBalance})
        > {
  /// The parameter `supplierId` of this provider.
  int? get supplierId;

  /// The parameter `retailerId` of this provider.
  int? get retailerId;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _LedgerSummaryProviderElement
    extends
        AutoDisposeFutureProviderElement<
          ({double totalDebit, double totalCredit, double closingBalance})
        >
    with LedgerSummaryRef {
  _LedgerSummaryProviderElement(super.provider);

  @override
  int? get supplierId => (origin as LedgerSummaryProvider).supplierId;
  @override
  int? get retailerId => (origin as LedgerSummaryProvider).retailerId;
  @override
  DateTime? get startDate => (origin as LedgerSummaryProvider).startDate;
  @override
  DateTime? get endDate => (origin as LedgerSummaryProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
