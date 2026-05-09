// lib/config/di/service_locator.dart

import 'package:get_it/get_it.dart';
import '../../database/app_database.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── Database ───────────────────────────────────────────────────────────────
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // ── DAOs (registered after DB) ────────────────────────────────────────────
  // These will be added as each phase is built.
  // Example pattern:
  //   sl.registerSingleton<UserDao>(sl<AppDatabase>().userDao);
  //   sl.registerSingleton<ProductDao>(sl<AppDatabase>().productDao);

  // ── Repositories ──────────────────────────────────────────────────────────
  // Will be registered here as each feature is built.

  // ── Services ──────────────────────────────────────────────────────────────
  // Will be registered here as needed.
}
