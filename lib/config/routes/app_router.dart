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
import '../../features/auth/presentation/screens/shop_setup_screen.dart';
import '../../features/shops/presentation/screens/shop_profile_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/billing/presentation/screens/billing_screen.dart';
import '../../features/inventory/presentation/screens/product_list_screen.dart';
import '../../features/inventory/presentation/screens/product_form_screen.dart';
import '../../features/parties/presentation/screens/parties_screen.dart';
import '../../features/parties/presentation/screens/party_form_screen.dart';
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

    // ── Navigation Guard ──────────────────────────────────────────────────
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final currentPath = state.uri.path;

      // While initial/loading — stay on splash
      if (authState is AuthInitial || authState is AuthLoading) {
        if (currentPath == RouteNames.splash) return null;
        return RouteNames.splash;
      }

      // If somehow unauthenticated or failure, we stay on splash and wait for initialize
      if (authState is AuthUnauthenticated || authState is AuthFailure) {
        if (currentPath == RouteNames.splash) return null;
        // In a real failure, maybe show error, but here we'll just try home
        return RouteNames.splash;
      }

      // Authenticated (Always true now after splash)
      if (authState is AuthAuthenticated) {
        // If on splash, redirect based on shop status
        if (currentPath == RouteNames.splash) {
          return authState.isFirstLogin ? RouteNames.shopSetup : RouteNames.dashboard;
        }

        // Prevent accessing shop setup if already done
        if (!authState.isFirstLogin && currentPath == RouteNames.shopSetup) {
          return RouteNames.dashboard;
        }

        // Prevent accessing login/register
        if (currentPath == RouteNames.login || currentPath == RouteNames.register) {
          return RouteNames.dashboard;
        }

        return null;
      }

      return null;
    },

    // ── Routes ─────────────────────────────────────────────────────────────
    routes: [
      GoRoute(
        path: '/test',
        builder: (context, state) => const ProductFormScreen(),
      ),
      GoRoute(
        path: RouteNames.productsAdd,
        builder: (context, state) => const ProductFormScreen(),
      ),
      GoRoute(
        path: RouteNames.productsEdit,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return ProductFormScreen(productId: id);
        },
      ),
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.shopSetup,
        builder: (context, state) => const ShopSetupScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ShopProfileScreen(),
      ),
      GoRoute(
        path: '/add-party',
        builder: (context, state) {
          final typeString = state.uri.queryParameters['type'] ?? 'customer';
          final type = typeString == 'supplier' ? PartyType.supplier : PartyType.customer;
          return PartyFormScreen(initialType: type);
        },
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
              'Page Not Found: ${state.uri.path}',
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
