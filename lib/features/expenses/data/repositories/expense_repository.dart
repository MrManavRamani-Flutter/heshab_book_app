// lib/features/expenses/data/repositories/expense_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class ExpenseRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  ExpenseRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch expenses for a shop, with optional date filtering
  Stream<List<Expense>> watchShopExpenses(
    int shopId, {
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  }) {
    final query = _db.select(_db.expenses)
      ..where((e) => e.shopId.equals(shopId))
      ..where((e) => e.isDeleted.equals(false));

    if (startDate != null) {
      query.where((e) => e.expenseDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((e) => e.expenseDate.isSmallerOrEqualValue(endDate));
    }
    if (category != null) {
      query.where((e) => e.category.equals(category));
    }

    return (query..orderBy([(e) => OrderingTerm.desc(e.expenseDate)])).watch();
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Create a new expense
  Future<int> createExpense({
    required int shopId,
    required String category,
    String? description,
    required double amount,
    required DateTime expenseDate,
    String paymentMode = 'cash',
    String? receiptPath,
  }) async {
    final now = DateTime.now();
    return _db.into(_db.expenses).insert(
          ExpensesCompanion.insert(
            uuid: _uuid.v4(),
            shopId: shopId,
            category: category,
            description: Value(description),
            amount: amount,
            expenseDate: expenseDate,
            paymentMode: Value(paymentMode),
            receiptPath: Value(receiptPath),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  /// Update expense details
  Future<bool> updateExpense({
    required int id,
    String? category,
    String? description,
    double? amount,
    DateTime? expenseDate,
    String? paymentMode,
    String? receiptPath,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
          ExpensesCompanion(
            category: category != null ? Value(category) : const Value.absent(),
            description: description != null ? Value(description) : const Value.absent(),
            amount: amount != null ? Value(amount) : const Value.absent(),
            expenseDate: expenseDate != null ? Value(expenseDate) : const Value.absent(),
            paymentMode: paymentMode != null ? Value(paymentMode) : const Value.absent(),
            receiptPath: receiptPath != null ? Value(receiptPath) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  /// Soft delete expense
  Future<void> deleteExpense(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
          ExpensesCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
