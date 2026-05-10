// lib/features/settings/presentation/screens/cloud_sync_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/providers/sync_providers.dart';

class CloudSyncScreen extends ConsumerWidget {
  const CloudSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    final syncNotifier = ref.read(syncProvider.notifier);
    final isConnected = syncState.userEmail != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Cloud Sync')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Google Account Connection Card
            _buildConnectionCard(syncState, syncNotifier),
            
            const SizedBox(height: 24),
            
            // 2. Backup Tile (Enabled only if connected)
            _buildActionTile(
              title: 'Backup to Cloud',
              subtitle: syncState.lastSync != null 
                  ? 'Last: ${DateFormat('dd MMM, hh:mm a').format(syncState.lastSync!)}'
                  : 'No backup found',
              icon: Icons.backup_outlined,
              isEnabled: isConnected && syncState.status != SyncStatus.syncing,
              onPressed: () => syncNotifier.performBackup(),
              isLoading: syncState.status == SyncStatus.syncing && !isConnected, // simplified check
              buttonText: 'Sync Now',
            ),
            
            const SizedBox(height: 16),
            
            // 3. Restore Tile (Enabled only if connected)
            _buildActionTile(
              title: 'Restore from Cloud',
              subtitle: 'Download your latest cloud snapshot',
              icon: Icons.settings_backup_restore_outlined,
              isEnabled: isConnected && syncState.status != SyncStatus.syncing,
              onPressed: () => _showRestoreConfirm(context, syncNotifier),
              isLoading: false, // Restore has its own confirm dialog
              buttonText: 'Restore',
            ),
            
            const Spacer(),
            const Text(
              '🔒 Secure Cloud Sync via Personal Drive',
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(SyncState state, SyncNotifier notifier) {
    final isConnected = state.userEmail != null;
    
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isConnected ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isConnected ? Icons.account_circle : Icons.warning_amber_rounded,
                  color: isConnected ? Colors.green : Colors.orange,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isConnected ? 'Google Account Connected' : 'Account Required',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      isConnected ? state.userEmail! : 'Connect your account to enable sync',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.status == SyncStatus.syncing 
                  ? null 
                  : (isConnected ? () => notifier.signOut() : () => notifier.connectGoogle()),
              icon: state.status == SyncStatus.syncing 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(isConnected ? Icons.logout : Icons.login),
              label: Text(isConnected ? 'Disconnect Account' : 'Connect Google Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected ? Colors.red.withValues(alpha: 0.1) : AppColors.primary,
                foregroundColor: isConnected ? Colors.red : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (state.errorMessage != null && !isConnected) ...[
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
    required bool isLoading,
    required String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: isEnabled ? 0.5 : 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          trailing: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              foregroundColor: AppColors.primary,
              elevation: 0,
            ),
            child: isLoading 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(buttonText),
          ),
        ),
      ),
    );
  }

  void _showRestoreConfirm(BuildContext context, SyncNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data?'),
        content: const Text('This will overwrite your current local data with the cloud backup. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.performRestore();
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }
}
