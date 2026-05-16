import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

enum OrderType { purchase, sale }

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameEn => text()(); 
  TextColumn get nameHi => text()();
  TextColumn get nameGu => text()();
  TextColumn get varietyEn => text().nullable()(); 
  TextColumn get varietyHi => text().nullable()();
  TextColumn get varietyGu => text().nullable()();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  IntColumn get stock => integer().withDefault(const Constant(0))();
}

class Parties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameEn => text()();
  TextColumn get nameHi => text()();
  TextColumn get nameGu => text()();
  IntColumn get type => intEnum<OrderType>()(); // purchase = Wholesale, sale = Retailer
  TextColumn get phone => text().nullable()();
}

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<OrderType>()(); // 0: purchase, 1: sale
  IntColumn get partyId => integer().references(Parties, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get totalAmount => real()();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get reminderDays => integer().withDefault(const Constant(1))();
}

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
  RealColumn get total => real()();
}

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
}

@DriftDatabase(tables: [Products, Parties, Orders, OrderItems, Payments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedInitialData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Development upgrade: blow away and rebuild for demo
          await m.deleteTable('payments');
          await m.deleteTable('order_items');
          await m.deleteTable('orders');
          await m.deleteTable('parties');
          await m.deleteTable('products');
          await m.createAll();
          await _seedInitialData();
        },
      );

  Future<void> _seedInitialData() async {
    // 1. Seed Products
    final productsList = [
      ProductsCompanion.insert(nameEn: 'Ashtar', nameHi: 'अस्तर', nameGu: 'અસ્તર', price: const Value(150.0), stock: const Value(100)),
      ProductsCompanion.insert(nameEn: 'Blouse', nameHi: 'ब्लाउज', nameGu: 'બ્લાઉઝ', price: const Value(250.0), stock: const Value(50)),
      ProductsCompanion.insert(nameEn: 'Chaniya', nameHi: 'चनिया', nameGu: 'ચણિયા', varietyEn: const Value('Cotton'), varietyHi: const Value('सूती'), varietyGu: const Value('સુતરાઉ'), price: const Value(500.0), stock: const Value(20)),
      ProductsCompanion.insert(nameEn: 'Chaniya', nameHi: 'चनिया', nameGu: 'ચણિયા', varietyEn: const Value('Lijibiji'), varietyHi: const Value('लिजीबिजी'), varietyGu: const Value('લીજીબીજી'), price: const Value(600.0), stock: const Value(15)),
      ProductsCompanion.insert(nameEn: 'Fancy Blouse', nameHi: 'फैंसी ब्लाउज', nameGu: 'ફેન્સી બ્લાઉઝ', price: const Value(450.0), stock: const Value(30)),
    ];
    
    for (final product in productsList) {
      await into(products).insert(product);
    }

    // 2. Seed Parties (Wholesale & Retail)
    int wholesale1 = await into(parties).insert(PartiesCompanion.insert(nameEn: 'Surat Textiles', nameHi: 'सूरत टेक्सटाइल्स', nameGu: 'સુરત ટેક્સટાઇલ્સ', type: OrderType.purchase, phone: const Value('9876543210')));
    int wholesale2 = await into(parties).insert(PartiesCompanion.insert(nameEn: 'Ahmedabad Fabrics', nameHi: 'अहमदाबाद फैब्रिक्स', nameGu: 'અમદાવાદ ફેબ્રિક્સ', type: OrderType.purchase, phone: const Value('9988776655')));
    
    int retail1 = await into(parties).insert(PartiesCompanion.insert(nameEn: 'Ramesh Bhai', nameHi: 'रमेश भाई', nameGu: 'રમેશ ભાઈ', type: OrderType.sale, phone: const Value('9123456789')));
    await into(parties).insert(PartiesCompanion.insert(nameEn: 'Suresh Garments', nameHi: 'सुरेश गारमेंट्स', nameGu: 'સુરેશ ગારમેન્ટ્સ', type: OrderType.sale, phone: const Value('9345678123')));

    // 3. Seed Demo Orders (Purchases)
    int pOrder1 = await into(orders).insert(OrdersCompanion.insert(
      type: OrderType.purchase,
      partyId: wholesale1,
      date: DateTime.now().subtract(const Duration(days: 2)),
      totalAmount: 1500.0,
    ));
    await into(orderItems).insert(OrderItemsCompanion.insert(orderId: pOrder1, productId: 1, quantity: 10, price: 150.0, total: 1500.0));

    int pOrder2 = await into(orders).insert(OrdersCompanion.insert(
      type: OrderType.purchase,
      partyId: wholesale2,
      date: DateTime.now().subtract(const Duration(days: 1)),
      totalAmount: 2500.0,
    ));
    await into(orderItems).insert(OrderItemsCompanion.insert(orderId: pOrder2, productId: 2, quantity: 10, price: 250.0, total: 2500.0));

    // Seed Demo Orders (Sales)
    int sOrder1 = await into(orders).insert(OrdersCompanion.insert(
      type: OrderType.sale,
      partyId: retail1,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      totalAmount: 500.0,
    ));
    await into(orderItems).insert(OrderItemsCompanion.insert(orderId: sOrder1, productId: 3, quantity: 1, price: 500.0, total: 500.0));
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'kapad_shop_db');
}

extension LocalizedProduct on Product {
  String localizedName(String lang) {
    if (lang == 'hi') return nameHi;
    if (lang == 'gu') return nameGu;
    return nameEn;
  }
  
  String? localizedVariety(String lang) {
    if (lang == 'hi') return varietyHi;
    if (lang == 'gu') return varietyGu;
    return varietyEn;
  }
  
  String get displayNameEn => '$nameEn${varietyEn != null ? ' ($varietyEn)' : ''}';
  String get displayNameHi => '$nameHi${varietyHi != null ? ' ($varietyHi)' : ''}';
  String get displayNameGu => '$nameGu${varietyGu != null ? ' ($varietyGu)' : ''}';
  
  String localizedDisplayName(String lang) {
    if (lang == 'hi') return displayNameHi;
    if (lang == 'gu') return displayNameGu;
    return displayNameEn;
  }
}

extension LocalizedParty on Party {
  String localizedName(String lang) {
    if (lang == 'hi') return nameHi;
    if (lang == 'gu') return nameGu;
    return nameEn;
  }
}
