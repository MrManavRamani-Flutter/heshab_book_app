// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportRepositoryHash() => r'21685a5ea5ca123d7ddfe94364342c242e59e7ca';

/// See also [reportRepository].
@ProviderFor(reportRepository)
final reportRepositoryProvider = AutoDisposeProvider<ReportRepository>.internal(
  reportRepository,
  name: r'reportRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportRepositoryRef = AutoDisposeProviderRef<ReportRepository>;
String _$stockValuationHash() => r'01d1c1c0abb46fa6f8b7efddf438519fe9871f24';

/// See also [stockValuation].
@ProviderFor(stockValuation)
final stockValuationProvider = AutoDisposeFutureProvider<double>.internal(
  stockValuation,
  name: r'stockValuationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockValuationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StockValuationRef = AutoDisposeFutureProviderRef<double>;
String _$taxReportHash() => r'c060ddb49942c32f39d477b3abbfdb258b3d4dfb';

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

/// See also [taxReport].
@ProviderFor(taxReport)
const taxReportProvider = TaxReportFamily();

/// See also [taxReport].
class TaxReportFamily
    extends Family<AsyncValue<({double taxCollected, double taxPaid})>> {
  /// See also [taxReport].
  const TaxReportFamily();

  /// See also [taxReport].
  TaxReportProvider call({DateTime? startDate, DateTime? endDate}) {
    return TaxReportProvider(startDate: startDate, endDate: endDate);
  }

  @override
  TaxReportProvider getProviderOverride(covariant TaxReportProvider provider) {
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
  String? get name => r'taxReportProvider';
}

/// See also [taxReport].
class TaxReportProvider
    extends AutoDisposeFutureProvider<({double taxCollected, double taxPaid})> {
  /// See also [taxReport].
  TaxReportProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        (ref) => taxReport(
          ref as TaxReportRef,
          startDate: startDate,
          endDate: endDate,
        ),
        from: taxReportProvider,
        name: r'taxReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$taxReportHash,
        dependencies: TaxReportFamily._dependencies,
        allTransitiveDependencies: TaxReportFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  TaxReportProvider._internal(
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
    FutureOr<({double taxCollected, double taxPaid})> Function(
      TaxReportRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaxReportProvider._internal(
        (ref) => create(ref as TaxReportRef),
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
  AutoDisposeFutureProviderElement<({double taxCollected, double taxPaid})>
  createElement() {
    return _TaxReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaxReportProvider &&
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
mixin TaxReportRef
    on AutoDisposeFutureProviderRef<({double taxCollected, double taxPaid})> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _TaxReportProviderElement
    extends
        AutoDisposeFutureProviderElement<
          ({double taxCollected, double taxPaid})
        >
    with TaxReportRef {
  _TaxReportProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as TaxReportProvider).startDate;
  @override
  DateTime? get endDate => (origin as TaxReportProvider).endDate;
}

String _$monthlySalesHistoryHash() =>
    r'18c06ba069072894a2ed760d2125f065ea8fd9af';

/// See also [monthlySalesHistory].
@ProviderFor(monthlySalesHistory)
final monthlySalesHistoryProvider =
    AutoDisposeFutureProvider<
      List<({int month, int year, double totalSales})>
    >.internal(
      monthlySalesHistory,
      name: r'monthlySalesHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$monthlySalesHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlySalesHistoryRef =
    AutoDisposeFutureProviderRef<
      List<({int month, int year, double totalSales})>
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
