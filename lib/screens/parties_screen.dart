import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:go_router/go_router.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';
import '../l10n/app_translations.dart';
import '../providers/settings_provider.dart';
import '../utils/translation_helper.dart';
import '../utils/action_helper.dart';

class PartiesScreen extends ConsumerStatefulWidget {
  const PartiesScreen({super.key});

  @override
  ConsumerState<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends ConsumerState<PartiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showPartyDialog(BuildContext context, WidgetRef ref, OrderType type, {Party? partyToEdit}) {
    final lang = ref.read(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final formKey = GlobalKey<FormState>();
    
    // Controllers for all languages
    final nameEnController = TextEditingController(text: partyToEdit?.nameEn ?? '');
    final nameHiController = TextEditingController(text: partyToEdit?.nameHi ?? '');
    final nameGuController = TextEditingController(text: partyToEdit?.nameGu ?? '');
    
    // Main display controller (for Auto mode)
    final mainNameController = TextEditingController(text: partyToEdit?.localizedName(lang) ?? '');
    final firmNameController = TextEditingController(text: partyToEdit?.firmName ?? '');
    final phoneController = TextEditingController(text: partyToEdit?.phone ?? '');
    final addressController = TextEditingController(text: partyToEdit?.address ?? '');
    final gstinController = TextEditingController(text: partyToEdit?.gstin ?? '');
    
    final isEdit = partyToEdit != null;
    bool isManual = false;

    void deleteParty(BuildContext dialogContext) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(t('delete')),
          content: Text('${t('delete_confirm')}\n\n${t('delete_party_warning')}'),
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

      if (confirm == true && partyToEdit != null) {
        final partyId = partyToEdit.id;
        final db = ref.read(databaseProvider);
        await db.transaction(() async {
          final partyOrders = await (db.select(db.orders)..where((o) => o.partyId.equals(partyId))).get();
          for (final o in partyOrders) {
            await (db.delete(db.payments)..where((p) => p.orderId.equals(o.id))).go();
            await (db.delete(db.orderItems)..where((oi) => oi.orderId.equals(o.id))).go();
          }
          await (db.delete(db.orders)..where((o) => o.partyId.equals(partyId))).go();
          await (db.delete(db.parties)..where((p) => p.id.equals(partyId))).go();
        });
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('party_deleted'))));
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEdit ? t('edit_party') : t('add_new_party')),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Toggle between Auto and Manual
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
                            prefixIcon: const Icon(Icons.person),
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
                      TextFormField(
                        controller: firmNameController,
                        decoration: InputDecoration(
                          labelText: t('firm_name'),
                          prefixIcon: const Icon(Icons.store),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(labelText: t('phone_optional'), prefixIcon: const Icon(Icons.phone)),
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(labelText: t('address'), prefixIcon: const Icon(Icons.location_on)),
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: gstinController,
                        decoration: InputDecoration(
                          labelText: t('gstin'),
                          prefixIcon: const Icon(Icons.receipt_long),
                        ),
                        textCapitalization: TextCapitalization.characters,
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
                    onPressed: () => deleteParty(context),
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

                      final phoneVal = phoneController.text.trim().isEmpty ? null : phoneController.text.trim();
                      final firmVal = firmNameController.text.trim().isEmpty ? null : firmNameController.text.trim();
                      final addrVal = addressController.text.trim().isEmpty ? null : addressController.text.trim();
                      final gstinVal = gstinController.text.trim().isEmpty ? null : gstinController.text.trim().toUpperCase();

                      if (isEdit) {
                        await (db.update(db.parties)..where((p) => p.id.equals(partyToEdit.id))).write(
                          PartiesCompanion(
                            nameEn: drift.Value(finalEn),
                            nameHi: drift.Value(finalHi),
                            nameGu: drift.Value(finalGu),
                            phone: drift.Value(phoneVal),
                            firmName: drift.Value(firmVal),
                            address: drift.Value(addrVal),
                            gstin: drift.Value(gstinVal),
                          ),
                        );
                      } else {
                        await db.into(db.parties).insert(
                          PartiesCompanion.insert(
                            nameEn: finalEn,
                            nameHi: finalHi,
                            nameGu: finalGu,
                            type: type,
                            phone: drift.Value(phoneVal),
                            firmName: drift.Value(firmVal),
                            address: drift.Value(addrVal),
                            gstin: drift.Value(gstinVal),
                          ),
                        );
                      }
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Text(isEdit ? t('save') : t('add')),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextFormField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: t('search_party'),
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : Text(t('parties'), style: const TextStyle(fontWeight: FontWeight.bold)),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: t('wholesalers_tab')),
            Tab(text: t('retailers_tab')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PartyList(
            type: OrderType.purchase,
            searchQuery: _searchQuery,
            onEdit: (ref, party) => _showPartyDialog(context, ref, OrderType.purchase, partyToEdit: party),
          ),
          _PartyList(
            type: OrderType.sale,
            searchQuery: _searchQuery,
            onEdit: (ref, party) => _showPartyDialog(context, ref, OrderType.sale, partyToEdit: party),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final activeType = _tabController.index == 0 ? OrderType.purchase : OrderType.sale;
          _showPartyDialog(context, ref, activeType);
        },
        backgroundColor: AppTheme.khataRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: Text(t('add_new_party')),
      ),
    );
  }
}

