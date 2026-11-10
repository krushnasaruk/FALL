import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/database/database_provider.dart';
import 'data/database/database_seeder.dart';
import 'routing/app_router.dart';
import 'services/notification_service.dart';
import 'services/widget_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inspect onboarding status prior to constructing router so first-time users
  // receive a calm welcome while returning users land directly on Home.
  String initialRoute = '/dashboard';
  try {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_completed_v1') ?? false;
    if (!onboardingDone) {
      initialRoute = '/onboarding';
    }
  } catch (_) {}

  // Create Riverpod container for app startup initialization
  final container = ProviderContainer(
    overrides: [
      initialRouteProvider.overrideWithValue(initialRoute),
    ],
  );

  // 1. Initialize Local Notification Service
  final notifService = container.read(notificationServiceProvider);
  await notifService.initialize();

  // 2. Ensure database starts clean without dummy seed records (one-time v3 cleanup)
  final db = container.read(databaseProvider);
  await DatabaseSeeder.removeStarterSeedOnce(db);

  // 3. Initial Widget Synchronization
  final widgetSync = container.read(widgetSyncServiceProvider);
  await widgetSync.syncAllWidgets();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const FallApp(),
    ),
  );
}

class FallApp extends ConsumerWidget {
  const FallApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'FALL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
