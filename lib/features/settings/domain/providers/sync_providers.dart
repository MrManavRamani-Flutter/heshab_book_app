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

  SyncState({
    this.status = SyncStatus.idle,
    this.errorMessage,
    this.lastSync,
  });

  SyncState copyWith({
    SyncStatus? status,
    String? errorMessage,
    DateTime? lastSync,
  }) {
    return SyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSync: lastSync ?? this.lastSync,
    );
  }
}

final syncRepositoryProvider = Provider((ref) => SyncRepository());

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier(this._repository, this._ref) : super(SyncState());

  final SyncRepository _repository;
  final Ref _ref;

  Future<void> performBackup() async {
    final authState = _ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      state = state.copyWith(status: SyncStatus.error, errorMessage: 'User not authenticated');
      return;
    }

    state = state.copyWith(status: SyncStatus.syncing);
    try {
      // Direct backup using service account (No login required)
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
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.watch(syncRepositoryProvider), ref);
});
