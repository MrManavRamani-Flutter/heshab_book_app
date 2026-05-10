// test/features/inventory/stock_repository_test.dart

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heshab_book_app/database/app_database.dart';
import 'package:heshab_book_app/features/inventory/data/repositories/stock_repository.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;
  late StockRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = StockRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('StockRepository - Adjustments', () {
    test('Manual stock adjustment should update product cache correctly', () async {
      // 0. Setup: Create user and shop
      final userId = await db.into(db.users).insert(
        UsersCompanion.insert(
          uuid: 'user-stock',
          name: 'Owner',
          mobile: const Value('1234567890'),
          passwordHash: 'hash',
        ),
      );

      final shopId = await db.into(db.shops).insert(
        ShopsCompanion.insert(
          uuid: 'shop-stock',
          shopName: 'Stock Shop',
          shopType: 'retail',
          userId: userId,
        ),
      );

      final productId = await db.into(db.products).insert(
        ProductsCompanion.insert(
          uuid: 'prod-stock',
          shopId: shopId,
          name: 'Bread',
          currentStock: const Value(50),
        ),
      );

      // 1. Action: Adjust stock by adding 20 units
      await repository.stockIn(
        shopId: shopId,
        productId: productId,
        quantity: 20,
        notes: 'Restock',
      );

      // 2. Verify: Product cache updated to 70
      final product = await (db.select(db.products)..where((p) => p.id.equals(productId))).getSingle();
      expect(product.currentStock, 70);

      // 3. Verify: Transaction recorded
      final transaction = await db.select(db.stockTransactions).getSingle();
      expect(transaction.quantity, 20);
      expect(transaction.transactionType, 'adjustment');
    });
  });
}
