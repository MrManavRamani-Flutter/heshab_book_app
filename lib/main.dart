import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'database/database.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/order_form_screen.dart';
import 'screens/history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: '/order/:type',
      builder: (context, state) {
        final typeStr = state.pathParameters['type'];
        final type = typeStr == 'purchase' ? OrderType.purchase : OrderType.sale;
        return OrderFormScreen(type: type);
      },
    ),
    GoRoute(
      path: '/history/:type',
      builder: (context, state) {
        final typeStr = state.pathParameters['type'];
        final type = typeStr == 'purchase' ? OrderType.purchase : OrderType.sale;
        return HistoryScreen(type: type);
      },
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Kapad Shop',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Switches based on system preference
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
