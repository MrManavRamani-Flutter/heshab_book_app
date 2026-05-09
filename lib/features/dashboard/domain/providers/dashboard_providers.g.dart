// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardStatsHash() => r'0b8740019642a276665dd163087c66d16c260b32';

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
      })
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
