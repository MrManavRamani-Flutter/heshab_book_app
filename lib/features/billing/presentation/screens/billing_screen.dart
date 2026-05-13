// lib/features/billing/presentation/screens/billing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../inventory/domain/providers/product_providers.dart';
import '../../../parties/domain/providers/party_providers.dart';
import '../providers/billing_notifier.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingState = ref.watch(billingNotifierProvider);
    final billingNotifier = ref.read(billingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(billingState.billType == 'sales' ? 'New Sales Bill' : 'New Purchase Bill'),
        actions: [
          Switch(
            value: billingState.billType == 'sales',
            onChanged: (isSales) {
              billingNotifier.setBillType(isSales ? 'sales' : 'purchase');
            },
            activeThumbColor: AppColors.accent,
            activeTrackColor: AppColors.accent.withValues(alpha: 0.2),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(child: Text(billingState.billType.toUpperCase(), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: Column(
          children: [
            // ── Party Selection & Search ─────────────────────────────────────
            _buildHeader(context, ref, billingState, billingNotifier),

            // ── Cart Items ───────────────────────────────────────────────────
            Expanded(
              child: billingState.items.isEmpty
                  ? _buildEmptyCart(context)
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: billingState.items.length,
                            itemBuilder: (context, index) {
                              final item = billingState.items[index];
                              return _buildCartItem(context, item, billingNotifier);
                            },
                          ),
                        ),
                        if (billingState.suggestions.isNotEmpty)
                          _buildSuggestions(context, billingState, billingNotifier),
                      ],
                    ),
            ),

            // ── Footer (Totals) ──────────────────────────────────────────────
            _buildFooter(context, billingState, billingNotifier),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('addItemButton'),
        onPressed: () => _showProductPicker(context, ref, billingNotifier),
        label: const Text('Add Item'),
        icon: const Icon(Icons.add_shopping_cart),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, dynamic state, dynamic notifier) {
    final partiesAsync = state.billType == 'sales' 
        ? ref.watch(shopRetailersProvider) 
        : ref.watch(shopSuppliersProvider);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GlassCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            partiesAsync.when(
              data: (parties) => DropdownButtonFormField<int>(
                key: const ValueKey('partyDropdown'),
                initialValue: state.selectedPartyId,
                decoration: InputDecoration(
                  labelText: state.billType == 'sales' ? 'Select Customer' : 'Select Supplier',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
                items: parties.map<DropdownMenuItem<int>>((p) {
                   // Cast as dynamic to access .name safely for both Supplier/Retailer
                   final dynamic party = p;
                   return DropdownMenuItem<int>(
                    value: party.id,
                    child: Text(party.name),
                  );
                }).toList(),
                onChanged: (val) => notifier.setParty(val),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, s) => Text('Error loading parties: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 64.w, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text('Your cart is empty', style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp)),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item, dynamic notifier) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GlassCard(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('₹${item.rate} x ${item.quantity}', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
                ],
              ),
            ),
            Text('₹${item.total}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              onPressed: () => notifier.removeItem(item.product.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, dynamic state, dynamic notifier) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Subtotal', '₹${state.subtotal}'),
          _buildSummaryRow('Tax', '₹${state.taxAmount}', isEditable: true, onEdit: (v) => notifier.setTax(double.tryParse(v) ?? 0)),
          const Divider(color: AppColors.glassBorder),
          _buildSummaryRow('Total Amount', '₹${state.totalAmount}', isBold: true),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              key: const ValueKey('saveBillButton'),
              onPressed: state.isLoading ? null : () async {
                final success = await notifier.saveBill();
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill saved successfully!')));
                  context.pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: state.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SAVE BILL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isEditable = false, Function(String)? onEdit}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isBold ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isBold ? FontWeight.bold : null)),
          isEditable 
            ? SizedBox(width: 60.w, child: TextField(
                textAlign: TextAlign.end,
                decoration: const InputDecoration(isDense: true, border: InputBorder.none),
                style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                onChanged: onEdit,
                keyboardType: TextInputType.number,
              ))
            : Text(value, style: TextStyle(color: isBold ? AppColors.accent : AppColors.textPrimary, fontWeight: isBold ? FontWeight.bold : null)),
        ],
      ),
    );
  }

  void _showProductPicker(BuildContext context, WidgetRef ref, dynamic notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 0.8.sh,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final productsAsync = ref.watch(shopProductsProvider);
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Text('Select Product', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: productsAsync.when(
                    data: (products) => ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return ListTile(
                          key: ValueKey('productItem_${p.id}'),
                          title: Text(p.name),
                          subtitle: Text('Stock: ${p.currentStock}'),
                          trailing: Text('₹${p.retailPrice}'),
                          onTap: () {
                            notifier.addItem(p, 1, p.retailPrice);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, dynamic state, dynamic notifier) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: const Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'MATCHING ITEMS (PALAV/SET)',
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: state.suggestions.length,
              itemBuilder: (context, index) {
                final p = state.suggestions[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () => notifier.addItem(p, 1, p.retailPrice),
                      child: Container(
                        width: 150.w,
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                            Text('₹${p.retailPrice}', style: TextStyle(fontSize: 11.sp, color: AppColors.accent)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
