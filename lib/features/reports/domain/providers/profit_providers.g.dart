// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profitLossReportHash() => r'a0d02c028bae80af44d01396c4be92b2631c60a3';

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

abstract class _$ProfitLossReport
    extends
        BuildlessAutoDisposeAsyncNotifier<
          ({
            double totalSales,
            double totalPurchase,
            double grossProfit,
            double totalExpenses,
            double netProfit,
            double marginPercent,
          })
        > {
  late final DateTime? startDate;
  late final DateTime? endDate;

  FutureOr<
    ({
      double totalSales,
      double totalPurchase,
      double grossProfit,
      double totalExpenses,
      double netProfit,
      double marginPercent,
    })
  >
  build({DateTime? startDate, DateTime? endDate});
}

/// See also [ProfitLossReport].
@ProviderFor(ProfitLossReport)
const profitLossReportProvider = ProfitLossReportFamily();

/// See also [ProfitLossReport].
class ProfitLossReportFamily
    extends
        Family<
          AsyncValue<
            ({
              double totalSales,
              double totalPurchase,
              double grossProfit,
              double totalExpenses,
              double netProfit,
              double marginPercent,
            })
          >
        > {
  /// See also [ProfitLossReport].
  const ProfitLossReportFamily();

  /// See also [ProfitLossReport].
  ProfitLossReportProvider call({DateTime? startDate, DateTime? endDate}) {
    return ProfitLossReportProvider(startDate: startDate, endDate: endDate);
  }

  @override
  ProfitLossReportProvider getProviderOverride(
    covariant ProfitLossReportProvider provider,
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
  String? get name => r'profitLossReportProvider';
}

/// See also [ProfitLossReport].
class ProfitLossReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProfitLossReport,
          ({
            double totalSales,
            double totalPurchase,
            double grossProfit,
            double totalExpenses,
            double netProfit,
            double marginPercent,
          })
        > {
  /// See also [ProfitLossReport].
  ProfitLossReportProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        () => ProfitLossReport()
          ..startDate = startDate
          ..endDate = endDate,
        from: profitLossReportProvider,
        name: r'profitLossReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$profitLossReportHash,
        dependencies: ProfitLossReportFamily._dependencies,
        allTransitiveDependencies:
            ProfitLossReportFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  ProfitLossReportProvider._internal(
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
  FutureOr<
    ({
      double totalSales,
      double totalPurchase,
      double grossProfit,
      double totalExpenses,
      double netProfit,
      double marginPercent,
    })
  >
  runNotifierBuild(covariant ProfitLossReport notifier) {
    return notifier.build(startDate: startDate, endDate: endDate);
  }

  @override
  Override overrideWith(ProfitLossReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfitLossReportProvider._internal(
        () => create()
          ..startDate = startDate
          ..endDate = endDate,
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
  AutoDisposeAsyncNotifierProviderElement<
    ProfitLossReport,
    ({
      double totalSales,
      double totalPurchase,
      double grossProfit,
      double totalExpenses,
      double netProfit,
      double marginPercent,
    })
  >
  createElement() {
    return _ProfitLossReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfitLossReportProvider &&
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
mixin ProfitLossReportRef
    on
        AutoDisposeAsyncNotifierProviderRef<
          ({
            double totalSales,
            double totalPurchase,
            double grossProfit,
            double totalExpenses,
            double netProfit,
            double marginPercent,
          })
        > {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _ProfitLossReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProfitLossReport,
          ({
            double totalSales,
            double totalPurchase,
            double grossProfit,
            double totalExpenses,
            double netProfit,
            double marginPercent,
          })
        >
    with ProfitLossReportRef {
  _ProfitLossReportProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as ProfitLossReportProvider).startDate;
  @override
  DateTime? get endDate => (origin as ProfitLossReportProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
