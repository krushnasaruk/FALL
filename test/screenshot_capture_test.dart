import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/theme/app_theme.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/database/database_provider.dart';
import 'package:progress_os/data/database/database_seeder.dart';
import 'package:progress_os/data/repositories/habit_repository.dart';
import 'package:progress_os/data/repositories/learning_repository.dart';
import 'package:progress_os/data/repositories/project_repository.dart';
import 'package:progress_os/data/repositories/task_repository.dart';
import 'package:progress_os/features/calendar/screens/agenda_calendar_screen.dart';
import 'package:progress_os/features/dashboard/screens/dashboard_screen.dart';
import 'package:progress_os/features/focus/screens/focus_screen.dart';
import 'package:progress_os/features/habits/screens/goals_screen.dart';
import 'package:progress_os/features/habits/screens/habits_screen.dart';
import 'package:progress_os/features/insights/screens/insights_screen.dart';
import 'package:progress_os/features/learning/screens/learning_screen.dart';
import 'package:progress_os/features/more/screens/more_hub_screen.dart';
import 'package:progress_os/features/radar/screens/radar_home_screen.dart';
import 'package:progress_os/features/radar/screens/radar_preferences_screen.dart';
import 'package:progress_os/features/onboarding/screens/onboarding_screen.dart';
import 'package:progress_os/features/projects/screens/projects_screen.dart';
import 'package:progress_os/features/settings/screens/settings_screen.dart';
import 'package:progress_os/features/tasks/screens/tasks_screen.dart';
import 'package:progress_os/features/vault/screens/vault_screen.dart';
import 'package:progress_os/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool _captureScreenshots = bool.fromEnvironment('CAPTURE_SCREENSHOTS');
const String _shotDir = String.fromEnvironment(
  'SHOT_DIR',
  defaultValue: 'docs/screenshots/after',
);

Future<void> _loadRealFontsForTest() async {
  Future<void> loadInto(String family) async {
    final loader = FontLoader(family);
    const files = [
      'assets/fonts/PlusJakartaSans-Regular.ttf',
      'assets/fonts/PlusJakartaSans-Medium.ttf',
      'assets/fonts/PlusJakartaSans-SemiBold.ttf',
      'assets/fonts/PlusJakartaSans-Bold.ttf',
      'assets/fonts/PlusJakartaSans-ExtraBold.ttf',
    ];
    for (final path in files) {
      final f = File(path);
      if (f.existsSync()) {
        final bytes = f.readAsBytesSync();
        loader.addFont(Future.value(ByteData.sublistView(bytes)));
      }
    }
    await loader.load();
  }

  await loadInto('Roboto');
  await loadInto('Plus Jakarta Sans');

  final iconLoader = FontLoader('MaterialIcons');
  final iconFont = File(
    '${Platform.environment['FLUTTER_ROOT'] ?? 'C:/Users/Krushna/flutter'}/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  );
  if (iconFont.existsSync()) {
    iconLoader.addFont(Future.value(ByteData.sublistView(iconFont.readAsBytesSync())));
    await iconLoader.load();
  }
}

void main() {
  testWidgets(
    'Capture audit screenshots of app screens (light + key dark renders)',
    skip: !_captureScreenshots,
    (tester) async {
      SharedPreferences.setMockInitialValues({'user_display_name': 'Developer'});

      await tester.runAsync(() async {
        await _loadRealFontsForTest();
      });

      final db = await tester.runAsync(() async {
        final database = AppDatabase(NativeDatabase.memory());
        await DatabaseSeeder.seedIfEmpty(
          db: database,
          taskRepo: TaskRepository(database),
          projectRepo: ProjectRepository(database),
          learningRepo: LearningRepository(database),
          habitRepo: HabitAndGoalRepository(database),
        );
        return database;
      });

      final outDir = Directory(_shotDir);
      if (!outDir.existsSync()) {
        outDir.createSync(recursive: true);
      }

      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;

      // Capture full shell with docked 5-tab navigation bar first
      {
        final shellKey = GlobalKey();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              databaseProvider.overrideWithValue(db!),
            ],
            child: Consumer(
              builder: (context, ref, _) {
                final router = ref.watch(routerProvider);
                return RepaintBoundary(
                  key: shellKey,
                  child: MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: ThemeMode.light,
                    routerConfig: router,
                  ),
                );
              },
            ),
          ),
        );
        await tester.runAsync(() async {
          final ctx = shellKey.currentContext;
          if (ctx != null) {
            await precacheImage(const AssetImage('assets/images/fall_logo_light.png'), ctx);
          }
          await Future.delayed(const Duration(milliseconds: 160));
        });
        await tester.pump(const Duration(milliseconds: 250));
        await tester.runAsync(() async {
          final boundary = shellKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 2.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            await File('${outDir.path}/00_shell_home.png')
                .writeAsBytes(byteData.buffer.asUint8List());
          }
        });
      }

      final screens = <String, Widget>{
        '01_onboarding': const OnboardingScreen(),
        '02_dashboard': const DashboardScreen(),
        '03_tasks': const TasksScreen(),
        '04_projects': const ProjectsScreen(),
        '05_learning': const LearningScreen(),
        '06_more': const MoreHubScreen(),
        '07_insights': const InsightsScreen(),
        '08_focus': const FocusScreen(),
        '09_habits': const HabitsScreen(),
        '09b_goals': const GoalsScreen(),
        '10_calendar': const AgendaCalendarScreen(),
        '11_vault': const VaultScreen(),
        '11b_journal': const VaultScreen(initialJournalMode: true),
        '12_settings': const SettingsScreen(),
      };

      Future<void> captureWidget(String fileName, Widget screen, ThemeMode mode) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              databaseProvider.overrideWithValue(db),
            ],
            child: RepaintBoundary(
              key: key,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: mode,
                home: screen,
              ),
            ),
          ),
        );

        await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 140)));
        await tester.pump(const Duration(milliseconds: 220));

        await tester.runAsync(() async {
          final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 2.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            await File('${outDir.path}/$fileName.png')
                .writeAsBytes(byteData.buffer.asUint8List());
          }
        });
      }

      for (final entry in screens.entries) {
        await captureWidget(entry.key, entry.value, ThemeMode.light);
      }
      await captureWidget('14_radar_home', const RadarHomeScreen(), ThemeMode.light);
      await captureWidget('15_radar_prefs', const RadarPreferencesScreen(), ThemeMode.light);

      final darkScreens = <String, Widget>{
        'dark_02_dashboard': const DashboardScreen(),
        'dark_03_tasks': const TasksScreen(),
        'dark_05_learning': const LearningScreen(),
        'dark_07_insights': const InsightsScreen(),
        'dark_08_focus': const FocusScreen(),
        'dark_12_settings': const SettingsScreen(),
        'dark_14_radar_home': const RadarHomeScreen(),
      };
      for (final entry in darkScreens.entries) {
        await captureWidget(entry.key, entry.value, ThemeMode.dark);
      }

      await tester.runAsync(() async {
        await db.close();
      });

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    },
  );
}
