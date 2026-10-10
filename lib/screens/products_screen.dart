import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:google_fonts/google_fonts.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_translations.dart';
import '../utils/translation_helper.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, {Product? productToEdit}) {
    final lang = ref.read(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final formKey = GlobalKey<FormState>();
    
    // Name controllers
    final nameEnController = TextEditingController(text: productToEdit?.nameEn ?? '');
    final nameHiController = TextEditingController(text: productToEdit?.nameHi ?? '');
    final nameGuController = TextEditingController(text: productToEdit?.nameGu ?? '');
    final mainNameController = TextEditingController(text: productToEdit?.localizedDisplayName(lang) ?? '');
    
    // Price and Stock
    final priceController = TextEditingController(text: productToEdit?.price.toString() ?? '');
    final stockController = TextEditingController(text: productToEdit?.stock.toString() ?? '');
    String selectedUnit = productToEdit?.unit ?? 'Meter';
    final units = ['Meter', 'Pcs', 'Roll', 'Than', 'Bundle'];
    
    bool isManual = false;
    final isEdit = productToEdit != null;

    void deleteProduct(BuildContext dialogContext) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(t('delete')),
          content: Text(t('delete_confirm')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t('cancel'))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t('delete')),
            ),
          ],
        ),
      );

      if (confirm == true && productToEdit != null) {
        final prodId = productToEdit.id;
        final db = ref.read(databaseProvider);
        final used = await (db.select(db.orderItems)..where((oi) => oi.productId.equals(prodId))).get();
        if (used.isNotEmpty) {
          if (dialogContext.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t('product_in_use_warning')), backgroundColor: Colors.orange.shade800),
            );
          }
          return;
        }
        await (db.delete(db.products)..where((p) => p.id.equals(prodId))).go();
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('product_deleted'))));
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEdit ? t('edit_product') : t('add_new_product')),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: Text(t('auto_translate')),
                              selected: !isManual,
                              onSelected: (val) => setState(() => isManual = !val),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(t('manual_edit')),
                              selected: isManual,
                              onSelected: (val) => setState(() => isManual = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      if (!isManual)
                        TextFormField(
                          controller: mainNameController,
                          decoration: InputDecoration(
                            labelText: t('name'),
                            prefixIcon: const Icon(Icons.inventory_2),
                            helperText: t('auto_translate_hint'),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty ? t('err_required') : null,
                        )
                      else ...[
                        TextFormField(
                          controller: nameEnController,
                          decoration: InputDecoration(labelText: t('name_en'), prefixIcon: const Icon(Icons.language)),
                          validator: (val) => val == null || val.trim().isEmpty ? t('err_required') : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: nameHiController,
                          decoration: InputDecoration(labelText: t('name_hi'), prefixIcon: const Icon(Icons.language)),
                          validator: (val) => val == null || val.trim().isEmpty ? t('err_required') : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: nameGuController,
                          decoration: InputDecoration(labelText: t('name_gu'), prefixIcon: const Icon(Icons.language)),
                          validator: (val) => val == null || val.trim().isEmpty ? t('err_required') : null,
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      Text(t('unit'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: units.map((u) {
                          String unitLabel = u;
                          if (u == 'Meter') unitLabel = t('unit_meter');
                          if (u == 'Pcs') unitLabel = t('unit_pcs');
                          if (u == 'Roll') unitLabel = t('unit_roll');
                          if (u == 'Than') unitLabel = t('unit_than');
                          if (u == 'Bundle') unitLabel = t('unit_bundle');
                          final isSelected = selectedUnit == u;
                          return ChoiceChip(
                            label: Text(unitLabel),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) setState(() => selectedUnit = u);
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                          labelText: t('price'), 
                          prefixIcon: const Icon(Icons.currency_rupee),
                          suffixText: '/ $selectedUnit',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (val) => val == null || double.tryParse(val) == null ? t('err_invalid_amount') : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: stockController,
                        decoration: InputDecoration(
                          labelText: t('stock'), 
                          prefixIcon: const Icon(Icons.layers),
                          suffixText: selectedUnit,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || int.tryParse(val) == null ? t('err_invalid_qty') : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (isEdit)
                  TextButton.icon(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                    label: Text(t('delete'), style: const TextStyle(color: Colors.red)),
                    onPressed: () => deleteProduct(context),
                  ),
                const Spacer(),
                TextButton(onPressed: () => Navigator.pop(context), child: Text(t('cancel'))),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final db = ref.read(databaseProvider);
                      
                      String finalEn, finalHi, finalGu;
                      if (isManual) {
                        finalEn = nameEnController.text.trim();
                        finalHi = nameHiController.text.trim();
                        finalGu = nameGuController.text.trim();
                      } else {
                        final typedName = mainNameController.text.trim();
                        final translations = await TranslationHelper.translateToAll(typedName, lang);
                        finalEn = translations['en'] ?? typedName;
                        finalHi = translations['hi'] ?? typedName;
                        finalGu = translations['gu'] ?? typedName;
                      }

                      final price = double.parse(priceController.text);
                      final stock = int.parse(stockController.text);

                      if (isEdit) {
                        // Keep previous for undo
                        final previousProduct = productToEdit;
                        
                        await (db.update(db.products)..where((p) => p.id.equals(productToEdit.id))).write(
                          ProductsCompanion(
                            nameEn: drift.Value(finalEn),
                            nameHi: drift.Value(finalHi),
                            nameGu: drift.Value(finalGu),
                            price: drift.Value(price),
                            stock: drift.Value(stock),
                            unit: drift.Value(selectedUnit),
                          ),
                        );
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showUndoSnackBar(context, ref, previousProduct);
                        }
                      } else {
                        await db.into(db.products).insert(
                          ProductsCompanion.insert(
                            nameEn: finalEn,
                            nameHi: finalHi,
                            nameGu: finalGu,
                            price: drift.Value(price),
                            stock: drift.Value(stock),
                            unit: drift.Value(selectedUnit),
                          ),
                        );
                        if (context.mounted) Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(isEdit ? t('save') : t('add')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showUndoSnackBar(BuildContext context, WidgetRef ref, Product previous) {
    final lang = ref.read(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t('product_updated')),
        action: SnackBarAction(
          label: t('undo'),
          onPressed: () async {
            final db = ref.read(databaseProvider);
            await (db.update(db.products)..where((p) => p.id.equals(previous.id))).write(
              ProductsCompanion(
                nameEn: drift.Value(previous.nameEn),
                nameHi: drift.Value(previous.nameHi),
                nameGu: drift.Value(previous.nameGu),
                price: drift.Value(previous.price),
                stock: drift.Value(previous.stock),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextFormField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: t('search_product'),
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : Text(t('products'), style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          final filteredProducts = products.where((product) {
            if (_searchQuery.isEmpty) return true;
            final query = _searchQuery.toLowerCase();
            return product.nameEn.toLowerCase().contains(query) ||
                   product.nameHi.toLowerCase().contains(query) ||
                   product.nameGu.toLowerCase().contains(query);
          }).toList();

          if (products.isEmpty) {
            return Center(child: Text(t('no_products_avail'), style: GoogleFonts.outfit()));
          }

          if (filteredProducts.isEmpty) {
            return const Center(child: Text('No matching products found.', style: TextStyle(color: Colors.grey, fontSize: 16)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  onTap: () => _showEditDialog(context, ref, productToEdit: product),
                  title: Text(
                    product.localizedDisplayName(lang), 
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '₹${AppTranslations.formatCurrency(product.price, lang)} / ${product.localizedUnit(lang)}',
                    style: GoogleFonts.outfit(color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: product.stock > 5
                              ? Colors.teal.withValues(alpha: 0.1)
                              : (product.stock > 0
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${AppTranslations.formatNumber(product.stock, lang)} ${product.localizedUnit(lang)}',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: product.stock > 5
                                ? Colors.teal.shade800
                                : (product.stock > 0 ? Colors.orange.shade900 : Colors.red.shade800),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
                        onPressed: () => _showEditDialog(context, ref, productToEdit: product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product_fab',
        onPressed: () => _showEditDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
