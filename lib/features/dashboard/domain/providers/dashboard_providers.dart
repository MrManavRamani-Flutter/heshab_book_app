// lib/features/dashboard/domain/providers/dashboard_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../billing/domain/providers/bill_providers.dart';
import '../../../inventory/domain/providers/product_providers.dart';
import '../../../parties/domain/providers/party_providers.dart';

part 'dashboard_providers.g.dart';

@riverpod
class DashboardStats extends _$DashboardStats {
  @override
  Future<({
    double todaySalesAmount,
    int todaySalesCount,
    int lowStockCount,
    double pendingReceivables,
    double pendingPayables,
    int totalProducts,
  })> build() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    // 1. Today's Sales
    final salesAsync = ref.watch(salesBillsProvider(startDate: todayStart, endDate: todayEnd));
    
    // 2. Low Stock Products
    final lowStockAsync = ref.watch(lowStockProductsProvider);
    
    // 3. Receivables & Payables
    final receivables = ref.watch(totalRetailerReceivableProvider);
    final payables = ref.watch(totalSupplierOwedProvider);
    
    // 4. Total Products
    final productsAsync = ref.watch(shopProductsProvider);

    return salesAsync.when(
      data: (sales) {
        return productsAsync.when(
          data: (products) {
            return (
              todaySalesAmount: sales.fold(0.0, (sum, b) => sum + b.totalAmount),
              todaySalesCount: sales.length,
              lowStockCount: lowStockAsync.length,
              pendingReceivables: receivables,
              pendingPayables: payables,
              totalProducts: products.length,
            );
          },
          loading: () => _loadingState(),
          error: (e, s) => _errorState(),
        );
      },
      loading: () => _loadingState(),
      error: (e, s) => _errorState(),
    );
  }

  ({
    double todaySalesAmount,
    int todaySalesCount,
    int lowStockCount,
    double pendingReceivables,
    double pendingPayables,
    int totalProducts,
  }) _loadingState() => (
    todaySalesAmount: 0.0,
    todaySalesCount: 0,
    lowStockCount: 0,
    pendingReceivables: 0.0,
    pendingPayables: 0.0,
    totalProducts: 0,
  );

  ({
    double todaySalesAmount,
    int todaySalesCount,
    int lowStockCount,
    double pendingReceivables,
    double pendingPayables,
    int totalProducts,
  }) _errorState() => _loadingState();
}
