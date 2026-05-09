// lib/features/inventory/data/repositories/stock_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class StockRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  StockRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch transaction history for a specific product
  Stream<List<StockTransaction>> watchProductHistory(int productId) {
    return (_db.select(_db.stockTransactions)
          ..where((t) => t.productId.equals(productId))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watch all stock movements for a shop (audit log)
  Stream<List<StockTransaction>> watchShopHistory(int shopId) {
    return (_db.select(_db.stockTransactions)
          ..where((t) => t.shopId.equals(shopId))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Core stock movement logic (Internal)
  Future<void> _moveStock({
    required int shopId,
    required int productId,
    required double change, // positive for IN, negative for OUT
    required String type, // 'purchase', 'sale', 'return', 'damage', 'adjustment'
    String? notes,
    int? billId,
  }) async {
    await _db.transaction(() async {
      final now = DateTime.now();

      // 1. Get current stock for audit
      final product = await (_db.select(_db.products)..where((p) => p.id.equals(productId))).getSingle();
      final stockBefore = product.currentStock;
      final stockAfter = stockBefore + change;

      // 2. Create Transaction Record (RULE-002)
      await _db.into(_db.stockTransactions).insert(
            StockTransactionsCompanion.insert(
              uuid: _uuid.v4(),
              shopId: shopId,
              productId: productId,
              transactionType: type,
              quantity: change,
              stockBefore: stockBefore,
              stockAfter: stockAfter,
              notes: Value(notes),
              billId: Value(billId),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      // 3. Update Product Cache
      await (_db.update(_db.products)..where((p) => p.id.equals(productId))).write(
            ProductsCompanion(
              currentStock: Value(stockAfter),
              updatedAt: Value(now),
            ),
          );
    });
  }

  /// Manually add stock (Stock IN)
  Future<void> stockIn({
    required int shopId,
    required int productId,
    required double quantity,
    String? notes,
  }) {
    return _moveStock(
      shopId: shopId,
      productId: productId,
      change: quantity.abs(),
      type: 'adjustment',
      notes: notes ?? 'Manual Stock IN',
    );
  }

  /// Manually remove stock (Stock OUT)
  Future<void> stockOut({
    required int shopId,
    required int productId,
    required double quantity,
    String? notes,
  }) {
    return _moveStock(
      shopId: shopId,
      productId: productId,
      change: -quantity.abs(),
      type: 'adjustment',
      notes: notes ?? 'Manual Stock OUT',
    );
  }

  /// Mark stock as damaged
  Future<void> reportDamage({
    required int shopId,
    required int productId,
    required double quantity,
    String? notes,
  }) {
    return _moveStock(
      shopId: shopId,
      productId: productId,
      change: -quantity.abs(),
      type: 'damage',
      notes: notes ?? 'Reported Damage',
    );
  }

  /// Record a return (increases stock)
  Future<void> recordReturn({
    required int shopId,
    required int productId,
    required double quantity,
    String? notes,
  }) {
    return _moveStock(
      shopId: shopId,
      productId: productId,
      change: quantity.abs(),
      type: 'return',
      notes: notes ?? 'Customer Return',
    );
  }
}
