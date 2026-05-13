// lib/features/parties/presentation/screens/party_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../domain/providers/party_providers.dart';

enum PartyType { supplier, customer }

class PartyFormScreen extends ConsumerStatefulWidget {
  final PartyType initialType;
  final int? partyId;

  const PartyFormScreen({
    super.key,
    required this.initialType,
    this.partyId,
  });

  @override
  ConsumerState<PartyFormScreen> createState() => _PartyFormScreenState();
}

class _PartyFormScreenState extends ConsumerState<PartyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late PartyType _type;
  
  final _nameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    if (widget.partyId != null) {
      _loadPartyData();
    }
  }

  Future<void> _loadPartyData() async {
    // TODO: Implement loading data for edit
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shopNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final shop = ref.read(activeShopProvider);
    if (shop == null) return;

    setState(() => _isLoading = true);
    
    try {
      final name = _nameController.text.trim();
      final shopName = _shopNameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      final address = _addressController.text.trim();
      final openingBalance = double.tryParse(_openingBalanceController.text) ?? 0.0;

      if (_type == PartyType.customer) {
        await ref.read(retailerRepositoryProvider).createRetailer(
          shopId: shop.id,
          name: name,
          shopName: shopName.isEmpty ? null : shopName,
          phone: phone.isEmpty ? null : phone,
          email: email.isEmpty ? null : email,
          address: address.isEmpty ? null : address,
          openingBalance: openingBalance,
        );
      } else {
        await ref.read(supplierRepositoryProvider).createSupplier(
          shopId: shop.id,
          name: name,
          shopName: shopName.isEmpty ? null : shopName,
          phone: phone.isEmpty ? null : phone,
          email: email.isEmpty ? null : email,
          address: address.isEmpty ? null : address,
          openingBalance: openingBalance,
        );
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_type == PartyType.customer ? 'Customer' : 'Supplier'} saved successfully')),
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
    final title = widget.partyId == null 
        ? 'Add ${_type == PartyType.customer ? 'Customer' : 'Supplier'}'
        : 'Edit ${_type == PartyType.customer ? 'Customer' : 'Supplier'}';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Party Details',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('partyNameField'),
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name *',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('partyShopNameField'),
                          controller: _shopNameController,
                          decoration: const InputDecoration(
                            labelText: 'Shop Name (Optional)',
                            prefixIcon: Icon(Icons.store),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('partyPhoneField'),
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('partyEmailField'),
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('partyAddressField'),
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('partyOpeningBalanceField'),
                          controller: _openingBalanceController,
                          decoration: InputDecoration(
                            labelText: 'Opening Balance',
                            prefixIcon: const Icon(Icons.account_balance_wallet),
                            helperText: _type == PartyType.customer 
                                ? 'Amount they owe you (Receivable)' 
                                : 'Amount you owe them (Payable)',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    key: const ValueKey('savePartyButton'),
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading 
                        ? const CircularProgressIndicator() 
                        : const Text('SAVE PARTY'),
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
