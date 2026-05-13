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
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/unit_repository.dart';
import '../../../../config/di/service_locator.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../database/app_database.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final int? productId;
  const ProductFormScreen({super.key, this.productId});

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
  final _openingStockController = TextEditingController(text: '0');

  int? _selectedCategoryId;
  int? _selectedUnitId;
  bool _isLoading = false;
  bool _isEdit = false;
  bool _dataLoaded = false; // guard so controllers are populated only once

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _purchasePriceController.dispose();
    _retailPriceController.dispose();
    _minStockController.dispose();
    _openingStockController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isEdit = widget.productId != null;
  }

  /// Populate form controllers once from a loaded product — idempotent.
  void _populateForm(Product product) {
    if (_dataLoaded) return;
    _dataLoaded = true;
    _nameController.text = product.name;
    _codeController.text = product.code ?? '';
    _purchasePriceController.text = product.purchasePrice.toString();
    _retailPriceController.text = product.retailPrice.toString();
    _minStockController.text = product.minimumStockAlert.toString();
    _openingStockController.text = product.currentStock.toString();
    _selectedCategoryId = product.categoryId;
    _selectedUnitId = product.unitId;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final activeShop = ref.read(activeShopProvider);
    if (activeShop == null) return;

    setState(() => _isLoading = true);

    try {
      final productRepo = ref.read(productRepositoryProvider);

      if (_isEdit) {
        await productRepo.updateProduct(
          id: widget.productId!,
          name: _nameController.text,
          code: _codeController.text.isEmpty ? null : _codeController.text,
          purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
          retailPrice: double.tryParse(_retailPriceController.text) ?? 0,
          minimumStockAlert: double.tryParse(_minStockController.text) ?? 5,
          categoryId: _selectedCategoryId,
          unitId: _selectedUnitId,
        );
      } else {
        await productRepo.createProduct(
          shopId: activeShop.id,
          name: _nameController.text,
          code: _codeController.text.isEmpty ? null : _codeController.text,
          purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
          retailPrice: double.tryParse(_retailPriceController.text) ?? 0,
          openingStock: double.tryParse(_openingStockController.text) ?? 0,
          minimumStockAlert: double.tryParse(_minStockController.text) ?? 5,
          categoryId: _selectedCategoryId,
          unitId: _selectedUnitId,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEdit ? 'Product updated successfully' : 'Product added successfully'),
            backgroundColor: AppColors.accent,
          ),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.products);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final nameController = TextEditingController();
    final activeShop = ref.read(activeShopProvider);
    if (activeShop == null) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final repo = sl<CategoryRepository>();
                await repo.createCategory(shopId: activeShop.id, name: nameController.text);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddUnitDialog() async {
    final nameController = TextEditingController();
    final activeShop = ref.read(activeShopProvider);
    if (activeShop == null) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Unit'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Unit Name (e.g. Meter, Qty)'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final repo = sl<UnitRepository>();
                await repo.createUnit(shopId: activeShop.id, name: nameController.text);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Typed async values - retain generic types for dropdown compatibility
    final categoriesAsync = ref.watch(shopCategoriesProvider);
    final unitsAsync = ref.watch(shopUnitsProvider);

    // For edit mode: show a loading screen until product data is fetched,
    // then populate controllers exactly once and build the form.
    if (_isEdit && !_dataLoaded) {
      return FutureBuilder<Product?>(
        future: ref.read(productRepositoryProvider).getProductById(widget.productId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit Product')),
              body: Container(
                decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            _populateForm(snapshot.data!); // synchronous, idempotent
          }
          return _buildForm(context, categoriesAsync, unitsAsync);
        },
      );
    }

    return _buildForm(context, categoriesAsync, unitsAsync);
  }

  Widget _buildForm(
    BuildContext context,
    AsyncValue<List<Category>> categoriesAsync,
    AsyncValue<List<Unit>> unitsAsync,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Product' : 'Add Product')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ── Name & Code ───────────────────────────────────────────────
                GlassCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      TextFormField(
                        key: const ValueKey('productNameField'),
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name*',
                          prefixIcon: Icon(Icons.shopping_bag_outlined),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        key: const ValueKey('productCodeField'),
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

                // ── Category & Unit ───────────────────────────────────────────
                GlassCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: categoriesAsync.when(
                              data: (categories) => DropdownButtonFormField<int>(
                                decoration: const InputDecoration(labelText: 'Category'),
                                items: categories
                                    .map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.name)))
                                    .toList(),
                                onChanged: (v) => setState(() => _selectedCategoryId = v),
                                initialValue: _selectedCategoryId,
                              ),
                              loading: () => const LinearProgressIndicator(),
                              error: (e, s) => Text('Error: $e'),
                            ),
                          ),
                          IconButton(
                            key: const ValueKey('addCategoryButton'),
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                            onPressed: _showAddCategoryDialog,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: unitsAsync.when(
                              data: (units) => DropdownButtonFormField<int>(
                                decoration: const InputDecoration(labelText: 'Unit (Meter, Qty, etc)'),
                                items: units
                                    .map((u) => DropdownMenuItem<int>(value: u.id, child: Text(u.name)))
                                    .toList(),
                                onChanged: (v) => setState(() => _selectedUnitId = v),
                                initialValue: _selectedUnitId,
                              ),
                              loading: () => const LinearProgressIndicator(),
                              error: (e, s) => Text('Error: $e'),
                            ),
                          ),
                          IconButton(
                            key: const ValueKey('addUnitButton'),
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                            onPressed: _showAddUnitDialog,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Pricing & Stock ────────────────────────────────────────────
                GlassCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('purchasePriceField'),
                              controller: _purchasePriceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Purchase Price',
                                prefixIcon: Icon(Icons.currency_rupee),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('retailPriceField'),
                              controller: _retailPriceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Retail Price',
                                prefixIcon: Icon(Icons.currency_rupee),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('minStockField'),
                              controller: _minStockController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Min Stock Alert',
                                prefixIcon: Icon(Icons.warning_amber_outlined),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey('openingStockField'),
                              controller: _openingStockController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              enabled: !_isEdit,
                              decoration: InputDecoration(
                                labelText: _isEdit ? 'Current Stock' : 'Opening Stock',
                                prefixIcon: const Icon(Icons.inventory_2_outlined),
                                helperText: _isEdit ? 'Use stock management to adjust' : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

                // ── Save Button ────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    key: const ValueKey('saveProductButton'),
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isEdit ? 'UPDATE PRODUCT' : 'SAVE PRODUCT',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
