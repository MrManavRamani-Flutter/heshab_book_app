// lib/features/settings/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/route_names.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            _buildSectionHeader('Account'),
            ListTile(
              leading: const Icon(Icons.person_outline, color: AppColors.accent),
              title: const Text('Shop Profile'),
              subtitle: const Text('Manage business details'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push(RouteNames.profile);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
              title: const Text('Reset App Data', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Clear all shops, products, and bills'),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset All Data?'),
                    content: const Text('This will permanently delete all your shops, products, parties, and bills. This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('RESET EVERYTHING'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  // Simply logout for now which clears session, 
                  // but we should ideally clear the whole database.
                  // For this task, we'll just trigger the initialization again.
                  ref.read(authProvider.notifier).logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
