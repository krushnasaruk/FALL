import 'package:flutter/foundation.dart';
import '../database/app_database.dart';
import '../repositories/habit_repository.dart';
import '../repositories/learning_repository.dart';
import '../repositories/project_repository.dart';
import '../repositories/task_repository.dart';

class DatabaseSeeder {
  DatabaseSeeder._();

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

