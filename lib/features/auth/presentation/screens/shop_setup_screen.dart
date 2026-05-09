// lib/features/auth/presentation/screens/shop_setup_screen.dart
//
// First-time shop setup screen shown after registration.
// Required before accessing the main app.

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/shop_dao.dart';
import '../../data/models/auth_state.dart';
import '../../domain/providers/auth_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    _ShopTypeOption(
      value: 'big_hall',
      label: 'Big Hall / Wholesale',
      subtitle: 'Sell to retailers in bulk',
      icon: Icons.warehouse_outlined,
      color: AppColors.primary,
    ),
    _ShopTypeOption(
      value: 'mix_hall',
      label: 'Mix Hall + Retail',
      subtitle: 'Both wholesale and retail',
      icon: Icons.store_outlined,
      color: AppColors.secondary,
    ),
    _ShopTypeOption(
      value: 'retail',
      label: 'Retail Shop',
      subtitle: 'Direct customer sales',
      icon: Icons.shopping_bag_outlined,
      color: AppColors.accent,
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
          phone: Value(_phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim()),
          address: Value(_addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim()),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Save current shop to Hive
      // We'll get the newly created shop's ID
      final shops = await shopDao.getShopsByUser(userId);
      if (shops.isNotEmpty) {
        await Hive.box(AppConstants.authBox)
            .put(AppConstants.keyCurrentShopId, shops.first.id);
      }

      // Mark shop setup complete
      ref
          .read(authProvider.notifier)
          .markShopSetupDone(authState.user);
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
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────────────
              _buildHeader(),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Error
                      if (_errorMsg != null) ...[
                        _buildErrorBanner(_errorMsg!),
                        const SizedBox(height: 16),
                      ],

                      // Shop Type Selector
                      Text(
                        'Shop Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._shopTypes.map((type) => _buildShopTypeCard(type)),
                      const SizedBox(height: 20),

                      // Shop Name
                      TextFormField(
                        controller: _shopNameController,
                        enabled: !_isSaving,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Shop Name *',
                          hintText: 'e.g. Ramani Cloth House',
                          prefixIcon: Icon(Icons.storefront_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your shop name';
                          }
                          if (v.trim().length < 2) {
                            return 'Shop name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Phone
                      TextFormField(
                        controller: _phoneController,
                        enabled: !_isSaving,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Shop Phone (Optional)',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        enabled: !_isSaving,
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Shop Address (Optional)',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _onSaveShop,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Save & Start →',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.store_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Setup Your Shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You can add more shops later from settings',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopTypeCard(_ShopTypeOption type) {
    final isSelected = _selectedShopType == type.value;
    return GestureDetector(
      onTap: _isSaving
          ? null
          : () => setState(() => _selectedShopType = type.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? type.color.withValues(alpha: 0.08)
              : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? type.color : AppColors.lightDivider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? type.color.withValues(alpha: 0.15)
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(type.icon,
                  color: isSelected ? type.color : AppColors.lightTextHint,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? type.color
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: type.color, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                    color: AppColors.error, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _ShopTypeOption {
  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ShopTypeOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
