// lib/features/parties/presentation/screens/parties_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PartiesScreen extends StatelessWidget {
  const PartiesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parties')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: const Center(child: Text('Supplier & Customer Management')),
      ),
    );
  }
}
