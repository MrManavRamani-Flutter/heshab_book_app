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

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Cloud Sync')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlassCard(
              child: Column(
                children: [
                  Icon(
                    syncState.status == SyncStatus.error ? Icons.warning_amber_rounded : Icons.cloud_done,
                    size: 64,
                    color: syncState.status == SyncStatus.error ? Colors.orange : AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    syncState.status == SyncStatus.syncing 
                        ? 'Processing...' 
                        : (syncState.status == SyncStatus.error ? 'Action Required' : 'Direct Sync Active'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    syncState.errorMessage ?? 'Your data is automatically synced to the central admin vault.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Backup Tile
            _buildActionTile(
              title: 'Backup to Cloud',
              subtitle: syncState.lastSync != null 
                  ? 'Last: ${DateFormat('dd MMM, hh:mm a').format(syncState.lastSync!)}'
                  : 'No backup found',
              icon: Icons.backup_outlined,
              onPressed: syncState.status == SyncStatus.syncing 
                  ? null 
                  : () => syncNotifier.performBackup(),
              isLoading: syncState.status == SyncStatus.syncing,
              buttonText: 'Sync Now',
            ),
            
            const SizedBox(height: 16),
            
            // Restore Tile
            _buildActionTile(
              title: 'Restore from Cloud',
              subtitle: 'Download your latest cloud snapshot',
              icon: Icons.settings_backup_restore_outlined,
              onPressed: syncState.status == SyncStatus.syncing 
                  ? null 
                  : () => _showRestoreConfirm(context, syncNotifier),
              isLoading: syncState.status == SyncStatus.syncing,
              buttonText: 'Restore',
            ),
            
            const Spacer(),
            const Text(
              '🔒 Secured via Enterprise Service Account',
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isLoading,
    required String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        trailing: ElevatedButton(
          onPressed: onPressed,
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
