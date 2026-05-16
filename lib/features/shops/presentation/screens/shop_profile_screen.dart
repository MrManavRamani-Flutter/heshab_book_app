// lib/features/shops/presentation/screens/shop_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../../auth/presentation/widgets/auth_form_field.dart';
import '../../domain/providers/shop_providers.dart';

class ShopProfileScreen extends ConsumerStatefulWidget {
  const ShopProfileScreen({super.key});

  @override
  ConsumerState<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends ConsumerState<ShopProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstController = TextEditingController();
  
  String _selectedShopType = 'retail';
  bool _isSaving = false;
  bool _isInitialized = false;

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
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  void _initialize(Shop shop) {
    if (_isInitialized) return;
    _nameController.text = shop.shopName;
    _phoneController.text = shop.phone ?? '';
    _addressController.text = shop.address ?? '';
    _gstController.text = shop.gstNumber ?? '';
    _selectedShopType = shop.shopType;
    _isInitialized = true;
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    final activeShop = ref.read(activeShopProvider);
    if (activeShop == null) return;

    setState(() => _isSaving = true);

    try {
      final success = await ref.read(shopRepositoryProvider).updateShop(
        id: activeShop.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        gstNumber: _gstController.text.trim(),
        type: _selectedShopType,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shop profile updated successfully')),
          );
          if (mounted) context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update shop profile')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeShop = ref.watch(activeShopProvider);

    if (activeShop == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _initialize(activeShop);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Business Identity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Update your business details shown on bills and reports',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  AuthFormField(
                    label: 'Shop Name *',
                    prefixIcon: Icons.storefront_outlined,
                    controller: _nameController,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  AuthFormField(
                    label: 'GST Number (Optional)',
                    prefixIcon: Icons.receipt_long_outlined,
                    controller: _gstController,
                  ),
                  const SizedBox(height: 16),

                  AuthFormField(
                    label: 'Contact Phone',
                    prefixIcon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  AuthFormField(
                    label: 'Address',
                    prefixIcon: Icons.location_on_outlined,
                    controller: _addressController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Shop Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._shopTypes.map((type) => _buildShopTypeCard(type)),

                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'UPDATE PROFILE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShopTypeCard(_ShopTypeOption type) {
    final isSelected = _selectedShopType == type.value;
    return GestureDetector(
      onTap: () => setState(() => _selectedShopType = type.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
            ? type.color.withValues(alpha: 0.1) 
            : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? type.color : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              type.icon,
              color: isSelected ? type.color : Colors.white70,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    type.subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: type.color),
          ],
        ),
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
