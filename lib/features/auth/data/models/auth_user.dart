// lib/features/auth/data/models/auth_user.dart
//
// Lightweight in-memory user model used by AuthProvider.
// This is NOT a database model — it's a UI/state model.

class AuthUser {
  final int id;
  final String uuid;
  final String name;
  final String? mobile;
  final String? email;
  final String preferredLanguage;

  const AuthUser({
    required this.id,
    required this.uuid,
    required this.name,
    this.mobile,
    this.email,
    required this.preferredLanguage,
  });

  @override
  String toString() => 'AuthUser(id: $id, name: $name)';
}
