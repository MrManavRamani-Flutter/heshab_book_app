// lib/features/reports/domain/providers/report_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../data/repositories/report_repository.dart';

part 'report_providers.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) {
  return sl<ReportRepository>();
}

// ── Analytics Providers ───────────────────────────────────────────────────

@riverpod
Future<double> stockValuation(StockValuationRef ref) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return Future.value(0.0);
  
  return ref.watch(reportRepositoryProvider).getStockValuation(activeShop.id);
}

@riverpod
Future<({double taxCollected, double taxPaid})> taxReport(
  TaxReportRef ref, {
  DateTime? startDate,
  DateTime? endDate,
}) {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) {
    return Future.value((taxCollected: 0.0, taxPaid: 0.0));
  }
  
  return ref.watch(reportRepositoryProvider).getTaxReport(
    activeShop.id,
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<List<({int month, int year, double totalSales})>> monthlySalesHistory(MonthlySalesHistoryRef ref) async {
  final activeShop = ref.watch(activeShopProvider);
  if (activeShop == null) return [];
  
  final results = await ref.watch(reportRepositoryProvider).getMonthlySales(activeShop.id);
  final db = sl<AppDatabase>();
  
  return results.map((row) {
    final month = row.read(db.bills.billDate.month)!;
    final year = row.read(db.bills.billDate.year)!;
    final total = row.read(db.bills.totalAmount.sum()) ?? 0.0;
    
    return (month: month, year: year, totalSales: total);
  }).toList();
}
