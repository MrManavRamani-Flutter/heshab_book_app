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

final partiesProvider = StreamProvider.family<List<Party>, OrderType>((ref, type) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.parties)..where((p) => p.type.equals(type.index))).watch();
});

final purchaseOrdersProvider = StreamProvider<List<Order>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orders)..where((o) => o.type.equals(OrderType.purchase.index))).watch();
});

final saleOrdersProvider = StreamProvider<List<Order>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orders)..where((o) => o.type.equals(OrderType.sale.index))).watch();
});

final allOrdersProvider = StreamProvider<List<Order>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.orders).watch();
});

final ordersByPartyProvider = StreamProvider.family<List<Order>, int>((ref, partyId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orders)..where((o) => o.partyId.equals(partyId))).watch();
});

final orderItemsProvider = StreamProvider.family<List<OrderItem>, int>((ref, orderId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.orderItems)..where((i) => i.orderId.equals(orderId))).watch();
});

final paymentsByOrderProvider = StreamProvider.family<List<Payment>, int>((ref, orderId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.payments)..where((p) => p.orderId.equals(orderId))).watch();
});

final partyByIdProvider = FutureProvider.family<Party, int>((ref, partyId) async {
  final db = ref.watch(databaseProvider);
  return await (db.select(db.parties)..where((p) => p.id.equals(partyId))).getSingle();
});
