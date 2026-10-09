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
import '../utils/action_helper.dart';

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

  void _showQuickAccountPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    List<Order> orders,
    double totalPending,
    String Function(String) t,
    String lang,
  ) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    String selectedMode = 'mode_cash';

    final paymentModes = ['mode_cash', 'mode_upi', 'mode_cheque', 'mode_bank'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t('quick_payment'), style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${t('pending_amount')}: ₹${AppTranslations.formatCurrency(totalPending, lang)}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: t('enter_amount'),
                        prefixIcon: const Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return t('err_required');
                        final amount = double.tryParse(val);
                        if (amount == null || amount <= 0) return t('invalid_amount');
                        if (amount > totalPending) return '${t('invalid_amount')} (Max: ₹${AppTranslations.formatCurrency(totalPending, lang)})';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(t('payment_mode'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: paymentModes.map((modeKey) {
                        final isSelected = selectedMode == modeKey;
                        return ChoiceChip(
                          label: Text(t(modeKey), style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          selected: isSelected,
                          selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          onSelected: (val) {
                            if (val) setDialogState(() => selectedMode = modeKey);
                          },
                        );
                      }).toList(),
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

                      // Allocate payment across unpaid orders (oldest first - FIFO)
                      final unpaidOrders = orders
                          .where((o) => o.totalAmount > o.paidAmount)
                          .toList()
                        ..sort((a, b) => a.date.compareTo(b.date));

                      double remainingToAllocate = paymentAmount;

                      await db.transaction(() async {
                        for (final order in unpaidOrders) {
                          if (remainingToAllocate <= 0) break;
                          final orderPending = order.totalAmount - order.paidAmount;
                          final alloc = remainingToAllocate > orderPending ? orderPending : remainingToAllocate;

                          // 1. Insert Payment Record
                          await db.into(db.payments).insert(
                            PaymentsCompanion.insert(
                              orderId: order.id,
                              amount: alloc,
                              date: DateTime.now(),
                            ),
                          );

                          // 2. Update Order
                          final newPaidAmount = order.paidAmount + alloc;
                          await (db.update(db.orders)..where((o) => o.id.equals(order.id))).write(
                            OrdersCompanion(paidAmount: drift.Value(newPaidAmount)),
                          );

                          // 3. Cancel reminder if fully settled
                          if (newPaidAmount >= order.totalAmount) {
                            await NotificationHelper.cancelReminder(order.id);
                          }

                          remainingToAllocate -= alloc;
                        }
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${t('quick_payment')}: ₹${AppTranslations.formatCurrency(paymentAmount, lang)} ✓')),
                        );
                      }
                    }
                  },
                  child: Text(t('save')),
                ),
              ],
            );
          },
        );
      },
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(party.localizedName(lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            if (party.phone != null && party.phone!.isNotEmpty)
              Text(party.phone!, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          if (party.phone != null && party.phone!.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              tooltip: t('call'),
              onPressed: () => ActionHelper.makePhoneCall(party.phone!),
            ),
          ],
        ],
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
                    // Quick Action Buttons
                    if (pendingAmount > 0 || (party.phone != null && party.phone!.isNotEmpty)) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (party.phone != null && party.phone!.isNotEmpty && pendingAmount > 0) ...[
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => ActionHelper.sendWhatsAppReminder(
                                  phoneNumber: party.phone!,
                                  partyName: party.localizedName(lang),
                                  pendingAmount: pendingAmount,
                                  lang: lang,
                                ),
                                icon: const Icon(Icons.chat, color: Colors.green, size: 18),
                                label: Text(
                                  t('send_reminder_whatsapp'),
                                  style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.green),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (pendingAmount > 0) ...[
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _showQuickAccountPaymentDialog(context, ref, orders, pendingAmount, t, lang),
                                icon: const Icon(Icons.currency_rupee, size: 18),
                                label: Text(
                                  t('quick_payment'),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
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
