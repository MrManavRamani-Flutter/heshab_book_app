// lib/features/inventory/data/repositories/product_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';

class ProductRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  ProductRepository(this._db);

  // ── Queries ──────────────────────────────────────────────────────────────

  /// Watch all products for a shop
  Stream<List<Product>> watchShopProducts(int shopId) {
    return (_db.select(_db.products)
          ..where((p) => p.shopId.equals(shopId))
          ..where((p) => p.isDeleted.equals(false))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .watch();
  }

  /// Search products by name or code
  Stream<List<Product>> searchProducts(int shopId, String query) {
    return (_db.select(_db.products)
          ..where((p) => p.shopId.equals(shopId))
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) =>
              p.name.contains(query) |
              (p.code.isNotNull() & p.code.contains(query)) |
              (p.barcode.isNotNull() & p.barcode.contains(query)))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .watch();
  }

  /// Get single product
  Future<Product?> getProductById(int id) {
    return (_db.select(_db.products)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Create a new product with optional opening stock
  Future<int> createProduct({
    required int shopId,
    required String name,
    String? code,
    String? barcode,
    int? categoryId,
    int? subCategoryId,
    int? unitId,
    double purchasePrice = 0.0,
    double retailPrice = 0.0,
    double wholesalePrice = 0.0,
    double openingStock = 0.0,
    double minimumStockAlert = 5.0,
    String? imagePath,
    String? matchingCode,
  }) async {
    return _db.transaction(() async {
      final now = DateTime.now();
      
      // 1. Insert Product
      final productId = await _db.into(_db.products).insert(
            ProductsCompanion.insert(
              uuid: _uuid.v4(),
              shopId: shopId,
              name: name,
              code: Value(code),
              barcode: Value(barcode),
              categoryId: Value(categoryId),
              subCategoryId: Value(subCategoryId),
              unitId: Value(unitId),
              purchasePrice: Value(purchasePrice),
              retailPrice: Value(retailPrice),
              wholesalePrice: Value(wholesalePrice),
              currentStock: Value(openingStock), // Initial cache
              minimumStockAlert: Value(minimumStockAlert),
              imagePath: Value(imagePath),
              matchingCode: Value(matchingCode),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      // 2. If there is opening stock, create a transaction record (RULE-002)
      if (openingStock != 0) {
        await _db.into(_db.stockTransactions).insert(
              StockTransactionsCompanion.insert(
                uuid: _uuid.v4(),
                shopId: shopId,
                productId: productId,
                transactionType: 'adjustment',
                quantity: openingStock,
                stockBefore: 0.0,
                stockAfter: openingStock,
                notes: Value('Opening Stock'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      }

      return productId;
    });
  }

  /// Update product details
  Future<bool> updateProduct({
    required int id,
    String? name,
    String? code,
    String? barcode,
    int? categoryId,
    int? subCategoryId,
    int? unitId,
    double? purchasePrice,
    double? retailPrice,
    double? wholesalePrice,
    double? minimumStockAlert,
    bool? isActive,
    String? imagePath,
    String? matchingCode,
  }) async {
    final now = DateTime.now();
    final result = await (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
          ProductsCompanion(
            name: name != null ? Value(name) : const Value.absent(),
            code: code != null ? Value(code) : const Value.absent(),
            barcode: barcode != null ? Value(barcode) : const Value.absent(),
            categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
            subCategoryId: subCategoryId != null ? Value(subCategoryId) : const Value.absent(),
            unitId: unitId != null ? Value(unitId) : const Value.absent(),
            purchasePrice: purchasePrice != null ? Value(purchasePrice) : const Value.absent(),
            retailPrice: retailPrice != null ? Value(retailPrice) : const Value.absent(),
            wholesalePrice: wholesalePrice != null ? Value(wholesalePrice) : const Value.absent(),
            minimumStockAlert: minimumStockAlert != null ? Value(minimumStockAlert) : const Value.absent(),
            isActive: isActive != null ? Value(isActive) : const Value.absent(),
            imagePath: imagePath != null ? Value(imagePath) : const Value.absent(),
            matchingCode: matchingCode != null ? Value(matchingCode) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
    return result > 0;
  }

  /// Soft delete product
  Future<void> deleteProduct(int id) async {
    final now = DateTime.now();
    await (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
          ProductsCompanion(
            isDeleted: const Value(true),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  /// Get products with same matching code (excluding self)
  Future<List<Product>> getMatchingProducts(int shopId, String matchingCode, int excludeProductId) {
    if (matchingCode.isEmpty) return Future.value([]);
    return (_db.select(_db.products)
          ..where((p) => p.shopId.equals(shopId))
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) => p.matchingCode.equals(matchingCode))
          ..where((p) => p.id.notEquals(excludeProductId)))
        .get();
  }
}
