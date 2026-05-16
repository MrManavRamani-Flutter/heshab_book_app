import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../providers/database_provider.dart';
import '../database/database.dart';

class OrderFormScreen extends ConsumerStatefulWidget {
  final OrderType type;
  const OrderFormScreen({super.key, required this.type});

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _partyNameController = TextEditingController();
  final List<_OrderItemEntry> _entries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addEmptyEntry();
  }

  void _addEmptyEntry() {
    setState(() {
      _entries.add(_OrderItemEntry());
    });
  }

  void _removeEntry(int index) {
    setState(() {
      if (_entries.length > 1) {
        _entries.removeAt(index);
      }
    });
  }

  double get _totalAmount {
    return _entries.fold(0.0, (sum, entry) => sum + entry.total);
  }

  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate()) return;
    
    final validEntries = _entries.where((e) => e.product != null && e.quantity > 0 && e.price > 0).toList();
    if (validEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one valid item.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      await db.transaction(() async {
        // 1. Insert Order
        final orderId = await db.into(db.orders).insert(
          OrdersCompanion.insert(
            type: widget.type,
            partyName: _partyNameController.text.trim(),
            date: DateTime.now(),
            totalAmount: _totalAmount,
          ),
        );

        // 2. Insert Items and update stock
        for (final entry in validEntries) {
          await db.into(db.orderItems).insert(
            OrderItemsCompanion.insert(
              orderId: orderId,
              productId: entry.product!.id,
              quantity: entry.quantity,
              price: entry.price,
              total: entry.total,
            ),
          );

          // Update product stock
          final newStock = widget.type == OrderType.purchase
              ? entry.product!.stock + entry.quantity
              : entry.product!.stock - entry.quantity;

          await (db.update(db.products)..where((p) => p.id.equals(entry.product!.id))).write(
            ProductsCompanion(stock: drift.Value(newStock)),
          );
        }
      });

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order saved successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _partyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final title = widget.type == OrderType.purchase ? 'New Purchase (Wholesale)' : 'New Sale (Retailer)';
    final color = widget.type == OrderType.purchase ? Colors.blueGrey : Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available. Please add products first.'));
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _partyNameController,
                  decoration: InputDecoration(
                    labelText: widget.type == OrderType.purchase ? 'Max Hall Vepari Name' : 'Retailer Name',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                Text('Order Items', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ..._entries.asMap().entries.map((mapEntry) {
                  final index = mapEntry.key;
                  final entry = mapEntry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<Product>(
                              initialValue: entry.product,
                              isExpanded: true,
                              decoration: const InputDecoration(labelText: 'Product', border: OutlineInputBorder()),
                              items: products.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text('${p.name} ${p.variety != null ? "(${p.variety})" : ""}'),
                                );
                              }).toList(),
                              onChanged: (p) {
                                setState(() {
                                  entry.product = p;
                                  if (p != null && entry.price == 0) {
                                    entry.price = p.price;
                                    entry.priceController.text = p.price.toString();
                                  }
                                });
                              },
                              validator: (val) => val == null ? 'Select product' : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: entry.quantityController,
                              decoration: const InputDecoration(labelText: 'Qty', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              onChanged: (val) => setState(() => entry.quantity = int.tryParse(val) ?? 0),
                              validator: (val) => (int.tryParse(val ?? '') ?? 0) <= 0 ? 'Invalid' : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: entry.priceController,
                              decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (val) => setState(() => entry.price = double.tryParse(val) ?? 0.0),
                              validator: (val) => (double.tryParse(val ?? '') ?? 0) <= 0 ? 'Invalid' : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeEntry(index),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addEmptyEntry,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Another Item'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount:', style: Theme.of(context).textTheme.titleLarge),
                    Text('₹${_totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
                    onPressed: _isLoading ? null : _saveOrder,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SAVE BILL'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _OrderItemEntry {
  Product? product;
  int quantity = 0;
  double price = 0.0;
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  double get total => quantity * price;
}
