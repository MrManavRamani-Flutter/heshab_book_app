import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(purchaseOrdersProvider);
    final salesAsync = ref.watch(saleOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kapad Shop Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory),
            onPressed: () => context.push('/products'),
            tooltip: 'Products',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDashboardCard(
              context: context,
              title: 'Wholesale (Purchases)',
              subtitle: 'Manage orders from Max Hall Vepari',
              icon: Icons.storefront,
              color: Colors.blueGrey,
              asyncValue: purchasesAsync,
              onTapHistory: () => context.push('/history/purchase'),
              onTapNew: () => context.push('/order/purchase'),
            ),
            const SizedBox(height: 24),
            _buildDashboardCard(
              context: context,
              title: 'Retail (Sales)',
              subtitle: 'Manage orders given to Retailers',
              icon: Icons.people,
              color: Colors.teal,
              asyncValue: salesAsync,
              onTapHistory: () => context.push('/history/sale'),
              onTapNew: () => context.push('/order/sale'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required AsyncValue<List<Order>> asyncValue,
    required VoidCallback onTapHistory,
    required VoidCallback onTapNew,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  radius: 30,
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            asyncValue.when(
              data: (orders) {
                final total = orders.fold<double>(0.0, (sum, o) => sum + o.totalAmount);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol(context, 'Total Orders', orders.length.toString()),
                    _buildStatCol(context, 'Total Amount', '₹${total.toStringAsFixed(2)}'),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTapHistory,
                    icon: const Icon(Icons.history),
                    label: const Text('History'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTapNew,
                    icon: const Icon(Icons.add),
                    label: const Text('New Order'),
                    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
