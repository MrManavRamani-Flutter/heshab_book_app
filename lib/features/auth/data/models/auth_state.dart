// lib/features/auth/data/models/auth_state.dart
//
// Sealed auth state — covers all possible authentication states.

import 'auth_user.dart';

sealed class AuthState {
  const AuthState();
}

/// App just launched — checking if user is logged in
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Auth operation in progress (login / register)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  final AuthUser user;
  final bool isFirstLogin; // true = route to shop setup after register

  const AuthAuthenticated({required this.user, this.isFirstLogin = false});
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An auth error occurred
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
