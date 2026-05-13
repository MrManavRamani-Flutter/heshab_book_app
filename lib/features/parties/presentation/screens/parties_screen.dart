// lib/features/parties/presentation/screens/parties_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/providers/party_providers.dart';
import 'party_form_screen.dart';

class PartiesScreen extends ConsumerStatefulWidget {
  const PartiesScreen({super.key});

  @override
  ConsumerState<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends ConsumerState<PartiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Customers'),
            Tab(text: 'Suppliers'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: TabBarView(
          controller: _tabController,
          children: [
            _PartyList(type: PartyType.customer),
            _PartyList(type: PartyType.supplier),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('addPartyButton'),
        heroTag: 'addPartyFab',
        onPressed: () {
          final type = _tabController.index == 0 ? PartyType.customer : PartyType.supplier;
          context.push('/add-party?type=${type.name}');
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Party'),
      ),
    );
  }
}

class _PartyList extends ConsumerWidget {
  final PartyType type;

  const _PartyList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partiesStream = type == PartyType.customer 
        ? ref.watch(shopRetailersProvider)
        : ref.watch(shopSuppliersProvider);

    return partiesStream.when(
      data: (parties) {
        if (parties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: AppColors.primary.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(
                  'No ${type == PartyType.customer ? 'customers' : 'suppliers'} yet',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: parties.length,
          itemBuilder: (context, index) {
            final party = parties[index];
            final name = (party as dynamic).name;
            final balance = (party as dynamic).currentBalance;
            final shopName = (party as dynamic).shopName;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(shopName ?? 'Individual'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: balance >= 0 ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        balance >= 0 ? 'Receivable' : 'Payable',
                        style: TextStyle(
                          fontSize: 10,
                          color: balance >= 0 ? Colors.greenAccent : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: Show details
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
    );
  }
}

