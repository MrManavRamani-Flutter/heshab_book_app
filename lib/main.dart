import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'database/database.dart';
import 'screens/main_screen.dart';
import 'screens/products_screen.dart';
import 'screens/order_form_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'providers/settings_provider.dart';

import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';

import 'utils/notification_helper.dart';

bool _hasSeenOnboarding = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init();
  
  final sharedPrefs = await SharedPreferences.getInstance();
  _hasSeenOnboarding = sharedPrefs.getBool('has_seen_onboarding') ?? false;
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: _hasSeenOnboarding ? '/' : '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
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
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeStr = ref.watch(themeModeProvider);
    final themeColorStr = ref.watch(themeColorProvider);
    
    ThemeMode themeMode = ThemeMode.system;
    if (themeModeStr == 'light') themeMode = ThemeMode.light;
    if (themeModeStr == 'dark') themeMode = ThemeMode.dark;
    
    Color primaryColor = AppTheme.khataRed;
    try {
      if (themeColorStr.isNotEmpty) {
        primaryColor = Color(int.parse(themeColorStr));
      }
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();//keyboard ko remove kar ne ke liye
      },
      child: MaterialApp.router(
        title: 'Kapad Shop Khata',
        theme: AppTheme.lightTheme(primaryColor),
        darkTheme: AppTheme.darkTheme(primaryColor),
        themeMode: themeMode,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
