import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

enum OrderType { purchase, sale }

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // e.g., Ashtar, Blouse, Chaniya
  TextColumn get variety => text().nullable()(); // e.g., Cotton, Lijibiji, etc.
  RealColumn get price => real().withDefault(const Constant(0.0))();
  IntColumn get stock => integer().withDefault(const Constant(0))();
}

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<OrderType>()(); // 0: purchase, 1: sale
  TextColumn get partyName => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get totalAmount => real()();
}

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
  RealColumn get total => real()();
}

@DriftDatabase(tables: [Products, Orders, OrderItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedInitialProducts();
        },
      );

  Future<void> _seedInitialProducts() async {
    final products = [
      ProductsCompanion.insert(name: 'Ashtar'),
      ProductsCompanion.insert(name: 'Blouse'),
      ProductsCompanion.insert(name: 'Chaniya', variety: const Value('Cotton')),
      ProductsCompanion.insert(name: 'Chaniya', variety: const Value('Lijibiji')),
      ProductsCompanion.insert(name: 'Chaniya', variety: const Value('Jalar vala')),
      ProductsCompanion.insert(name: 'Chaniya', variety: const Value('Full size')),
      ProductsCompanion.insert(name: 'Chaniya', variety: const Value('Medium size')),
      ProductsCompanion.insert(name: 'Chaniya', variety: const Value('Bhare Chaniya')),
      ProductsCompanion.insert(name: 'Fancy Blouse'),
    ];
    for (final product in products) {
      await into(this.products).insert(product);
    }
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'kapad_shop_db');
}
