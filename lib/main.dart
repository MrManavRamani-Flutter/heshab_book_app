// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/di/service_locator.dart';
import 'config/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/domain/providers/auth_provider.dart';
import 'features/settings/domain/providers/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── System UI ──────────────────────────────────────────────────────────────
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // ── Hive Init ──────────────────────────────────────────────────────────────
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.authBox);
  await Hive.openBox(AppConstants.settingsBox);

  // ── Dependency Injection ───────────────────────────────────────────────────
  await setupServiceLocator();

  runApp(
    const ProviderScope(
      child: HeshabBookApp(),
    ),
  );
}

class HeshabBookApp extends ConsumerStatefulWidget {
  const HeshabBookApp({super.key});

  @override
  ConsumerState<HeshabBookApp> createState() => _HeshabBookAppState();
}

class _HeshabBookAppState extends ConsumerState<HeshabBookApp> {
  @override
  void initState() {
    super.initState();
    // Initialize auth state on app start
    Future.microtask(() => ref.read(authProvider.notifier).initialize());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeModeStr = ref.watch(appThemeModeProvider);

    final themeMode = switch (themeModeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 14 Pro reference
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme, // Force premium dark for now as requested
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
