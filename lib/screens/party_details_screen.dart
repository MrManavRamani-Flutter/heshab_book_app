import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:google_fonts/google_fonts.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../l10n/app_translations.dart';
import '../providers/settings_provider.dart';
import '../utils/notification_helper.dart';

class PartyDetailsScreen extends ConsumerWidget {
  final Party party;
  const PartyDetailsScreen({super.key, required this.party});

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

  void _showAddPaymentDialog(BuildContext context, WidgetRef ref, Order order, String Function(String) t, String lang) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final pendingAmount = order.totalAmount - order.paidAmount;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t('add_payment')),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${t('pending_amount')}: ₹${AppTranslations.formatCurrency(pendingAmount, lang)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: t('enter_amount'), 
                    prefixIcon: const Icon(Icons.currency_rupee),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return t('err_required');
                    final amount = double.tryParse(val);
                    if (amount == null || amount <= 0 || amount > pendingAmount) return t('invalid_amount');
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(t('cancel'))),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final db = ref.read(databaseProvider);
                  final paymentAmount = double.parse(amountController.text.trim());
                  final newPaidAmount = order.paidAmount + paymentAmount;
                  
                  await db.transaction(() async {
                    // 1. Insert Payment Record
                    await db.into(db.payments).insert(
                      PaymentsCompanion.insert(
                        orderId: order.id,
                        amount: paymentAmount,
                        date: DateTime.now(),
                      ),
                    );
                    
                    // 2. Update Order Paid Amount
                    await (db.update(db.orders)..where((o) => o.id.equals(order.id))).write(
                      OrdersCompanion(paidAmount: drift.Value(newPaidAmount)),
                    );

                    // 3. Cancel reminder if fully paid
                    if (newPaidAmount >= order.totalAmount) {
                      await NotificationHelper.cancelReminder(order.id);
                    }
                  });
                  
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(t('save')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final ordersAsync = ref.watch(ordersByPartyProvider(party.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(party.localizedName(lang), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ordersAsync.when(
        data: (orders) {
          final totalTransactions = orders.length;
          final totalAmount = orders.fold<double>(0, (sum, o) => sum + o.totalAmount);
          final totalReceived = orders.fold<double>(0, (sum, o) => sum + o.paidAmount);
          final pendingAmount = totalAmount - totalReceived;

          // Sort by date descending
          final sortedOrders = List<Order>.from(orders)..sort((a, b) => b.date.compareTo(a.date));

          return Column(
            children: [
              // Summary Cards
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            title: t('pending_amount'),
                            amount: pendingAmount,
                            color: Colors.red.shade700,
                            icon: Icons.account_balance_wallet,
                            lang: lang,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title: t('received_amount'),
                            amount: totalReceived,
                            color: Colors.green.shade700,
                            icon: Icons.check_circle,
                            lang: lang,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t('total_transactions'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                        Text(AppTranslations.formatNumber(totalTransactions, lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t('bill_history'), style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    IconButton(
                      icon: const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                      onPressed: () => _showHelpDialog(context, t('bill_history'), t('info_ledger')),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Orders List
              Expanded(
                child: orders.isEmpty 
                  ? Center(child: Text(t('no_orders_for_party')))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: sortedOrders.length,
                      itemBuilder: (context, index) {
                        final order = sortedOrders[index];
                        final isPaid = order.totalAmount <= order.paidAmount;
                        final isOverdue = order.reminderEnabled && !isPaid && DateTime.now().difference(order.date).inDays >= order.reminderDays;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), 
                            side: BorderSide(color: isOverdue ? Colors.red.shade400 : Colors.grey.shade200, width: isOverdue ? 2 : 1)
                          ),
                          child: ExpansionTile(
                            shape: const Border(),
                            title: Row(
                              children: [
                                Text('${t('bills')} #${AppTranslations.formatNumber(order.id, lang)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                if (isOverdue) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                                    child: Text(t('overdue'), style: TextStyle(color: Colors.red.shade900, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ]
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppTranslations.formatStringNumber(DateFormat('dd MMM yyyy, hh:mm a').format(order.date), lang), style: TextStyle(color: Colors.grey.shade600)),
                                  if (isOverdue)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.warning, size: 14, color: Colors.red.shade700),
                                          const SizedBox(width: 4),
                                          Expanded(child: Text('${t('overdue_alert')} ${AppTranslations.formatNumber(order.reminderDays, lang)} ${t('days')}!', style: TextStyle(color: Colors.red.shade700, fontSize: 11, fontWeight: FontWeight.w500))),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹${AppTranslations.formatCurrency(order.totalAmount, lang)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                                if (!isPaid) 
                                  Text('${t('pending_amount')}: ₹${AppTranslations.formatCurrency(order.totalAmount - order.paidAmount, lang)}', style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
                                if (isPaid)
                                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                              ],
                            ),
                            children: [
                              _OrderItemsList(orderId: order.id, t: t),
                              _PaymentHistoryList(order: order, t: t, lang: lang),
                              if (!isPaid)
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showAddPaymentDialog(context, ref, order, t, lang),
                                      icon: const Icon(Icons.payment, size: 18),
                                      label: Text(t('add_payment')),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.green.shade700,
                                        side: BorderSide(color: Colors.green.shade700),
                                      ),
                                    ),
                                  ),
                                ),
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
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final String lang;

  const _SummaryCard({required this.title, required this.amount, required this.color, required this.icon, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 12),
          Text('₹${AppTranslations.formatCurrency(amount, lang)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
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
        if (items.isEmpty) return const SizedBox.shrink();

        return productsAsync.when(
          data: (products) {
            return Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items.map((item) {
                  final product = products.firstWhere((p) => p.id == item.productId);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
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
          loading: () => const SizedBox.shrink(),
          error: (err, stack) => Text('Error: $err'),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

class _PaymentHistoryList extends ConsumerWidget {
  final Order order;
  final String Function(String) t;
  final String lang;
  
  const _PaymentHistoryList({required this.order, required this.t, required this.lang});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsByOrderProvider(order.id));

    return paymentsAsync.when(
      data: (payments) {
        if (payments.isEmpty) return const SizedBox.shrink();
        
        return Container(
          color: Colors.green.shade50.withValues(alpha: 0.3),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t('payment_history'), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800)),
              const SizedBox(height: 8),
              ...payments.map((payment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+ ₹${AppTranslations.formatCurrency(payment.amount, lang)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                          Text(AppTranslations.formatStringNumber(DateFormat('dd MMM, hh:mm a').format(payment.date), lang), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        tooltip: t('delete_payment'),
                        onPressed: () async {
                          // Allow deleting a payment (mistake reverting)
                          final db = ref.read(databaseProvider);
                          final newPaidAmount = order.paidAmount - payment.amount;
                          await db.transaction(() async {
                            await (db.delete(db.payments)..where((p) => p.id.equals(payment.id))).go();
                            await (db.update(db.orders)..where((o) => o.id.equals(order.id))).write(
                              OrdersCompanion(paidAmount: drift.Value(newPaidAmount)),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
