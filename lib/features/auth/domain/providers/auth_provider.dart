// lib/features/auth/domain/providers/auth_provider.dart
//
// Riverpod Notifier for authentication state.
// All screens and the router listen to this provider.
//
// RULE-009: Using Notifier (Riverpod 2.x code gen) instead of StateNotifier.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../config/di/service_locator.dart';
import '../../data/models/auth_state.dart';
import '../../data/models/auth_user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

// ── Repository Provider ────────────────────────────────────────────────────

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return sl<AuthRepository>();
}

// ── Auth Notifier ──────────────────────────────────────────────────────────

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthInitial();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Called once at app startup to restore session from Hive + SQLite
  Future<void> initialize() async {
    state = const AuthLoading();
    try {
      final user = await _repo.restoreSession();
      if (user != null) {
        final hasShop = await _repo.hasShop(user.id);
        state = AuthAuthenticated(user: user, isFirstLogin: !hasShop);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (_) {
      state = const AuthUnauthenticated();
    }
  }

  /// Register a new user, then check if they need shop setup
  Future<void> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repo.register(
        name: name,
        mobile: mobile,
        email: email,
        password: password,
      );
      // New user always needs shop setup
      state = AuthAuthenticated(user: user, isFirstLogin: true);
    } on AuthException catch (e) {
      state = AuthFailure(e.message);
    } catch (e) {
      state = AuthFailure('Something went wrong. Please try again.');
    }
  }

  /// Login existing user
  Future<void> login({
    required String mobileOrEmail,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repo.login(
        mobileOrEmail: mobileOrEmail,
        password: password,
      );
      final hasShop = await _repo.hasShop(user.id);
      state = AuthAuthenticated(user: user, isFirstLogin: !hasShop);
    } on AuthException catch (e) {
      state = AuthFailure(e.message);
    } catch (e) {
      state = AuthFailure('Something went wrong. Please try again.');
    }
  }

  /// Mark first login complete (after shop setup)
  void markShopSetupDone(AuthUser user) {
    state = AuthAuthenticated(user: user, isFirstLogin: false);
  }

  /// Logout
  Future<void> logout() async {
    await _repo.logout();
    state = const AuthUnauthenticated();
  }

  /// Clear error state (e.g. when user starts typing again)
  void clearError() {
    if (state is AuthFailure) {
      state = const AuthUnauthenticated();
    }
  }
}

// ── Convenience Selectors ──────────────────────────────────────────────────

@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
}

@riverpod
AuthUser? currentUser(CurrentUserRef ref) {
  final state = ref.watch(authProvider);
  return state is AuthAuthenticated ? state.user : null;
}
