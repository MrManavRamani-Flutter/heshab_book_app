// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: const Center(child: Text('App Settings & Profile')),
      ),
    );
  }
}
