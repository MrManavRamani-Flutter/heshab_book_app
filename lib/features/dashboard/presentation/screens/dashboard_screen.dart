// lib/features/dashboard/presentation/screens/dashboard_screen.dart
// Phase 15 — Full implementation built in Dashboard phase

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Heshab Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: AppColors.lightTextHint),
            SizedBox(height: 16),
            Text(
              'Dashboard Coming Soon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Phase 1 Foundation ✅\nPhase 3 Auth next →',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightTextHint),
            ),
          ],
        ),
      ),
    );
  }
}
