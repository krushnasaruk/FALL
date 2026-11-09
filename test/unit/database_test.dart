import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/repositories/habit_repository.dart';
import 'package:progress_os/data/repositories/learning_repository.dart';
import 'package:progress_os/data/repositories/project_repository.dart';
import 'package:progress_os/data/repositories/task_repository.dart';

void main() {
  late AppDatabase db;
  late TaskRepository taskRepo;
  late ProjectRepository projectRepo;
  late LearningRepository learningRepo;
  late HabitAndGoalRepository habitRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    taskRepo = TaskRepository(db);
    projectRepo = ProjectRepository(db);
    learningRepo = LearningRepository(db);
    habitRepo = HabitAndGoalRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift Database & Repositories Unit Tests', () {
    test('Create, complete, and verify task with subtasks', () async {
      final task = await taskRepo.createTask(
        title: 'Master Flutter Canvas Rendering',
        priority: 'high',
        estimatedMinutes: 60,
        subtaskTitles: ['Study RenderCustomPaint', 'Implement custom wave effect'],
      );

      expect(task.title, 'Master Flutter Canvas Rendering');
      expect(task.priority, 'high');
      expect(task.isCompleted, false);

      final taskWithSubs = await taskRepo.getTaskById(task.id);
      expect(taskWithSubs, isNotNull);
      expect(taskWithSubs!.subtasks.length, 2);

      // Complete subtask
      await taskRepo.toggleSubtaskCompletion(taskWithSubs.subtasks.first.id, true);
      final updated = await taskRepo.getTaskById(task.id);
      expect(updated!.completedSubtasksCount, 1);

      // Complete task
      await taskRepo.toggleTaskCompletion(task.id, true);
      final finalTask = await taskRepo.getTaskById(task.id);
      expect(finalTask!.task.isCompleted, true);
    });

    test('Project creation and dynamic progress calculation', () async {
      final project = await projectRepo.createProject(
        name: 'Autonomous Drone Flight Controller',
        category: 'IoT & Hardware',
        startDate: DateTime.now(),
        priority: 'urgent',
        milestoneTitles: ['PID tuning', 'Sensor calibration'],
      );

      final pWithD = await projectRepo.getProjectById(project.id);
      expect(pWithD, isNotNull);
      expect(pWithD!.milestones.length, 2);
      expect(pWithD.progressPercentage, 0.0);

      // Complete 1 milestone
      await projectRepo.toggleMilestoneCompletion(pWithD.milestones.first.id, true);
      final updated = await projectRepo.getProjectById(project.id);
      expect(updated!.completedMilestonesCount, 1);
      expect(updated.progressPercentage, 0.5);
    });

    test('Skill and roadmap module tracking', () async {
      final skill = await learningRepo.createSkill(
        name: 'Rust Systems Programming',
        category: 'Language',
        currentLevel: 'beginner',
        targetLevel: 'advanced',
      );

      await learningRepo.addModule(skillId: skill.id, title: 'Ownership & Borrowing');
      final sWithR = await learningRepo.getSkillById(skill.id);
      expect(sWithR, isNotNull);
      expect(sWithR!.modules.length, 1);

      // Add topic
      await learningRepo.addTopic(
        moduleId: sWithR.modules.first.module.id,
        title: 'Lifetimes and smart pointers',
      );

      final sWithTopic = await learningRepo.getSkillById(skill.id);
      expect(sWithTopic!.totalTopics, 1);
      expect(sWithTopic.completedTopics, 0);

      // Mark topic completed
      await learningRepo.updateTopicStatus(
        sWithTopic.modules.first.topics.first.id,
        'completed',
      );

      final sCompleted = await learningRepo.getSkillById(skill.id);
      expect(sCompleted!.completedTopics, 1);
      expect(sCompleted.progressPercentage, 1.0);
    });

    test('Habit check-in and streak tracking', () async {
      await habitRepo.createHabit(title: 'Daily Code Commit');
      final habits = await habitRepo.watchHabitsWithEntries().first;
      expect(habits.length, 1);

      final habitId = habits.first.habit.id;
      final now = DateTime.now();

      await habitRepo.toggleHabitCheckIn(habitId, now);
      final updated = await habitRepo.watchHabitsWithEntries().first;
      expect(updated.first.isCompletedToday, true);
      expect(updated.first.currentStreak, 1);
    });
  });
}
