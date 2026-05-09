// lib/features/auth/data/repositories/auth_repository.dart
//
// Handles all auth operations: register, login, logout.
// Uses:
//   - UserDao for SQLite user queries
//   - ShopDao to check if user has a shop
//   - Hive for lightweight session persistence
//   - crypto package for SHA-256 password hashing

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/user_dao.dart';
import '../../../../database/daos/shop_dao.dart';
import '../models/auth_user.dart';

class AuthRepository {
  final UserDao _userDao;
  final ShopDao _shopDao;
  final Box _authBox;
  final _uuid = const Uuid();

  AuthRepository({
    required UserDao userDao,
    required ShopDao shopDao,
    required Box authBox,
  })  : _userDao = userDao,
        _shopDao = shopDao,
        _authBox = authBox;

  // ── Password Hashing ───────────────────────────────────────────────────────

  /// Hash password with SHA-256 + salt (using uuid as salt for uniqueness).
  /// Never store or compare plain text passwords.
  String _hashPassword(String password, String salt) {
    final key = utf8.encode('$salt:$password:heshabbook_v1');
    final digest = sha256.convert(key);
    return digest.toString();
  }

  // ── Session ────────────────────────────────────────────────────────────────

  /// Check if user is currently logged in (from Hive session)
  bool get isLoggedIn =>
      _authBox.get(AppConstants.keyIsLoggedIn, defaultValue: false);

  /// Get current user ID from Hive session
  int? get currentUserId =>
      _authBox.get(AppConstants.keyCurrentUserId);

  /// Restore user from Hive session
  Future<AuthUser?> restoreSession() async {
    if (!isLoggedIn) return null;
    final id = currentUserId;
    if (id == null) return null;

    final dbUser = await _userDao.findById(id);
    if (dbUser == null) {
      await _clearSession();
      return null;
    }
    return _toAuthUser(dbUser);
  }

  // ── Register ───────────────────────────────────────────────────────────────

  Future<AuthUser> register({
    required String name,
    required String mobile,
    String? email,
    required String password,
  }) async {
    // 1. Validate uniqueness
    if (await _userDao.isMobileTaken(mobile)) {
      throw AuthException('This mobile number is already registered.');
    }
    if (email != null && email.isNotEmpty) {
      if (await _userDao.isEmailTaken(email)) {
        throw AuthException('This email is already registered.');
      }
    }

    // 2. Create UUID (used as salt for hashing)
    final userUuid = _uuid.v4();

    // 3. Hash password with UUID as salt
    final passwordHash = _hashPassword(password, userUuid);

    // 4. Insert into DB
    final now = DateTime.now();
    final newId = await _userDao.insertUser(
      UsersCompanion.insert(
        uuid: userUuid,
        name: name,
        mobile: Value(mobile),
        email: Value(email?.isEmpty == true ? null : email),
        passwordHash: passwordHash,
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    // 5. Fetch the created user
    final dbUser = await _userDao.findById(newId);
    if (dbUser == null) throw AuthException('Registration failed. Try again.');

    // 6. Save session
    await _saveSession(dbUser.id);

    return _toAuthUser(dbUser);
  }

  // ── Login ──────────────────────────────────────────────────────────────────

  Future<AuthUser> login({
    required String mobileOrEmail,
    required String password,
  }) async {
    // 1. Find user by mobile or email
    final dbUser = await _userDao.findByMobileOrEmail(mobileOrEmail);
    if (dbUser == null) {
      throw AuthException('No account found with this mobile or email.');
    }

    // 2. Verify password (hash with UUID as salt)
    final expectedHash = _hashPassword(password, dbUser.uuid);
    if (dbUser.passwordHash != expectedHash) {
      throw AuthException('Incorrect password. Please try again.');
    }

    // 3. Save session
    await _saveSession(dbUser.id);

    return _toAuthUser(dbUser);
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _clearSession();
  }

  // ── Shop Check ─────────────────────────────────────────────────────────────

  /// Returns true if user has at least one shop set up
  Future<bool> hasShop(int userId) async {
    final count = await _shopDao.countShopsForUser(userId);
    return count > 0;
  }

  // ── Private Helpers ────────────────────────────────────────────────────────

  Future<void> _saveSession(int userId) async {
    await _authBox.put(AppConstants.keyIsLoggedIn, true);
    await _authBox.put(AppConstants.keyCurrentUserId, userId);
  }

  Future<void> _clearSession() async {
    await _authBox.put(AppConstants.keyIsLoggedIn, false);
    await _authBox.delete(AppConstants.keyCurrentUserId);
    await _authBox.delete(AppConstants.keyCurrentShopId);
  }

  AuthUser _toAuthUser(dynamic dbUser) {
    return AuthUser(
      id: dbUser.id,
      uuid: dbUser.uuid,
      name: dbUser.name,
      mobile: dbUser.mobile,
      email: dbUser.email,
      preferredLanguage: dbUser.preferredLanguage,
    );
  }
}

/// Typed exception for auth errors — so the UI can display clean messages
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
