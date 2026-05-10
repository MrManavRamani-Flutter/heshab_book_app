// lib/features/settings/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/route_names.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Cloud & Backup'),
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
              title: const Text('Google Drive Backup'),
              subtitle: const Text('Manage your 5TB cloud storage'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(RouteNames.cloudSync),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Account'),
            ListTile(
              leading: const Icon(Icons.person_outline, color: AppColors.accent),
              title: const Text('Shop Profile'),
              subtitle: const Text('Manage business details'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Logout logic
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
