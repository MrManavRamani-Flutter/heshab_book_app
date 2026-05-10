// lib/features/inventory/presentation/screens/product_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/providers/product_providers.dart';
import '../../domain/providers/inventory_providers.dart';
import '../../../shops/domain/providers/shop_providers.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _purchasePriceController = TextEditingController(text: '0');
  final _retailPriceController = TextEditingController(text: '0');
  final _minStockController = TextEditingController(text: '5');
  
  int? _selectedCategoryId;
  int? _selectedUnitId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _purchasePriceController.dispose();
    _retailPriceController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final activeShop = ref.read(activeShopProvider);
    if (activeShop == null) return;

    setState(() => _isLoading = true);

    try {
      final productRepo = ref.read(productRepositoryProvider);
      await productRepo.createProduct(
        shopId: activeShop.id,
        name: _nameController.text,
        code: _codeController.text.isEmpty ? null : _codeController.text,
        purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
        retailPrice: double.tryParse(_retailPriceController.text) ?? 0,
        minimumStockAlert: double.tryParse(_minStockController.text) ?? 5,
        categoryId: _selectedCategoryId,
        unitId: _selectedUnitId,
      );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(shopCategoriesProvider);
    final unitsAsync = ref.watch(shopUnitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GlassCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name*',
                          prefixIcon: Icon(Icons.shopping_bag_outlined),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: 'Product Code / Barcode',
                          prefixIcon: Icon(Icons.qr_code_scanner),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                GlassCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      categoriesAsync.when(
                        data: (list) => DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: list.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                          onChanged: (v) => setState(() => _selectedCategoryId = v),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, s) => Text('Error: $e'),
                      ),
                      SizedBox(height: 16.h),
                      unitsAsync.when(
                        data: (list) => DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Unit (kg, pcs, etc)'),
                          items: list.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))).toList(),
                          onChanged: (v) => setState(() => _selectedUnitId = v),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, s) => Text('Error: $e'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                GlassCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _purchasePriceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Purchase Price'),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: TextFormField(
                              controller: _retailPriceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Retail Price'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _minStockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Min Stock Alert'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('SAVE PRODUCT', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
