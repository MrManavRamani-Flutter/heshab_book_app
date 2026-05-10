// lib/config/routes/route_names.dart

class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String shopSetup = '/shop-setup';

  // Main
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String productsAdd = '/products/add';
  static const String productDetail = '/products/:id';
  static const String stock = '/stock';
  static const String suppliers = '/suppliers';
  static const String suppliersAdd = '/suppliers/add';
  static const String supplierDetail = '/suppliers/:id';
  static const String retailers = '/retailers';
  static const String retailersAdd = '/retailers/add';
  static const String retailerDetail = '/retailers/:id';
  static const String bills = '/bills';
  static const String billsCreate = '/bills/create';
  static const String billDetail = '/bills/:id';
  static const String payments = '/payments';
  static const String ledger = '/ledger';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String cloudSync = '/settings/sync';
  static const String profile = '/settings/profile';
}
