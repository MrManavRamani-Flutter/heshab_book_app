import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_translations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showInfo(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message, style: GoogleFonts.outfit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final colorStr = ref.watch(themeColorProvider);
    final modeStr = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(notificationEnabledProvider);

    final availableColors = [
      {'name': 'Khata Red', 'val': '0xFF8B0000'},
      {'name': 'Indigo', 'val': '0xFF3F51B5'},
      {'name': 'Teal', 'val': '0xFF009688'},
      {'name': 'Deep Purple', 'val': '0xFF673AB7'},
      {'name': 'Blue Grey', 'val': '0xFF607D8B'},
      {'name': 'Royal Blue', 'val': '0xFF1A237E'},
      {'name': 'Emerald', 'val': '0xFF2E7D32'},
      {'name': 'Amber', 'val': '0xFFFFA000'},
      {'name': 'Rose', 'val': '0xFFC2185B'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t('settings'), style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, t('language'), t('info_language')),
          Card(
            child: RadioGroup<String>(
              groupValue: lang,
              onChanged: (val) {
                if (val != null) ref.read(localeProvider.notifier).setLocale(val);
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('English', style: GoogleFonts.outfit()),
                    value: 'en',
                  ),
                  RadioListTile<String>(
                    title: Text('हिंदी (Hindi)', style: GoogleFonts.outfit()),
                    value: 'hi',
                  ),
                  RadioListTile<String>(
                    title: Text('ગુજરાતી (Gujarati)', style: GoogleFonts.outfit()),
                    value: 'gu',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle(context, 'App Theme Mode', t('info_theme_mode')),
          Card(
            child: RadioGroup<String>(
              groupValue: modeStr,
              onChanged: (val) {
                if (val != null) ref.read(themeModeProvider.notifier).setThemeMode(val);
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('System Default', style: GoogleFonts.outfit()),
                    value: 'system',
                  ),
                  RadioListTile<String>(
                    title: Text('Light Mode', style: GoogleFonts.outfit()),
                    value: 'light',
                  ),
                  RadioListTile<String>(
                    title: Text('Dark Mode', style: GoogleFonts.outfit()),
                    value: 'dark',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'App Color', t('info_theme_color')),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: availableColors.map((colorMap) {
                  final hex = colorMap['val']!;
                  final colorObj = Color(int.parse(hex));
                  final isSelected = colorStr == hex;
                  final onSurface = Theme.of(context).colorScheme.onSurface;
                  return GestureDetector(
                    onTap: () {
                      ref.read(themeColorProvider.notifier).setThemeColor(hex);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorObj,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: onSurface, width: 3) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, t('notifications'), t('info_notifications')),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: SwitchListTile(
              title: Text(t('enable_notifications'), style: GoogleFonts.outfit()),
              subtitle: Text(notificationsEnabled ? 'Active' : 'Disabled', style: GoogleFonts.outfit(fontSize: 12)),
              value: notificationsEnabled,
              activeTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              activeThumbColor: Theme.of(context).primaryColor,
              onChanged: (val) {
                ref.read(notificationEnabledProvider.notifier).setNotificationsEnabled(val);
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, size: 20, color: Colors.grey.shade600),
            onPressed: () => _showInfo(context, title, info),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

