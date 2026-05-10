// lib/features/reports/data/repositories/report_repository.dart

import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';

class ReportRepository {
  final AppDatabase _db;

  ReportRepository(this._db);

  /// Get sales summary grouped by month
  Future<List<TypedResult>> getMonthlySales(int shopId, {int limit = 12}) {
    final monthField = _db.bills.billDate.month;
    final yearField = _db.bills.billDate.year;
    final totalField = _db.bills.totalAmount.sum();

    final query = _db.selectOnly(_db.bills)
      ..addColumns([monthField, yearField, totalField])
      ..where(_db.bills.shopId.equals(shopId))
      ..where(_db.bills.billType.equals('sales'))
      ..where(_db.bills.isDeleted.equals(false))
      ..groupBy([monthField, yearField])
      ..orderBy([OrderingTerm.desc(yearField), OrderingTerm.desc(monthField)])
      ..limit(limit);

    return query.get();
  }

  /// Get tax report (Total Tax Collected vs Paid)
  Future<({double taxCollected, double taxPaid})> getTaxReport(int shopId, {DateTime? startDate, DateTime? endDate}) async {
    final querySales = _db.selectOnly(_db.bills)
      ..addColumns([_db.bills.taxAmount.sum()])
      ..where(_db.bills.shopId.equals(shopId))
      ..where(_db.bills.billType.equals('sales'))
      ..where(_db.bills.isDeleted.equals(false));

    final queryPurchase = _db.selectOnly(_db.bills)
      ..addColumns([_db.bills.taxAmount.sum()])
      ..where(_db.bills.shopId.equals(shopId))
      ..where(_db.bills.billType.equals('purchase'))
      ..where(_db.bills.isDeleted.equals(false));

    if (startDate != null) {
      querySales.where(_db.bills.billDate.isBiggerOrEqualValue(startDate));
      queryPurchase.where(_db.bills.billDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      querySales.where(_db.bills.billDate.isSmallerOrEqualValue(endDate));
      queryPurchase.where(_db.bills.billDate.isSmallerOrEqualValue(endDate));
    }

    final salesTax = await querySales.map((row) => row.read(_db.bills.taxAmount.sum()) ?? 0.0).getSingle();
    final purchaseTax = await queryPurchase.map((row) => row.read(_db.bills.taxAmount.sum()) ?? 0.0).getSingle();

    return (taxCollected: salesTax, taxPaid: purchaseTax);
  }

  /// Get Stock Valuation (Total Purchase Value of current stock)
  Future<double> getStockValuation(int shopId) async {
    final query = _db.selectOnly(_db.products)
      ..addColumns([(_db.products.currentStock * _db.products.purchasePrice).sum()])
      ..where(_db.products.shopId.equals(shopId))
      ..where(_db.products.isDeleted.equals(false));

    final result = await query.map((row) => row.read((_db.products.currentStock * _db.products.purchasePrice).sum()) ?? 0.0).getSingle();
    return result;
  }
}
