import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';
import '../repositories/habit_repository.dart';
import '../repositories/learning_repository.dart';
import '../repositories/project_repository.dart';
import '../repositories/task_repository.dart';

class DatabaseSeeder {
  DatabaseSeeder._();

  static const String _v3SeedCleanupPrefKey = 'v3_starter_seed_cleaned_v1';

  static const List<String> _starterProjectNames = [
    'ProgressOS Core Platform',
  ];

  static const List<String> _starterTaskTitles = [
    'Inspect widget synchronization on Android 14',
    'Review weekly systems architecture notes',
  ];

  static const List<String> _starterSkillNames = [
    'Flutter & Dart',
    'Machine Learning & LLMs',
  ];

  static const List<String> _starterHabitTitles = [
    'Daily Technical Deep Work (45+ mins)',
  ];

  static const List<String> _starterGoalTitles = [
    'Build 10 hours of startup features this week',
  ];

  /// One-time cleanup executed on startup for upgrades from v1/v2 so any
  /// automatically seeded sample records are removed while user-created data
  /// remains untouched.
  static Future<void> removeStarterSeedOnce(AppDatabase db) async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_v3SeedCleanupPrefKey) == true) {
        return;
      }
    } catch (e) {
      debugPrint('SharedPreferences unavailable for seed cleanup flag: $e');
    }

    try {
      await db.transaction(() async {
        final matchedIds = <String>{};

        // 1. Collect starter tasks and delete their subtasks + task rows
        final starterTasks = await (db.select(db.tasks)
              ..where((t) => t.title.isIn(_starterTaskTitles)))
            .get();
        final starterTaskIds = starterTasks.map((t) => t.id).toList();
        matchedIds.addAll(starterTaskIds);
        if (starterTaskIds.isNotEmpty) {
          await (db.delete(db.subtasks)
                ..where((s) => s.taskId.isIn(starterTaskIds)))
              .go();
          await (db.delete(db.scheduledNotifications)
                ..where((n) => n.taskId.isIn(starterTaskIds)))
              .go();
          await (db.delete(db.tasks)..where((t) => t.id.isIn(starterTaskIds)))
              .go();
        }

        // 2. Collect starter projects, detach any custom child references, delete milestones & project
        final starterProjects = await (db.select(db.projects)
              ..where((p) => p.name.isIn(_starterProjectNames)))
            .get();
        final starterProjectIds = starterProjects.map((p) => p.id).toList();
        matchedIds.addAll(starterProjectIds);
        if (starterProjectIds.isNotEmpty) {
          await (db.update(db.tasks)
                ..where((t) => t.projectId.isIn(starterProjectIds)))
              .write(const TasksCompanion(projectId: Value(null)));
          await (db.update(db.focusSessions)
                ..where((f) => f.projectId.isIn(starterProjectIds)))
              .write(const FocusSessionsCompanion(projectId: Value(null)));
          await (db.update(db.notes)
                ..where((n) => n.projectId.isIn(starterProjectIds)))
              .write(const NotesCompanion(projectId: Value(null)));
          await (db.delete(db.milestones)
                ..where((m) => m.projectId.isIn(starterProjectIds)))
              .go();
          await (db.delete(db.projects)
                ..where((p) => p.id.isIn(starterProjectIds)))
              .go();
        }

        // 3. Collect starter skills, delete topics -> modules -> sessions -> skills
        final starterSkills = await (db.select(db.skills)
              ..where((s) => s.name.isIn(_starterSkillNames)))
            .get();
        final starterSkillIds = starterSkills.map((s) => s.id).toList();
        matchedIds.addAll(starterSkillIds);
        if (starterSkillIds.isNotEmpty) {
          final starterModules = await (db.select(db.learningModules)
                ..where((m) => m.skillId.isIn(starterSkillIds)))
              .get();
          final starterModuleIds = starterModules.map((m) => m.id).toList();
          matchedIds.addAll(starterModuleIds);
          if (starterModuleIds.isNotEmpty) {
            await (db.delete(db.learningTopics)
                  ..where((t) => t.moduleId.isIn(starterModuleIds)))
                .go();
          }
          await (db.delete(db.learningModules)
                ..where((m) => m.skillId.isIn(starterSkillIds)))
              .go();
          await (db.delete(db.learningSessions)
                ..where((s) => s.skillId.isIn(starterSkillIds)))
              .go();
          await (db.update(db.focusSessions)
                ..where((f) => f.skillId.isIn(starterSkillIds)))
              .write(const FocusSessionsCompanion(skillId: Value(null)));
          await (db.update(db.notes)
                ..where((n) => n.skillId.isIn(starterSkillIds)))
              .write(const NotesCompanion(skillId: Value(null)));
          await (db.delete(db.skills)
                ..where((s) => s.id.isIn(starterSkillIds)))
              .go();
        }

        // 4. Collect starter habits and goals
        final starterHabits = await (db.select(db.habits)
              ..where((h) => h.title.isIn(_starterHabitTitles)))
            .get();
        final starterHabitIds = starterHabits.map((h) => h.id).toList();
        matchedIds.addAll(starterHabitIds);
        if (starterHabitIds.isNotEmpty) {
          await (db.delete(db.habitEntries)
                ..where((e) => e.habitId.isIn(starterHabitIds)))
              .go();
          await (db.delete(db.habits)
                ..where((h) => h.id.isIn(starterHabitIds)))
              .go();
        }

        final starterGoals = await (db.select(db.goals)
              ..where((g) => g.title.isIn(_starterGoalTitles)))
            .get();
        final starterGoalIds = starterGoals.map((g) => g.id).toList();
        matchedIds.addAll(starterGoalIds);
        if (starterGoalIds.isNotEmpty) {
          await (db.delete(db.goals)..where((g) => g.id.isIn(starterGoalIds)))
              .go();
        }

        // 5. Remove starter activity history entries without touching user actions
        if (matchedIds.isNotEmpty) {
          await (db.delete(db.activityHistory)
                ..where((a) => a.entityId.isIn(matchedIds)))
              .go();
        }
        final remainingHistory = await db.select(db.activityHistory).get();
        final starterSummaryTerms = <String>[
          ..._starterProjectNames,
          ..._starterTaskTitles,
          ..._starterSkillNames,
          ..._starterHabitTitles,
          ..._starterGoalTitles,
        ];
        final matchingHistoryIds = remainingHistory
            .where((a) => starterSummaryTerms.any((term) => a.summary.contains(term)))
            .map((a) => a.id)
            .toList();
        if (matchingHistoryIds.isNotEmpty) {
          await (db.delete(db.activityHistory)
                ..where((a) => a.id.isIn(matchingHistoryIds)))
              .go();
        }
      });

      await prefs?.setBool(_v3SeedCleanupPrefKey, true);
    } catch (e) {
      debugPrint('Error removing starter seed records: $e');
    }
  }

  static Future<void> seedIfEmpty({
    required AppDatabase db,
    required TaskRepository taskRepo,
    required ProjectRepository projectRepo,
    required LearningRepository learningRepo,
    required HabitAndGoalRepository habitRepo,
  }) async {
    final existingTasks = await db.select(db.tasks).get();
    if (existingTasks.isNotEmpty) {
      return; // Already initialized
    }

    try {
      final now = DateTime.now();

      // 1. Seed Startup / Dev Project
      final project = await projectRepo.createProject(
        name: 'ProgressOS Core Platform',
        description: 'Personal tech progress and engineering productivity operating system built with Flutter and Drift.',
        category: 'Startup',
        startDate: now.subtract(const Duration(days: 7)),
        targetDate: now.add(const Duration(days: 21)),
        status: 'active',
        priority: 'high',
        techStack: 'Flutter, Dart, SQLite, Riverpod, Kotlin, Glance',
        repositoryUrl: 'https://github.com/developer/progress_os',
        notes: 'Local-first architecture with strict offline capability and native Android widget support.',
        milestoneTitles: [
          'Design System & Clean Architecture Scaffolding',
          'Drift Relational SQLite Schema & Repositories',
          'Automated Local Notification System & Exact Alarms',
          'Android Native Home Screen Widget Providers',
        ],
      );

      // 2. Seed Skills & Structured Roadmaps
      final flutterSkill = await learningRepo.createSkill(
        name: 'Flutter & Dart',
        category: 'Framework',
        currentLevel: 'intermediate',
        targetLevel: 'expert',
        notes: 'Deep mastery of Flutter rendering pipeline, custom painters, and local database concurrency.',
      );

      await learningRepo.addModule(
        skillId: flutterSkill.id,
        title: 'Drift & SQLite Concurrency',
        description: 'Reactive database streams, transactions, and foreign key cascades.',
      );

      final modules = await (db.select(db.learningModules)..where((m) => m.skillId.equals(flutterSkill.id))).get();
      if (modules.isNotEmpty) {
        await learningRepo.addTopic(
          moduleId: modules.first.id,
          title: 'Asynchronous streaming and DAOs',
          resources: 'https://drift.simonbinder.eu/docs/getting-started/',
        );
        await learningRepo.addTopic(
          moduleId: modules.first.id,
          title: 'Drift migration strategies and tests',
        );
      }

      await learningRepo.logLearningSession(
        skillId: flutterSkill.id,
        durationMinutes: 90,
        notes: 'Configured Drift SQLite reactive tables and build_runner.',
      );

      final mlSkill = await learningRepo.createSkill(
        name: 'Machine Learning & LLMs',
        category: 'AI & ML',
        currentLevel: 'beginner',
        targetLevel: 'advanced',
        notes: 'Fine-tuning transformers and local on-device inference using ONNX / TFLite.',
      );

      await learningRepo.addModule(
        skillId: mlSkill.id,
        title: 'Foundations of Attention Mechanisms',
      );

      // 3. Seed Initial Tasks
      await taskRepo.createTask(
        title: 'Inspect widget synchronization on Android 14',
        description: 'Verify Kotlin RemoteViews broadcast receiver updates correctly after task toggles.',
        priority: 'urgent',
        dueDate: now.add(const Duration(hours: 4)),
        hasDueTime: true,
        projectId: project.id,
        skillId: flutterSkill.id,
        estimatedMinutes: 45,
        tags: 'android, widgets, flutter',
        subtaskTitles: [
          'Check SharedPreferences payload keys',
          'Verify pending intent flags for mutability',
          'Test app launcher deep link',
        ],
      );

      await taskRepo.createTask(
        title: 'Review weekly systems architecture notes',
        description: 'Summarize key database optimizations and local caching strategies.',
        priority: 'medium',
        dueDate: now.add(const Duration(days: 1, hours: 2)),
        hasDueTime: true,
        estimatedMinutes: 30,
        tags: 'study, notes',
      );

      // 4. Seed Habit & Goal
      await habitRepo.createHabit(
        title: 'Daily Technical Deep Work (45+ mins)',
        description: 'Focus without notifications on core codebase architecture.',
        frequency: 'daily',
        targetDaysPerWeek: 7,
      );

      await habitRepo.toggleHabitCheckIn(
        (await db.select(db.habits).get()).first.id,
        now,
      );

      await habitRepo.createGoal(
        title: 'Build 10 hours of startup features this week',
        type: 'weekly',
        targetValue: 10.0,
        currentValue: 3.5,
        unit: 'hrs',
      );
    } catch (e) {
      debugPrint('Error seeding starter database: $e');
    }
  }
}

