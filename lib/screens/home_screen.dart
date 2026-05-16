import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../l10n/app_translations.dart';
import '../providers/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(purchaseOrdersProvider);
    final salesAsync = ref.watch(saleOrdersProvider);
    final productsAsync = ref.watch(productsProvider);
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Store Stock Summary Card
            _buildStockSummaryCard(context, productsAsync, t, lang),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t('overview'), style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  IconButton(
                    icon: Icon(Icons.info_outline, size: 20, color: Colors.grey.shade600),
                    onPressed: () => _showHelpDialog(context, t('overview'), t('info_dashboard')),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Overview Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMiniStatCard(
                      context: context,
                      title: t('wholesale_purchases'),
                      icon: Icons.storefront,
                      color: Colors.blueGrey,
                      asyncValue: purchasesAsync,
                      t: t,
                      lang: lang,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStatCard(
                      context: context,
                      title: t('retail_sales'),
                      icon: Icons.store_mall_directory,
                      color: Colors.teal,
                      asyncValue: salesAsync,
                      t: t,
                      lang: lang,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSummaryCard(BuildContext context, AsyncValue<List<Product>> productsAsync, String Function(String) t, String lang) {
    final color = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/products'),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0), 
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(t('store_stock'), style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _showHelpDialog(context, t('store_stock'), t('info_stock')),
                                child: Icon(Icons.info_outline, size: 18, color: Colors.white.withValues(alpha: 0.7)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(t('manage_products'), style: GoogleFonts.outfit(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 30),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: productsAsync.when(
                    data: (products) {
                      final totalStock = products.fold<int>(0, (sum, p) => sum + p.stock);
                      final varieties = products.length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(context, t('total_stock'), AppTranslations.formatNumber(totalStock, lang), Colors.white),
                          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
                          _buildStatItem(context, t('varieties'), AppTranslations.formatNumber(varieties, lang), Colors.white),
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                    error: (err, stack) => Text('Error', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required AsyncValue<List<Order>> asyncValue,
    required String Function(String) t,
    required String lang,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            asyncValue.when(
              data: (orders) {
                final total = orders.fold<double>(0.0, (sum, o) => sum + o.totalAmount);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppTranslations.formatNumber(orders.length, lang)} ${t('bills')}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('₹${AppTranslations.formatCurrency(total, lang)}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                );
              },
              loading: () => const SizedBox(height: 40, child: CircularProgressIndicator()),
              error: (e, s) => const Text('Error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500)),
      ],
    );
  }
}
