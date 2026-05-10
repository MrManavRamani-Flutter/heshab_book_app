// test/features/billing/bill_repository_test.dart

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heshab_book_app/database/app_database.dart';
import 'package:heshab_book_app/features/billing/data/repositories/bill_repository.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;
  late BillRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = BillRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('BillRepository - Creation Logic', () {
    test('Creating a Sales Bill should decrease stock (RULE-002)', () async {
      // 0. Setup: Create a user
      final userId = await db.into(db.users).insert(
        UsersCompanion.insert(
          uuid: 'user-1',
          name: 'Test User',
          mobile: const Value('1234567890'),
          passwordHash: 'hash',
        ),
      );

      // 1. Setup: Create a shop and a product
      final shopId = await db.into(db.shops).insert(
        ShopsCompanion.insert(
          uuid: 'shop-1',
          shopName: 'Test Shop',
          shopType: 'retail',
          userId: userId,
        ),
      );

      final productUuid = 'prod-1';
      await db.into(db.products).insert(
        ProductsCompanion.insert(
          uuid: productUuid,
          shopId: shopId,
          name: 'Milk',
          currentStock: const Value(100),
          minimumStockAlert: const Value(10),
          purchasePrice: const Value(40),
          retailPrice: const Value(50),
        ),
      );

      // 2. Action: Create a sales bill for 5 units
      await repository.createBill(
        shopId: shopId,
        billType: 'sales',
        billDate: DateTime.now(),
        items: [
          BillItemsCompanion.insert(
            uuid: 'item-1',
            billId: 0, // Will be set by repository
            productUuid: productUuid,
            productName: 'Milk',
            quantity: 5,
            salePrice: 50,
            totalAmount: 250,
          ),
        ],
        paidAmount: 250,
      );

      // 3. Verify: Stock should be 95
      final product = await (db.select(db.products)..where((p) => p.uuid.equals(productUuid))).getSingle();
      expect(product.currentStock, 95);

      // 4. Verify: Stock Transaction record exists
      final transactions = await db.select(db.stockTransactions).get();
      expect(transactions.length, 1);
      expect(transactions.first.quantity, -5);
      expect(transactions.first.stockAfter, 95);
    });

    test('Creating a Purchase Bill should increase stock and update Supplier Balance (RULE-007, RULE-008)', () async {
      // 0. Setup: Create a user and a shop
      final userId = await db.into(db.users).insert(
        UsersCompanion.insert(
          uuid: 'user-2',
          name: 'Owner 2',
          mobile: const Value('0987654321'),
          passwordHash: 'hash',
        ),
      );
      final shopId = await db.into(db.shops).insert(
        ShopsCompanion.insert(
          uuid: 'shop-2',
          shopName: 'Wholesale Shop',
          shopType: 'big_hall',
          userId: userId,
        ),
      );

      // 1. Setup: Create a supplier and a product
      final supplierId = await db.into(db.suppliers).insert(
        SuppliersCompanion.insert(
          uuid: 'supp-1',
          shopId: shopId,
          name: 'Global Supply',
          currentBalance: const Value(0.0),
        ),
      );
      final productUuid = 'prod-2';
      await db.into(db.products).insert(
        ProductsCompanion.insert(
          uuid: productUuid,
          shopId: shopId,
          name: 'Rice',
          currentStock: const Value(50),
          purchasePrice: const Value(30),
          retailPrice: const Value(40),
        ),
      );

      // 2. Action: Create a purchase bill for 10 units at 30/unit = 300
      await repository.createBill(
        shopId: shopId,
        billType: 'purchase',
        billDate: DateTime.now(),
        supplierId: supplierId,
        items: [
          BillItemsCompanion.insert(
            uuid: 'item-2',
            billId: 0,
            productUuid: productUuid,
            productName: 'Rice',
            quantity: 10,
            salePrice: 40,
            purchasePrice: const Value(30),
            totalAmount: 300,
          ),
        ],
        paidAmount: 0, // Fully credit
      );

      // 3. Verify: Stock should be 60 (50 + 10)
      final product = await (db.select(db.products)..where((p) => p.uuid.equals(productUuid))).getSingle();
      expect(product.currentStock, 60);

      // 4. Verify: Supplier balance should be 300
      final supplier = await (db.select(db.suppliers)..where((s) => s.id.equals(supplierId))).getSingle();
      expect(supplier.currentBalance, 300);

      // 5. Verify: Ledger entry exists
      final ledgerEntries = await db.select(db.ledgers).get();
      expect(ledgerEntries.length, 1);
      expect(ledgerEntries.first.amount, 300);
      expect(ledgerEntries.first.balanceAfter, 300);
      expect(ledgerEntries.first.entryType, 'debit'); // As per my simplified implementation in BillRepository
    });
  });
}
