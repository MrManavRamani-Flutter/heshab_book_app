import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/settings_provider.dart';
import '../l10n/app_translations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNext(BuildContext context) {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutQuart);
    } else {
      _finishOnboarding(context);
    }
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('has_seen_onboarding', true);
    if (context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    String t(String key) => AppTranslations.translate(key, lang);
    final color = Theme.of(context).primaryColor;

    final List<Map<String, dynamic>> pages = [
      {
        'icon': Icons.menu_book_rounded,
        'title': t('onboard_title_1'),
        'desc': t('onboard_desc_1'),
        'gradient': [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'title': t('onboard_title_2'),
        'desc': t('onboard_desc_2'),
        'gradient': [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
      },
      {
        'icon': Icons.language_rounded,
        'title': t('onboard_title_3'),
        'desc': t('onboard_desc_3'),
        'gradient': [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              color.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => _finishOnboarding(context),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
                    child: Text('Skip', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: pages[index]['gradient'][0],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(pages[index]['icon'], size: 100, color: color),
                          ),
                          const SizedBox(height: 60),
                          Text(
                            pages[index]['title'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            pages[index]['desc'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              color: Colors.grey.shade600,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 10,
                          width: _currentPage == index ? 30 : 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? color : color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _onNext(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 8,
                        shadowColor: color.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        _currentPage == pages.length - 1 ? t('get_started') : t('next'),
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

