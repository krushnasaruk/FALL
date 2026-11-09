import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/database/database_provider.dart';
import 'data/database/database_seeder.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/learning_repository.dart';
import 'data/repositories/project_repository.dart';
import 'data/repositories/task_repository.dart';
import 'routing/app_router.dart';
import 'services/notification_service.dart';
import 'services/widget_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create Riverpod container for app startup initialization
  final container = ProviderContainer();

  // 1. Initialize Local Notification Service
  final notifService = container.read(notificationServiceProvider);
  await notifService.initialize();

  // 2. Check and seed database if launching for the first time
  final db = container.read(databaseProvider);
  final taskRepo = container.read(taskRepositoryProvider);
  final projectRepo = container.read(projectRepositoryProvider);
  final learningRepo = container.read(learningRepositoryProvider);
  final habitRepo = container.read(habitRepositoryProvider);

  await DatabaseSeeder.seedIfEmpty(
    db: db,
    taskRepo: taskRepo,
    projectRepo: projectRepo,
    learningRepo: learningRepo,
    habitRepo: habitRepo,
  );

  // 3. Initial Widget Synchronization
  final widgetSync = container.read(widgetSyncServiceProvider);
  await widgetSync.syncAllWidgets();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ProgressOSApp(),
    ),
  );
}

class ProgressOSApp extends ConsumerWidget {
  const ProgressOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'ProgressOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
