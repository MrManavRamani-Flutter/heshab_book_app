import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../l10n/app_translations.dart';
import '../providers/settings_provider.dart';

class BookScreen extends ConsumerWidget {
  final OrderType type;
  const BookScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    
    final isPurchase = type == OrderType.purchase;
    final ordersAsync = isPurchase ? ref.watch(purchaseOrdersProvider) : ref.watch(saleOrdersProvider);
    // For tabs we use translation, though this screen itself doesn't have an AppBar now (since it's in PageView).
    // Wait, the PageView children don't have AppBars, the MainScreen has the AppBar. So we can remove this AppBar.
    // Actually, BookScreen can just be the body without Scaffold, OR a Scaffold without AppBar.
    final color = Theme.of(context).primaryColor;

    return Scaffold(
      // Removed local AppBar as MainScreen has it
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 80, color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(t('no_entries'), style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)),
                ],
              ),
            );
          }

          // Sort by date descending
          final sortedOrders = List<Order>.from(orders)..sort((a, b) => b.date.compareTo(a.date));
          final totalBookAmount = sortedOrders.fold<double>(0, (sum, o) => sum + o.totalAmount);

          return Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t('total_book_balance'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    Text('₹${AppTranslations.formatCurrency(totalBookAmount, lang)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: sortedOrders.length,
                  itemBuilder: (context, index) {
                    final order = sortedOrders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3))),
                      child: ExpansionTile(
                        shape: const Border(),
                        title: _PartyNameWidget(partyId: order.partyId),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(AppTranslations.formatStringNumber(DateFormat('dd MMM yyyy, hh:mm a').format(order.date), lang), style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                        ),
                        trailing: Text('₹${AppTranslations.formatCurrency(order.totalAmount, lang)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                        children: [
                          _OrderItemsList(orderId: order.id, t: t),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/order/${isPurchase ? 'purchase' : 'sale'}'),
        backgroundColor: color,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(t('new_entry'), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _PartyNameWidget extends ConsumerWidget {
  final int partyId;
  const _PartyNameWidget({required this.partyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    final partyAsync = ref.watch(partyByIdProvider(partyId));
    return partyAsync.when(
      data: (party) => Text(party.localizedName(lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      loading: () => const Text('...'),
      error: (e, s) => const Text('Error'),
    );
  }
}

class _OrderItemsList extends ConsumerWidget {
  final int orderId;
  final String Function(String) t;
  const _OrderItemsList({required this.orderId, required this.t});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(orderItemsProvider(orderId));
    final productsAsync = ref.watch(productsProvider);

    final lang = ref.watch(localeProvider);
    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) return Padding(padding: const EdgeInsets.all(16), child: Text(t('no_items')));

        return productsAsync.when(
          data: (products) {
            return Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items.map((item) {
                  final product = products.firstWhere((p) => p.id == item.productId);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(product.localizedDisplayName(lang), style: const TextStyle(fontWeight: FontWeight.w500))),
                        Text('${AppTranslations.formatNumber(item.quantity, lang)} x ₹${AppTranslations.formatCurrency(item.price, lang)} = ₹${AppTranslations.formatCurrency(item.total, lang)}', style: TextStyle(color: Colors.grey.shade700)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
          error: (err, stack) => Text('Error: $err'),
        );
      },
      loading: () => const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
