import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:google_fonts/google_fonts.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../l10n/app_translations.dart';
import '../providers/settings_provider.dart';
import '../utils/translation_helper.dart';
import '../utils/notification_helper.dart';

class OrderFormScreen extends ConsumerStatefulWidget {
  final OrderType type;
  const OrderFormScreen({super.key, required this.type});

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _partyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  Party? _selectedParty;
  final List<_OrderItemEntry> _entries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addEmptyEntry();
  }

  bool _reminderEnabled = true;
  int _reminderDays = 1;

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

  Future<void> _saveOrder(List<Party> existingParties, String Function(String) t, String lang) async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_partyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('err_enter_party'))));
      return;
    }

    final validEntries = _entries.where((e) => e.product != null && e.quantity > 0 && e.price > 0).toList();
    if (validEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('err_no_valid_item'))));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      
      int actualPartyId = -1;
      final typedName = _partyController.text.trim();
      if (_selectedParty != null && _selectedParty!.localizedName(lang) == typedName) {
        actualPartyId = _selectedParty!.id;
      } else {
        final matches = existingParties.where((p) => p.localizedName(lang).toLowerCase() == typedName.toLowerCase()).toList();
        if (matches.isNotEmpty) {
          actualPartyId = matches.first.id;
        } else {
          // Auto translate the party name
          final translations = await TranslationHelper.translateToAll(typedName, lang);
          actualPartyId = await db.into(db.parties).insert(
            PartiesCompanion.insert(
              nameEn: translations['en'] ?? typedName, 
              nameHi: translations['hi'] ?? typedName, 
              nameGu: translations['gu'] ?? typedName, 
              type: widget.type
            ),
          );
        }
      }

      int orderId = -1;
      await db.transaction(() async {
        
        // 1. Insert Order
        orderId = await db.into(db.orders).insert(
          OrdersCompanion.insert(
            type: widget.type,
            partyId: actualPartyId,
            date: DateTime.now(),
            totalAmount: _totalAmount,
            reminderEnabled: drift.Value(_reminderEnabled),
            reminderDays: drift.Value(_reminderDays),
            notes: drift.Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
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

      // Schedule notification if reminder enabled and global notifications are ON
      final globalNotificationsEnabled = ref.read(notificationEnabledProvider);
      if (_reminderEnabled && globalNotificationsEnabled) {
        await NotificationHelper.scheduleOrderReminder(
          orderId: orderId,
          partyName: typedName,
          pendingAmount: _totalAmount,
          days: _reminderDays,
          lang: lang,
        );
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('success_order_saved'))));
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
    _partyController.dispose();
    _notesController.dispose();
    for (var entry in _entries) {
      entry.quantityController.dispose();
      entry.priceController.dispose();
    }
    super.dispose();
  }

  void _showHelpDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text(message, style: GoogleFonts.outfit()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    
    final productsAsync = ref.watch(productsProvider);
    final partiesAsync = ref.watch(partiesProvider(widget.type));
    
    final isPurchase = widget.type == OrderType.purchase;
    final title = isPurchase ? t('new_purchase') : t('new_sale');
    final color = AppTheme.khataRed;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(child: Text(t('no_products_avail')));
          }

          return partiesAsync.when(
            data: (parties) {
              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Party Name Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Autocomplete<Party>(
                          displayStringForOption: (Party p) => p.localizedName(lang),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<Party>.empty();
                            }
                            return parties.where((Party p) {
                              return p.localizedName(lang).toLowerCase().contains(textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (Party p) {
                            setState(() {
                              _selectedParty = p;
                            });
                          },
                          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                            if (_partyController.text.isEmpty && textEditingController.text.isNotEmpty) {
                               // do nothing
                            } else if (textEditingController.text != _partyController.text) {
                               textEditingController.text = _partyController.text;
                            }
                            textEditingController.addListener(() {
                              _partyController.text = textEditingController.text;
                            });

                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: isPurchase ? t('wholesaler_name') : t('retailer_name'),
                                prefixIcon: const Icon(Icons.person),
                                suffixIcon: parties.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.blueGrey),
                                        tooltip: t('quick_select_party'),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                                            builder: (ctx) {
                                              String sheetSearch = '';
                                              return StatefulBuilder(
                                                builder: (ctx, setSheetState) {
                                                  final sheetFiltered = parties.where((p) {
                                                    if (sheetSearch.isEmpty) return true;
                                                    final q = sheetSearch.toLowerCase();
                                                    return p.nameEn.toLowerCase().contains(q) ||
                                                           p.nameHi.toLowerCase().contains(q) ||
                                                           p.nameGu.toLowerCase().contains(q) ||
                                                           (p.firmName?.toLowerCase().contains(q) ?? false) ||
                                                           (p.phone?.contains(q) ?? false);
                                                  }).toList();

                                                  return SizedBox(
                                                    height: MediaQuery.of(context).size.height * 0.7,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                                          child: TextField(
                                                            decoration: InputDecoration(
                                                              hintText: t('search_party'),
                                                              prefixIcon: const Icon(Icons.search),
                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                                            ),
                                                            onChanged: (val) => setSheetState(() => sheetSearch = val),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: sheetFiltered.isEmpty
                                                              ? Center(child: Text(t('no_parties'), style: const TextStyle(color: Colors.grey)))
                                                              : ListView.builder(
                                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                                  itemCount: sheetFiltered.length,
                                                                  itemBuilder: (ctx, pIdx) {
                                                                    final party = sheetFiltered[pIdx];
                                                                    final pName = party.localizedName(lang).trim();
                                                                    final pInitial = pName.isNotEmpty ? pName.characters.first.toUpperCase() : '?';
                                                                    return ListTile(
                                                                      leading: CircleAvatar(
                                                                        backgroundColor: AppTheme.khataRed.withValues(alpha: 0.1),
                                                                        child: Text(
                                                                          pInitial,
                                                                          style: const TextStyle(color: AppTheme.khataRed, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      title: Text(pName, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                                      subtitle: Text(party.displaySubtitle(t('no_phone')), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _selectedParty = party;
                                                                          _partyController.text = pName;
                                                                          textEditingController.text = pName;
                                                                        });
                                                                        Navigator.pop(ctx);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : null,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? t('err_required') : null,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(t('new_entry'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 12),
                    
                    // Order Items List
                    ..._entries.asMap().entries.map((mapEntry) {
                      final index = mapEntry.key;
                      final entry = mapEntry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Autocomplete<Product>(
                                      displayStringForOption: (Product p) => p.localizedDisplayName(lang),
                                      optionsBuilder: (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<Product>.empty();
                                        }
                                        return products.where((Product p) {
                                          final label = p.localizedDisplayName(lang);
                                          return label.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                        });
                                      },
                                      onSelected: (Product p) {
                                        setState(() {
                                          entry.product = p;
                                          entry.price = p.price;
                                          entry.priceController.text = p.price > 0 ? p.price.toStringAsFixed(2) : '';
                                          if (entry.quantity <= 0) {
                                            entry.quantity = 1;
                                            entry.quantityController.text = '1';
                                          }
                                        });
                                      },
                                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                        return TextFormField(
                                          controller: textEditingController,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            labelText: t('search_product'),
                                            border: const OutlineInputBorder(),
                                            prefixIcon: const Icon(Icons.search),
                                          ),
                                          validator: (val) => entry.product == null ? t('err_select_product') : null,
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    onPressed: () => _removeEntry(index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: entry.quantityController,
                                      decoration: InputDecoration(
                                        labelText: entry.product != null ? '${t('qty')} (${entry.product!.localizedUnit(lang)})' : t('qty'),
                                        suffixText: entry.product?.localizedUnit(lang),
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.numbers),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => setState(() => entry.quantity = int.tryParse(val) ?? 0),
                                      validator: (val) => (int.tryParse(val ?? '') ?? 0) <= 0 ? t('err_invalid') : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: entry.priceController,
                                      decoration: InputDecoration(
                                        labelText: t('price'),
                                        hintText: entry.product != null ? AppTranslations.formatCurrency(entry.product!.price, lang) : AppTranslations.formatStringNumber('0.00', lang),
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.currency_rupee),
                                      ),
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      onChanged: (val) {
                                        setState(() {
                                          entry.price = val.isEmpty ? (entry.product?.price ?? 0.0) : (double.tryParse(val) ?? 0.0);
                                        });
                                      },
                                      validator: (val) => entry.price <= 0 ? t('err_invalid') : null,
                                    ),
                                  ),
                                ],
                              ),
                              if (entry.total > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('${t('item_total')}: ₹${AppTranslations.formatCurrency(entry.total, lang)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    
                    // Add Item Button
                    OutlinedButton.icon(
                      onPressed: _addEmptyEntry,
                      icon: const Icon(Icons.add),
                      label: Text(t('add_another_item')),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    
                    // Reminder Settings Card
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(t('reminder_settings'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                                  onPressed: () => _showHelpDialog(context, t('reminder_settings'), t('info_reminder')),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            SwitchListTile(
                              title: Text(t('reminder_enabled')),
                              value: _reminderEnabled,
                              activeTrackColor: color.withValues(alpha: 0.5),
                              activeThumbColor: color,
                              onChanged: (val) => setState(() => _reminderEnabled = val),
                            ),
                            if (_reminderEnabled)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timer, color: Colors.grey),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        initialValue: _reminderDays,
                                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                                        items: [1, 2, 3, 5, 7, 10, 15, 30].map((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text('${AppTranslations.formatNumber(value, lang)} ${t('days')}'),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          if (val != null) setState(() => _reminderDays = val);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Order Notes / Reference
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: t('order_notes'),
                        hintText: t('order_notes_hint'),
                        prefixIcon: const Icon(Icons.note_alt_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    
                    // Total Summary Card
                    Card(
                      color: color.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color.withValues(alpha: 0.3))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t('total_bill_amount'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            Text('₹${AppTranslations.formatCurrency(_totalAmount, lang)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Save Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color, 
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        onPressed: _isLoading ? null : () => _saveOrder(parties, t, lang),
                        child: _isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : Text(t('generate_bill'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
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
