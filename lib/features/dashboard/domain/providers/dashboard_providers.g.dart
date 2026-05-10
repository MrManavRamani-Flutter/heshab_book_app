// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardStatsHash() => r'30c275b820732316841e33fc7d9ac27a8a854370';

/// See also [DashboardStats].
@ProviderFor(DashboardStats)
final dashboardStatsProvider =
    AutoDisposeAsyncNotifierProvider<
      DashboardStats,
      ({
        double todaySalesAmount,
        int todaySalesCount,
        int lowStockCount,
        double pendingReceivables,
        double pendingPayables,
        int totalProducts,
        double stockValuation,
      })
    >.internal(
      DashboardStats.new,
      name: r'dashboardStatsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DashboardStats =
    AutoDisposeAsyncNotifier<
      ({
        double todaySalesAmount,
        int todaySalesCount,
        int lowStockCount,
        double pendingReceivables,
        double pendingPayables,
        int totalProducts,
        double stockValuation,
      })
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
