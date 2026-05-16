// lib/features/dashboard/presentation/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../billing/domain/providers/bill_providers.dart';
import '../../../shops/domain/providers/shop_providers.dart';
import '../../domain/providers/dashboard_providers.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final recentBillsAsync = ref.watch(recentTransactionsProvider);
    final activeShop = ref.watch(activeShopProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.surfaceGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header Section ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Heshab Book',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ).animate().fadeIn().slideX(),
                          Text(
                            activeShop?.shopName ?? 'My Business',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                          ).animate().fadeIn(delay: 100.ms).slideX(),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push(RouteNames.profile),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: const CircleAvatar(
                            backgroundColor: AppColors.surfaceLight,
                            child: Icon(Icons.person_outline, color: Colors.white),
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).scale(),
                    ],
                  ),
                ),
              ),

              // ── KPI Grid ───────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: statsAsync.when(
                  data: (stats) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.w,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 1.3,
                      children: [
                        _buildStatCard(
                          context,
                          title: 'Today\'s Sales',
                          value: '₹${NumberFormat('#,##,###').format(stats.todaySalesAmount)}',
                          icon: Icons.trending_up,
                          color: AppColors.primary,
                        ),
                        _buildStatCard(
                          context,
                          title: 'Pending Recv.',
                          value: '₹${NumberFormat('#,##,###').format(stats.pendingReceivables)}',
                          icon: Icons.account_balance_wallet,
                          color: AppColors.warning,
                        ),
                        _buildStatCard(
                          context,
                          title: 'Stock Value',
                          value: '₹${NumberFormat('#,##,###').format(stats.stockValuation)}',
                          icon: Icons.inventory_2,
                          color: AppColors.secondary,
                        ),
                        _buildStatCard(
                          context,
                          title: 'Low Stock',
                          value: '${stats.lowStockCount} Items',
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.danger,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).scale(),
                  loading: () => SizedBox(
                    height: 200.h,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, s) => Center(child: Text('Error: $e')),
                ),
              ),

              // ── Activity Chart ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: GlassCard(
                    height: 240.h,
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Revenue Trends',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+12.5%',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 140.h,
                          child: _buildChart(),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                ),
              ),

              // ── Recent Transactions ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
              ),

              recentBillsAsync.when(
                data: (bills) => bills.isEmpty 
                  ? const SliverToBoxAdapter(
                      child: Center(child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('No transactions yet'),
                      )),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final bill = bills[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                            child: GlassCard(
                              padding: EdgeInsets.all(12.w),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: bill.billType == 'sales'
                                        ? AppColors.accent.withValues(alpha: 0.1)
                                        : AppColors.danger.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    bill.billType == 'sales'
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    color: bill.billType == 'sales'
                                        ? AppColors.accent
                                        : AppColors.danger,
                                    size: 20.w,
                                  ),
                                ),
                                title: Text(
                                  bill.billNumber,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  DateFormat('dd MMM, hh:mm a').format(bill.billDate),
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                trailing: Text(
                                  '₹${bill.totalAmount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: bill.billType == 'sales'
                                        ? AppColors.accent
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: (500 + (index * 50)).ms).slideX();
                        },
                        childCount: bills.length,
                      ),
                    ),
                loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                error: (e, s) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
              ),
              
              SliverPadding(padding: EdgeInsets.only(bottom: 100.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22.w),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 2),
              const FlSpot(1, 3.5),
              const FlSpot(2, 2.5),
              const FlSpot(3, 4),
              const FlSpot(4, 3),
              const FlSpot(5, 5),
              const FlSpot(6, 4.5),
            ],
            isCurved: true,
            gradient: AppColors.primaryGradient,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.primary.withValues(alpha: 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
