// lib/features/expenses/domain/providers/expense_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/expense_repository.dart';

part 'expense_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
ExpenseRepository expenseRepository(ExpenseRepositoryRef ref) {
  return sl<ExpenseRepository>();
}

// ── Expense List Provider ──────────────────────────────────────────────────

@riverpod
Stream<List<Expense>> shopExpenses(
  ShopExpensesRef ref, {
  DateTime? startDate,
  DateTime? endDate,
  String? category,
}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Stream.value([]);
  
  return ref.watch(expenseRepositoryProvider).watchShopExpenses(
    activeShop.id,
    startDate: startDate,
    endDate: endDate,
    category: category,
  );
}

// ── Financial Summary Selectors ───────────────────────────────────────────

@riverpod
double totalExpenses(TotalExpensesRef ref, {DateTime? startDate, DateTime? endDate}) {
  final expensesAsync = ref.watch(shopExpensesProvider(startDate: startDate, endDate: endDate));
  return expensesAsync.maybeWhen(
    data: (expenses) => expenses.fold(0.0, (sum, e) => sum + e.amount),
    orElse: () => 0.0,
  );
}

@riverpod
Map<String, double> expensesByCategory(ExpensesByCategoryRef ref, {DateTime? startDate, DateTime? endDate}) {
  final expensesAsync = ref.watch(shopExpensesProvider(startDate: startDate, endDate: endDate));
  return expensesAsync.maybeWhen(
    data: (expenses) {
      final map = <String, double>{};
      for (final e in expenses) {
        map[e.category] = (map[e.category] ?? 0.0) + e.amount;
      }
      return map;
    },
    orElse: () => {},
  );
}
