// lib/features/reports/domain/providers/profit_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../billing/domain/providers/bill_providers.dart';
import '../../../expenses/domain/providers/expense_providers.dart';

part 'profit_providers.g.dart';

@riverpod
class ProfitLossReport extends _$ProfitLossReport {
  @override
  Future<({
    double totalSales,
    double totalPurchase,
    double grossProfit,
    double totalExpenses,
    double netProfit,
    double marginPercent,
  })> build({DateTime? startDate, DateTime? endDate}) async {
    // 1. Get Sales
    final sales = ref.watch(shopBillsProvider(type: 'sales', startDate: startDate, endDate: endDate));
    // 2. Get Purchase
    final purchases = ref.watch(shopBillsProvider(type: 'purchase', startDate: startDate, endDate: endDate));
    // 3. Get Expenses
    final expenses = ref.watch(shopExpensesProvider(startDate: startDate, endDate: endDate));

    return sales.when(
      data: (salesList) {
        return purchases.when(
          data: (purchaseList) {
            return expenses.when(
              data: (expenseList) {
                final totalSales = salesList.fold(0.0, (sum, b) => sum + b.totalAmount);
                final totalPurchase = purchaseList.fold(0.0, (sum, b) => sum + b.totalAmount);
                final totalExp = expenseList.fold(0.0, (sum, e) => sum + e.amount);

                final grossProfit = totalSales - totalPurchase;
                final netProfit = grossProfit - totalExp;
                final margin = totalSales > 0 ? (netProfit / totalSales) * 100 : 0.0;

                return (
                  totalSales: totalSales,
                  totalPurchase: totalPurchase,
                  grossProfit: grossProfit,
                  totalExpenses: totalExp,
                  netProfit: netProfit,
                  marginPercent: margin,
                );
              },
              loading: () => _loadingState(),
              error: (e, s) => _errorState(),
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
    double totalSales,
    double totalPurchase,
    double grossProfit,
    double totalExpenses,
    double netProfit,
    double marginPercent,
  }) _loadingState() => (
    totalSales: 0.0,
    totalPurchase: 0.0,
    grossProfit: 0.0,
    totalExpenses: 0.0,
    netProfit: 0.0,
    marginPercent: 0.0,
  );

  ({
    double totalSales,
    double totalPurchase,
    double grossProfit,
    double totalExpenses,
    double netProfit,
    double marginPercent,
  }) _errorState() => _loadingState();
}
