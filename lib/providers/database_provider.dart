import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final productsProvider = StreamProvider<List<Product>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.products).watch();
});

final purchaseOrdersProvider = StreamProvider<List<Order>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orders)..where((o) => o.type.equals(OrderType.purchase.index))).watch();
});

final saleOrdersProvider = StreamProvider<List<Order>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orders)..where((o) => o.type.equals(OrderType.sale.index))).watch();
});

// A provider to fetch order items given an orderId
final orderItemsProvider = StreamProvider.family<List<OrderItem>, int>((ref, orderId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orderItems)..where((i) => i.orderId.equals(orderId))).watch();
});