class _PartyList extends ConsumerStatefulWidget {
  final OrderType type;
  final String searchQuery;
  final void Function(WidgetRef ref, Party party) onEdit;

  const _PartyList({required this.type, required this.searchQuery, required this.onEdit});

  @override
  ConsumerState<_PartyList> createState() => _PartyListState();
}

class _PartyListState extends ConsumerState<_PartyList> {
  bool _pendingOnly = false;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final partiesAsync = ref.watch(partiesProvider(widget.type));
    final allOrdersAsync = ref.watch(allOrdersProvider);
    final allOrders = allOrdersAsync.value ?? [];

    double getPartyPending(int partyId) {
      final pOrders = allOrders.where((o) => o.partyId == partyId);
      return pOrders.fold<double>(0.0, (sum, o) => sum + (o.totalAmount - o.paidAmount));
    }

    return partiesAsync.when(
      data: (parties) {
        // Filter parties across all three language columns, phone, firm, address, gstin
        final filteredParties = parties.where((p) {
          if (_pendingOnly && getPartyPending(p.id) <= 0.001) return false;
          if (widget.searchQuery.isEmpty) return true;
          final query = widget.searchQuery.toLowerCase();
          return p.nameEn.toLowerCase().contains(query) ||
                 p.nameHi.toLowerCase().contains(query) ||
                 p.nameGu.toLowerCase().contains(query) ||
                 (p.firmName?.toLowerCase().contains(query) ?? false) ||
                 (p.phone?.toLowerCase().contains(query) ?? false) ||
                 (p.address?.toLowerCase().contains(query) ?? false) ||
                 (p.gstin?.toLowerCase().contains(query) ?? false);
        }).toList();

        if (parties.isEmpty) {
          return Center(child: Text(t('no_parties'), style: const TextStyle(color: Colors.grey, fontSize: 16)));
        }

        return Column(
          children: [
            // Quick Filter Chips Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text(t('filter_all'), style: const TextStyle(fontSize: 12)),
                    selected: !_pendingOnly,
                    onSelected: (val) => setState(() => _pendingOnly = false),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(
                      '${t('filter_pending_only')} (₹)',
                      style: TextStyle(
                        fontSize: 12,
                        color: _pendingOnly ? Colors.red.shade900 : null,
                        fontWeight: _pendingOnly ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: _pendingOnly,
                    selectedColor: Colors.red.shade100,
                    onSelected: (val) => setState(() => _pendingOnly = true),
                  ),
                  const Spacer(),
                  Text(
                    '${filteredParties.length} ${t('parties')}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            
            Expanded(
              child: filteredParties.isEmpty
                  ? Center(
                      child: Text(
                        _pendingOnly ? t('no_pending_balance') : 'No matching parties found.',
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80, top: 8),
                      itemCount: filteredParties.length,
                      itemBuilder: (context, index) {
                        final party = filteredParties[index];
                        final pending = getPartyPending(party.id);
                        final partyName = party.localizedName(lang).trim();
                        final initial = partyName.isNotEmpty ? partyName.characters.first.toUpperCase() : '?';

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          child: InkWell(
                            onTap: () {
                              context.push('/party-details/${party.id}');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppTheme.khataRed.withValues(alpha: 0.1),
                                    radius: 20,
                                    child: Text(
                                      initial,
                                      style: const TextStyle(color: AppTheme.khataRed, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          partyName, 
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          party.displaySubtitle(t('no_phone')), 
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: pending > 0.001
                                              ? Colors.red.withValues(alpha: 0.12)
                                              : Colors.green.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          pending > 0.001
                                              ? '₹${AppTranslations.formatCurrency(pending, lang)}'
                                              : t('settled'),
                                          style: TextStyle(
                                            color: pending > 0.001 ? Colors.red.shade800 : Colors.green.shade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (party.phone != null && party.phone!.isNotEmpty)
                                            IconButton(
                                              icon: const Icon(Icons.call, color: Colors.green, size: 20),
                                              tooltip: t('call'),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => ActionHelper.makePhoneCall(party.phone!),
                                            ),
                                          const SizedBox(width: 12),
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () => widget.onEdit(ref, party),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
    );
  }
}
