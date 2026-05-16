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
    final phoneController = TextEditingController(text: partyToEdit?.phone ?? '');
    
    final isEdit = partyToEdit != null;
    bool isManual = false;

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
                            helperText: t('auto_translate_hint'), // I should add this key too, or just a generic hint
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
                        controller: phoneController,
                        decoration: InputDecoration(labelText: t('phone_optional'), prefixIcon: const Icon(Icons.phone)),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
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

                      if (isEdit) {
                        await (db.update(db.parties)..where((p) => p.id.equals(partyToEdit.id))).write(
                          PartiesCompanion(
                            nameEn: drift.Value(finalEn),
                            nameHi: drift.Value(finalHi),
                            nameGu: drift.Value(finalGu),
                            phone: drift.Value(phoneController.text.trim().isEmpty ? null : phoneController.text.trim()),
                          ),
                        );
                      } else {
                        await db.into(db.parties).insert(
                          PartiesCompanion.insert(
                            nameEn: finalEn,
                            nameHi: finalHi,
                            nameGu: finalGu,
                            type: type,
                            phone: drift.Value(phoneController.text.trim().isEmpty ? null : phoneController.text.trim()),
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

class _PartyList extends ConsumerWidget {
  final OrderType type;
  final String searchQuery;
  final void Function(WidgetRef ref, Party party) onEdit;

  const _PartyList({required this.type, required this.searchQuery, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final partiesAsync = ref.watch(partiesProvider(type));

    return partiesAsync.when(
      data: (parties) {
        // Filter parties across all three language columns
        final filteredParties = parties.where((p) {
          if (searchQuery.isEmpty) return true;
          final query = searchQuery.toLowerCase();
          return p.nameEn.toLowerCase().contains(query) ||
                 p.nameHi.toLowerCase().contains(query) ||
                 p.nameGu.toLowerCase().contains(query) ||
                 (p.phone?.toLowerCase().contains(query) ?? false);
        }).toList();

        if (parties.isEmpty) {
          return Center(child: Text(t('no_parties'), style: const TextStyle(color: Colors.grey, fontSize: 16)));
        }

        if (filteredParties.isEmpty) {
          return const Center(child: Text('No matching parties found.', style: TextStyle(color: Colors.grey, fontSize: 16)));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80, top: 8),
          itemCount: filteredParties.length,
          itemBuilder: (context, index) {
            final party = filteredParties[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: InkWell(
                onTap: () {
                  context.push('/party-details/${party.id}');
                },
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.khataRed.withValues(alpha: 0.1),
                    radius: 20,
                    child: Text(
                      party.localizedName(lang).characters.first.toUpperCase(),
                      style: const TextStyle(color: AppTheme.khataRed, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(party.localizedName(lang), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(
                    party.phone != null && party.phone!.isNotEmpty 
                        ? party.phone! 
                        : t('no_phone'), 
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
                    onPressed: () => onEdit(ref, party),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
