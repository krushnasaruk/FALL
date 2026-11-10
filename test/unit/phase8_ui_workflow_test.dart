import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/theme/app_theme.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/database/database_provider.dart';
import 'package:progress_os/data/database/database_seeder.dart';
import 'package:progress_os/data/repositories/focus_repository.dart';
import 'package:progress_os/data/repositories/habit_repository.dart';
import 'package:progress_os/data/repositories/learning_repository.dart';
import 'package:progress_os/data/repositories/notes_repository.dart';
import 'package:progress_os/data/repositories/project_repository.dart';
import 'package:progress_os/data/repositories/task_repository.dart';
import 'package:progress_os/data/repositories/user_preferences_repository.dart';
import 'package:progress_os/features/calendar/screens/agenda_calendar_screen.dart';
import 'package:progress_os/features/dashboard/screens/dashboard_screen.dart';
import 'package:progress_os/features/focus/screens/focus_screen.dart';
import 'package:progress_os/features/habits/screens/goals_screen.dart';
import 'package:progress_os/features/habits/screens/habits_screen.dart';
import 'package:progress_os/features/insights/screens/insights_screen.dart';
import 'package:progress_os/features/learning/screens/learning_screen.dart';
import 'package:progress_os/features/more/screens/more_hub_screen.dart';
import 'package:progress_os/features/onboarding/screens/onboarding_screen.dart';
import 'package:progress_os/features/projects/screens/projects_screen.dart';
import 'package:progress_os/features/settings/screens/settings_screen.dart';
import 'package:progress_os/features/tasks/screens/tasks_screen.dart';
import 'package:progress_os/features/vault/screens/vault_screen.dart';
import 'package:progress_os/routing/app_router.dart';
import 'package:progress_os/services/feedback_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Phase 5-8 End-to-End & UI Integrity QA', () {
    test('FeedbackSettingsNotifier persists haptics, UI sounds, and notification sound toggles',
        () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = FeedbackSettingsNotifier();
      await notifier.setHapticsEnabled(false);
      await notifier.setSoundEffectsEnabled(false);
      await notifier.setNotificationSoundsEnabled(false);

      expect(notifier.state.hapticsEnabled, isFalse);
      expect(notifier.state.soundEffectsEnabled, isFalse);
      expect(notifier.state.notificationSoundsEnabled, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('feedback_haptics_enabled'), isFalse);
      expect(prefs.getBool('feedback_sound_effects_enabled'), isFalse);
      expect(prefs.getBool('feedback_notification_sounds_enabled'), isFalse);
    });

    test('UserPreferencesNotifier persists reorderSections and updateDisplayName', () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = UserPreferencesNotifier();
      final originalFirstId = notifier.state.dashboardSections[0].id;
      final originalSecondId = notifier.state.dashboardSections[1].id;

      await notifier.reorderSections(0, 2);
      expect(notifier.state.dashboardSections[0].id, originalSecondId);
      expect(notifier.state.dashboardSections[1].id, originalFirstId);

      await notifier.updateDisplayName('Alex');
      expect(notifier.state.displayName, 'Alex');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_display_name'), 'Alex');
      expect(prefs.getStringList('dashboard_section_order')?.first, originalSecondId);
    });

    test('End-to-end DB workflow: project -> task -> learning -> habit -> goal -> focus -> journal',
        () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() async => db.close());

      final projectRepo = ProjectRepository(db);
      final taskRepo = TaskRepository(db);
      final learningRepo = LearningRepository(db);
      final habitRepo = HabitAndGoalRepository(db);
      final focusRepo = FocusRepository(db);
      final notesRepo = NotesRepository(db);

      final project = await projectRepo.createProject(
        name: 'FALL Mobile QA',
        description: 'End-to-end verification',
        startDate: DateTime.now(),
      );
      await projectRepo.addMilestone(projectId: project.id, title: 'Ship v2');

      final task = await taskRepo.createTask(
        title: 'Verify notifications & widgets',
        priority: 'high',
        projectId: project.id,
        dueDate: DateTime.now(),
      );
      await taskRepo.toggleTaskCompletion(task.id, true);

      final skill = await learningRepo.createSkill(
        name: 'Flutter Architecture',
        category: 'Framework',
      );
      await learningRepo.addModule(skillId: skill.id, title: 'State');
      final initialSkills = await learningRepo.watchAllSkillsWithRoadmaps().first;
      final moduleId = initialSkills.first.modules.first.module.id;
      await learningRepo.addTopic(
        moduleId: moduleId,
        title: 'Riverpod Streams',
        resources: 'docs.flutter.dev',
      );
      final skills = await learningRepo.watchAllSkillsWithRoadmaps().first;
      final topicId = skills.first.modules.first.topics.first.id;
      await learningRepo.updateTopic(
        id: topicId,
        title: 'Riverpod StreamProvider',
        resources: 'riverpod.dev',
        status: 'completed',
      );
      await learningRepo.logLearningSession(skillId: skill.id, durationMinutes: 45);

      await habitRepo.createGoal(
        title: 'Publish FALL v2',
        targetValue: 10,
        unit: 'tasks',
      );
      final goals = await habitRepo.watchAllGoals().first;
      await habitRepo.updateGoalProgress(goals.first.id, 10);

      await habitRepo.createHabit(title: 'Daily Code Review');
      final habits = await habitRepo.watchHabitsWithEntries().first;
      await habitRepo.toggleHabitCheckIn(habits.first.habit.id, DateTime.now());

      await focusRepo.recordFocusSession(
        taskId: task.id,
        projectId: project.id,
        durationMinutes: 25,
        sessionType: 'pomodoro',
      );
      await notesRepo.createNote(
        title: 'Dev Log — Verification',
        content: 'All pipelines green.',
        category: 'journal',
        projectId: project.id,
      );

      final updatedGoals = await habitRepo.watchAllGoals().first;
      final updatedSkills = await learningRepo.watchAllSkillsWithRoadmaps().first;
      final notes = await notesRepo.watchAllNotes().first;

      expect(updatedGoals.first.isAchieved, isTrue);
      expect(updatedSkills.first.completedTopics, 1);
      expect(updatedSkills.first.skill.learningMinutes, 45);
      expect(notes.any((n) => n.note.category == 'journal'), isTrue);
    });

    testWidgets(
      'Empty DB honesty check: Dashboard, Insights, and Goals never show fake numbers',
      (tester) async {
        SharedPreferences.setMockInitialValues({'user_display_name': 'Tester'});
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() async => db.close());

        // 1. Empty Dashboard -> 0%, 0 of 0 tasks (never fake 78%)
        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const DashboardScreen(),
            ),
          ),
        );
        await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 80)));
        await tester.pump(const Duration(milliseconds: 120));

        expect(find.text('0%'), findsOneWidget);
        expect(find.text('No tasks scheduled today'), findsOneWidget);
        expect(find.text('78%'), findsNothing);

        // 2. Empty Insights -> honest empty state (never fake 68%, 8h, 12h)
        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const InsightsScreen(),
            ),
          ),
        );
        await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 80)));
        await tester.pump(const Duration(milliseconds: 120));

        expect(find.text('Your progress story will appear here.'), findsOneWidget);
        expect(find.text('68%'), findsNothing);

        // 3. Empty Goals -> honest empty state
        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const GoalsScreen(),
            ),
          ),
        );
        await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 80)));
        await tester.pump(const Duration(milliseconds: 120));

        expect(find.text('Give your effort a direction.'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );

    testWidgets(
      'All 14 seeded screens + shell render without layout overflow on narrow mobile (320x640) in Light & Dark',
      (tester) async {
        SharedPreferences.setMockInitialValues({'user_display_name': 'Tester'});
        final db = AppDatabase(NativeDatabase.memory());
        await tester.runAsync(() async {
          await DatabaseSeeder.seedIfEmpty(
            db: db,
            taskRepo: TaskRepository(db),
            projectRepo: ProjectRepository(db),
            learningRepo: LearningRepository(db),
            habitRepo: HabitAndGoalRepository(db),
          );
        });
        addTearDown(() async => db.close());

        tester.view.physicalSize = const Size(320 * 2, 640 * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final screens = <Widget>[
          const OnboardingScreen(),
          const DashboardScreen(),
          const TasksScreen(),
          const ProjectsScreen(),
          const LearningScreen(),
          const MoreHubScreen(),
          const InsightsScreen(),
          const FocusScreen(),
          const HabitsScreen(),
          const GoalsScreen(),
          const AgendaCalendarScreen(),
          const VaultScreen(),
          const VaultScreen(initialJournalMode: true),
          const SettingsScreen(),
        ];

        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          for (final screen in screens) {
            await tester.pumpWidget(
              ProviderScope(
                overrides: [databaseProvider.overrideWithValue(db)],
                child: MaterialApp(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: mode,
                  home: screen,
                ),
              ),
            );
            await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 40)));
            await tester.pump(const Duration(milliseconds: 80));
            expect(
              tester.takeException(),
              isNull,
              reason: 'Overflow or error on ${screen.runtimeType} ($mode)',
            );
          }
        }

        // Also smoke-test docked 5-tab navigation shell transitions
        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: Consumer(
              builder: (context, ref, _) {
                final router = ref.watch(routerProvider);
                return MaterialApp.router(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: ThemeMode.light,
                  routerConfig: router,
                );
              },
            ),
          ),
        );
        await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 60)));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Home'), findsAtLeastNWidgets(1));
        expect(find.text('Tasks'), findsAtLeastNWidgets(1));
        expect(find.text('Projects'), findsAtLeastNWidgets(1));
        expect(find.text('Learning'), findsAtLeastNWidgets(1));
        expect(find.text('More'), findsAtLeastNWidgets(1));

        await tester.tap(find.text('Tasks').last);
        await tester.pump(const Duration(milliseconds: 150));
        await tester.tap(find.text('More').last);
        await tester.pump(const Duration(milliseconds: 150));
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );

    test(
      'Version 3 starter seed cleanup removes dummy records while preserving custom entries, and clearAllData zeroes all tables',
      () async {
        SharedPreferences.setMockInitialValues({});
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() async => db.close());

        final projectRepo = ProjectRepository(db);
        final taskRepo = TaskRepository(db);
        final learningRepo = LearningRepository(db);
        final habitRepo = HabitAndGoalRepository(db);

        await DatabaseSeeder.seedIfEmpty(
          db: db,
          taskRepo: taskRepo,
          projectRepo: projectRepo,
          learningRepo: learningRepo,
          habitRepo: habitRepo,
        );

        await taskRepo.createTask(
          title: 'My Custom Real Task',
          priority: 'high',
          dueDate: DateTime.now(),
        );
        await projectRepo.createProject(
          name: 'My Real Startup Project',
          status: 'active',
          startDate: DateTime.now(),
        );

        // One-time v3 cleanup strips dummy seed data but preserves custom user records.
        await DatabaseSeeder.removeStarterSeedOnce(db);

        final tasksAfterCleanup = await db.select(db.tasks).get();
        expect(tasksAfterCleanup.map((t) => t.title), ['My Custom Real Task']);

        final projectsAfterCleanup = await db.select(db.projects).get();
        expect(projectsAfterCleanup.map((p) => p.name), ['My Real Startup Project']);

        expect(await db.select(db.skills).get(), isEmpty);
        expect(await db.select(db.learningModules).get(), isEmpty);
        expect(await db.select(db.learningTopics).get(), isEmpty);
        expect(await db.select(db.learningSessions).get(), isEmpty);
        expect(await db.select(db.habits).get(), isEmpty);
        expect(await db.select(db.habitEntries).get(), isEmpty);
        expect(await db.select(db.goals).get(), isEmpty);

        // Calling Reset All Data zeroes all remaining custom user tables cleanly.
        await db.clearAllData();

        expect(await db.select(db.tasks).get(), isEmpty);
        expect(await db.select(db.subtasks).get(), isEmpty);
        expect(await db.select(db.projects).get(), isEmpty);
        expect(await db.select(db.milestones).get(), isEmpty);
        expect(await db.select(db.skills).get(), isEmpty);
        expect(await db.select(db.learningModules).get(), isEmpty);
        expect(await db.select(db.learningTopics).get(), isEmpty);
        expect(await db.select(db.learningSessions).get(), isEmpty);
        expect(await db.select(db.habits).get(), isEmpty);
        expect(await db.select(db.habitEntries).get(), isEmpty);
        expect(await db.select(db.goals).get(), isEmpty);
        expect(await db.select(db.focusSessions).get(), isEmpty);
        expect(await db.select(db.notes).get(), isEmpty);
        expect(await db.select(db.scheduledNotifications).get(), isEmpty);
        expect(await db.select(db.activityHistory).get(), isEmpty);
      },
    );
  });
}
