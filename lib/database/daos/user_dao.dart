// lib/database/daos/user_dao.dart

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  /// Find user by mobile number
  Future<User?> findByMobile(String mobile) {
    return (select(users)
          ..where((u) => u.mobile.equals(mobile))
          ..where((u) => u.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  /// Find user by email
  Future<User?> findByEmail(String email) {
    return (select(users)
          ..where((u) => u.email.equals(email))
          ..where((u) => u.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  /// Find user by mobile or email
  Future<User?> findByMobileOrEmail(String value) async {
    final byMobile = await findByMobile(value);
    if (byMobile != null) return byMobile;
    return findByEmail(value);
  }

  /// Find user by ID
  Future<User?> findById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  /// Insert new user — returns the new row's ID
  Future<int> insertUser(UsersCompanion entry) {
    return into(users).insert(entry);
  }

  /// Update user (e.g. profile changes)
  Future<bool> updateUser(UsersCompanion entry) {
    return update(users).replace(entry);
  }

  /// Check if mobile number is already taken
  Future<bool> isMobileTaken(String mobile) async {
    final user = await findByMobile(mobile);
    return user != null;
  }

  /// Check if email is already taken
  Future<bool> isEmailTaken(String email) async {
    final user = await findByEmail(email);
    return user != null;
  }

  /// Soft delete user (RULE-003: never hard delete)
  Future<void> softDeleteUser(int id) {
    return (update(users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
