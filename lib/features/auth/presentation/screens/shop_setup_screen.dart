// lib/features/auth/presentation/screens/shop_setup_screen.dart

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/shop_dao.dart';
import '../../data/models/auth_state.dart';
import '../../domain/providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';

class ShopSetupScreen extends ConsumerStatefulWidget {
  const ShopSetupScreen({super.key});

  @override
  ConsumerState<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends ConsumerState<ShopSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedShopType = 'retail';
  bool _isSaving = false;
  String? _errorMsg;

  final List<_ShopTypeOption> _shopTypes = [
    const _ShopTypeOption(
      value: 'big_hall',
      label: 'Big Hall / Wholesale',
      subtitle: 'Sell to retailers in bulk',
      icon: Icons.warehouse_outlined,
      color: Colors.blueAccent,
    ),
    const _ShopTypeOption(
      value: 'mix_hall',
      label: 'Mix Hall + Retail',
      subtitle: 'Both wholesale and retail',
      icon: Icons.store_outlined,
      color: Colors.orangeAccent,
    ),
    const _ShopTypeOption(
      value: 'retail',
      label: 'Retail Shop',
      subtitle: 'Direct customer sales',
      icon: Icons.shopping_bag_outlined,
      color: Colors.pinkAccent,
    ),
  ];

  @override
  void dispose() {
    _shopNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _onSaveShop() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
      _errorMsg = null;
    });

    try {
      final authState = ref.read(authProvider);
      if (authState is! AuthAuthenticated) return;

      final userId = authState.user.id;
      final shopDao = sl<ShopDao>();
      final now = DateTime.now();

      await shopDao.insertShop(
        ShopsCompanion.insert(
          uuid: const Uuid().v4(),
          userId: userId,
          shopName: _shopNameController.text.trim(),
          shopType: _selectedShopType,
          phone: Value(_phoneController.text.trim().isEmpty ? null : _phoneController.text.trim()),
          address: Value(_addressController.text.trim().isEmpty ? null : _addressController.text.trim()),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      final shops = await shopDao.getShopsByUser(userId);
      if (shops.isNotEmpty) {
        await Hive.box(AppConstants.authBox).put(AppConstants.keyCurrentShopId, shops.first.id);
      }

      ref.read(authProvider.notifier).markShopSetupDone(authState.user);
    } catch (e) {
      setState(() {
        _errorMsg = 'Could not save shop. Please try again.';
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_errorMsg != null) ...[
                          _buildErrorBanner(_errorMsg!),
                          const SizedBox(height: 24),
                        ],

                        const Text('Shop Type', style: TextStyle(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        ..._shopTypes.map((type) => _buildShopTypeCard(type)),
                        
                        const SizedBox(height: 24),
                        AuthFormField(
                          label: 'Shop Name *',
                          prefixIcon: Icons.storefront_outlined,
                          controller: _shopNameController,
                          enabled: !_isSaving,
                        ),
                        const SizedBox(height: 16),
                        AuthFormField(
                          label: 'Shop Phone (Optional)',
                          prefixIcon: Icons.phone_outlined,
                          controller: _phoneController,
                          enabled: !_isSaving,
                        ),
                        const SizedBox(height: 16),
                        AuthFormField(
                          label: 'Shop Address (Optional)',
                          prefixIcon: Icons.location_on_outlined,
                          controller: _addressController,
                          enabled: !_isSaving,
                        ),
                        const SizedBox(height: 40),

                        ElevatedButton(
                          onPressed: _isSaving ? null : _onSaveShop,
                          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                          child: _isSaving
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('SAVE & START'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.store_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text('Setup Your Shop', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const Text('Start your digital bookkeeping journey', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildShopTypeCard(_ShopTypeOption type) {
    final isSelected = _selectedShopType == type.value;
    return GestureDetector(
      onTap: _isSaving ? null : () => setState(() => _selectedShopType = type.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? type.color.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? type.color : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(type.icon, color: isSelected ? type.color : Colors.white70, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.label, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(type.subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle_rounded, color: type.color),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(message, style: const TextStyle(color: Colors.redAccent)),
    );
  }
}

class _ShopTypeOption {
  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _ShopTypeOption({required this.value, required this.label, required this.subtitle, required this.icon, required this.color});
}
