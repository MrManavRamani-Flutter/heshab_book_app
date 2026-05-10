// lib/features/settings/domain/providers/sync_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/sync_repository.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../auth/data/models/auth_state.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncState {
  final SyncStatus status;
  final String? errorMessage;
  final DateTime? lastSync;
  final String? userEmail; // Added to track signed-in Google account

  SyncState({
    this.status = SyncStatus.idle,
    this.errorMessage,
    this.lastSync,
    this.userEmail,
  });

  SyncState copyWith({
    SyncStatus? status,
    String? errorMessage,
    DateTime? lastSync,
    String? userEmail,
  }) {
    return SyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSync: lastSync ?? this.lastSync,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

final syncRepositoryProvider = Provider((ref) => SyncRepository());

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier(this._repository, this._ref) : super(SyncState());

  final SyncRepository _repository;
  final Ref _ref;

  Future<void> connectGoogle() async {
    state = state.copyWith(status: SyncStatus.syncing);
    try {
      final driveApi = await _repository.getDriveApi();
      if (driveApi != null) {
        // If login successful, get the email from the singleton
        final email = _repository.currentUserEmail;
        state = state.copyWith(status: SyncStatus.idle, userEmail: email, errorMessage: null);
      } else {
        state = state.copyWith(status: SyncStatus.idle, errorMessage: 'Sign-In cancelled');
      }
    } catch (e) {
      state = state.copyWith(status: SyncStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> performBackup() async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      state = state.copyWith(status: SyncStatus.error, errorMessage: 'User not authenticated');
      return;
    }

    state = state.copyWith(status: SyncStatus.syncing);
    try {
      await _repository.backupDatabase(authState.user.id.toString());
      state = state.copyWith(status: SyncStatus.success, lastSync: DateTime.now(), errorMessage: null);
    } catch (e) {
      state = state.copyWith(status: SyncStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> performRestore() async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      state = state.copyWith(status: SyncStatus.error, errorMessage: 'User not authenticated');
      return;
    }

    state = state.copyWith(status: SyncStatus.syncing);
    try {
      await _repository.restoreDatabase(authState.user.id.toString());
      state = state.copyWith(status: SyncStatus.success, lastSync: DateTime.now(), errorMessage: 'Restore successful! Restart app.');
    } catch (e) {
      state = state.copyWith(status: SyncStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = state.copyWith(userEmail: null, status: SyncStatus.idle, errorMessage: null);
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.watch(syncRepositoryProvider), ref);
});
