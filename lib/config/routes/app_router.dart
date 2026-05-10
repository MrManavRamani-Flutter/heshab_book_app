// lib/config/routes/app_router.dart
//
// GoRouter with auth guard — RULE-010: Unauthenticated users cannot access protected routes.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route_names.dart';
import '../../features/auth/data/models/auth_state.dart';
import '../../features/auth/domain/providers/auth_provider.dart';

// ── Screens ────────────────────────────────────────────────────────────────
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/shop_setup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/billing/presentation/screens/billing_screen.dart';
import '../../features/inventory/presentation/screens/product_list_screen.dart';
import '../../features/inventory/presentation/screens/product_form_screen.dart';
import '../../features/parties/presentation/screens/parties_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../core/widgets/main_screen.dart';

// ── Router Notifier (bridges Riverpod → GoRouter refresh) ─────────────────

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (prev, next) => notifyListeners());
  }
  final Ref _ref;
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

// ── Router Provider ────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    refreshListenable: notifier,

    // ── Auth Guard ─────────────────────────────────────────────────────────
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final currentPath = state.uri.path;

      // Public routes — never redirect
      final publicRoutes = [
        RouteNames.splash,
        RouteNames.login,
        RouteNames.register,
      ];

      // While initial/loading — stay on splash
      if (authState is AuthInitial || authState is AuthLoading) {
        if (currentPath == RouteNames.splash) return null;
        return RouteNames.splash;
      }

      // Unauthenticated — send to login
      if (authState is AuthUnauthenticated || authState is AuthFailure) {
        if (publicRoutes.contains(currentPath)) return null;
        return RouteNames.login;
      }

      // Authenticated
      if (authState is AuthAuthenticated) {
        // If on login/register, redirect to correct screen
        if (currentPath == RouteNames.login ||
            currentPath == RouteNames.register) {
          // New user → shop setup first
          if (authState.isFirstLogin) return RouteNames.shopSetup;
          return RouteNames.dashboard;
        }

        // If on splash, redirect to appropriate screen
        if (currentPath == RouteNames.splash) {
          if (authState.isFirstLogin) return RouteNames.shopSetup;
          return RouteNames.dashboard;
        }

        // If not first login but on shop setup, redirect to dashboard
        if (!authState.isFirstLogin &&
            currentPath == RouteNames.shopSetup) {
          return RouteNames.dashboard;
        }

        return null; // allow
      }

      return null;
    },

    // ── Routes ─────────────────────────────────────────────────────────────
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.shopSetup,
        builder: (context, state) => const ShopSetupScreen(),
      ),

      // ── Main Shell ───────────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainScreen(navigationShell: navigationShell),
        branches: [
          // Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Inventory
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.products,
                builder: (context, state) => const ProductListScreen(),
                routes: [
                  GoRoute(
                    path: 'add', // Relative to /products
                    builder: (context, state) => const ProductFormScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Billing
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.billsCreate,
                builder: (context, state) => const BillingScreen(),
              ),
            ],
          ),
          // Parties
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.retailers, // Use retailers as main parties tab
                builder: (context, state) => const PartiesScreen(),
              ),
            ],
          ),
          // Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
