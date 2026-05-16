import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';

class HistoryScreen extends ConsumerWidget {
  final OrderType type;
  const HistoryScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = type == OrderType.purchase ? ref.watch(purchaseOrdersProvider) : ref.watch(saleOrdersProvider);
    final title = type == OrderType.purchase ? 'Wholesale History' : 'Retail History';
    final color = type == OrderType.purchase ? Colors.blueGrey : Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }

          // Sort by date descending
          final sortedOrders = List<Order>.from(orders)..sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sortedOrders.length,
            itemBuilder: (context, index) {
              final order = sortedOrders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(order.partyName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a').format(order.date)),
                  trailing: Text('₹${order.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                  children: [
                    _OrderItemsList(orderId: order.id),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _OrderItemsList extends ConsumerWidget {
  final int orderId;
  const _OrderItemsList({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(orderItemsProvider(orderId));
    final productsAsync = ref.watch(productsProvider);

    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text('No items.'));

        return productsAsync.when(
          data: (products) {
            return Container(
              color: Colors.grey.withValues(alpha: 0.05),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items.map((item) {
                  final product = products.firstWhere((p) => p.id == item.productId);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('${product.name} ${product.variety != null ? "(${product.variety})" : ""}')),
                        Text('${item.quantity} x ₹${item.price} = ₹${item.total.toStringAsFixed(2)}'),
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
