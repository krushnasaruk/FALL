import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/repositories/project_repository.dart';
import 'package:progress_os/data/repositories/learning_repository.dart';
import 'package:progress_os/data/repositories/focus_repository.dart';
import 'package:progress_os/data/repositories/task_repository.dart';
import 'package:progress_os/services/focus_timer_controller.dart';

void main() {
  late AppDatabase db;
  late ProjectRepository projectRepo;
  late LearningRepository learningRepo;
  late FocusRepository focusRepo;
  late TaskRepository taskRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    projectRepo = ProjectRepository(db);
    learningRepo = LearningRepository(db);
    focusRepo = FocusRepository(db);
    taskRepo = TaskRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Pillar 1: Project Management Logic & Completion Criteria', () {
    test('Milestone criteria with equal weights calculates correct percentage', () async {
      final project = await projectRepo.createProject(
        name: 'Equal Milestones Project',
        startDate: DateTime(2026, 1, 1),
        completionCriteria: 'milestone',
        milestoneTitles: ['Milestone 1', 'Milestone 2', 'Milestone 3', 'Milestone 4'],
      );

      var details = await projectRepo.getProjectById(project.id);
      expect(details, isNotNull);
      expect(details!.milestones.length, 4);
      expect(details.progressPercentage, 0.0);

      // Complete 2 of 4 milestones (50%)
      await projectRepo.toggleMilestoneCompletion(details.milestones[0].id, true);
      await projectRepo.toggleMilestoneCompletion(details.milestones[1].id, true);

      details = await projectRepo.getProjectById(project.id);
      expect(details!.completedMilestonesCount, 2);
      expect(details.progressPercentage, 0.5);
    });

    test('Milestone criteria with custom weights respects relative weights', () async {
      final project = await projectRepo.createProject(
        name: 'Weighted Milestones Project',
        startDate: DateTime(2026, 1, 1),
        completionCriteria: 'milestone',
        milestoneTitles: ['Foundational Architecture', 'Final Polish'],
      );

      var details = await projectRepo.getProjectById(project.id);
      final m1 = details!.milestones[0];
      final m2 = details.milestones[1];

      // Give Foundation weight 75 and Polish weight 25
      await projectRepo.updateMilestoneWeight(m1.id, 75);
      await projectRepo.updateMilestoneWeight(m2.id, 25);

      // Complete Foundation (75 / 100 = 75%)
      await projectRepo.toggleMilestoneCompletion(m1.id, true);
      details = await projectRepo.getProjectById(project.id);
      expect(details!.progressPercentage, 0.75);

      // Complete Polish (100 / 100 = 100%)
      await projectRepo.toggleMilestoneCompletion(m2.id, true);
      details = await projectRepo.getProjectById(project.id);
      expect(details!.progressPercentage, 1.0);
    });

    test('Task-based criteria calculates progress from root tasks without subtask double-counting', () async {
      final project = await projectRepo.createProject(
        name: 'Task-Driven Project',
        startDate: DateTime(2026, 1, 1),
        completionCriteria: 'task',
      );

      // Create 3 root tasks linked to this project, one of which has 3 subtasks
      final t1 = await taskRepo.createTask(
        title: 'Task 1 (with subtasks)',
        projectId: project.id,
        subtaskTitles: ['Subtask 1a', 'Subtask 1b', 'Subtask 1c'],
      );
      final t2 = await taskRepo.createTask(
        title: 'Task 2',
        projectId: project.id,
      );
      await taskRepo.createTask(
        title: 'Task 3',
        projectId: project.id,
      );

      var details = await projectRepo.getProjectById(project.id);
      expect(details!.tasks.length, 3, reason: 'Root tasks count should be 3, subtasks not mixed in');
      expect(details.progressPercentage, 0.0);

      // Complete Task 2
      await taskRepo.toggleTaskCompletion(t2.id, true);
      details = await projectRepo.getProjectById(project.id);
      expect(details!.completedTasksCount, 1);
      expect(details.progressPercentage, closeTo(1 / 3, 0.001));

      // Complete Task 1
      await taskRepo.toggleTaskCompletion(t1.id, true);
      details = await projectRepo.getProjectById(project.id);
      expect(details!.completedTasksCount, 2);
      expect(details.progressPercentage, closeTo(2 / 3, 0.001));
    });

    test('Deliverables checklist criteria dynamically calculates deliverable progress', () async {
      final project = await projectRepo.createProject(
        name: 'Deliverable Project',
        startDate: DateTime(2026, 1, 1),
        completionCriteria: 'deliverable',
      );

      await projectRepo.addDeliverable(projectId: project.id, title: 'API Spec v1.0');
      await projectRepo.addDeliverable(projectId: project.id, title: 'Release APK');

      var details = await projectRepo.getProjectById(project.id);
      expect(details!.deliverables.length, 2);
      expect(details.progressPercentage, 0.0);

      final d1 = details.deliverables[0];
      final d2 = details.deliverables[1];

      await projectRepo.toggleDeliverable(d1.id, true);
      details = await projectRepo.getProjectById(project.id);
      expect(details!.completedDeliverablesCount, 1);
      expect(details.progressPercentage, 0.5);

      await projectRepo.toggleDeliverable(d2.id, true);
      details = await projectRepo.getProjectById(project.id);
      expect(details!.progressPercentage, 1.0);
    });

    test('Manual progress criteria directly respects user-reported percentage', () async {
      final project = await projectRepo.createProject(
        name: 'Manual Progress Project',
        startDate: DateTime(2026, 1, 1),
        completionCriteria: 'manual',
        manualProgressPercentage: 0.65,
      );

      final details = await projectRepo.getProjectById(project.id);
      expect(details!.progressPercentage, 0.65);
    });

    test('Project status decoupling: 100% progress does not auto-complete without ceremony', () async {
      final project = await projectRepo.createProject(
        name: 'Status Decoupling Project',
        startDate: DateTime(2026, 1, 1),
        completionCriteria: 'milestone',
        milestoneTitles: ['Sole Milestone'],
      );

      var details = await projectRepo.getProjectById(project.id);
      expect(details!.project.status, 'active');

      // Complete the milestone
      await projectRepo.toggleMilestoneCompletion(details.milestones.first.id, true);
      details = await projectRepo.getProjectById(project.id);

      // Progress is 100%, but status MUST remain active until explicit user ceremony
      expect(details!.progressPercentage, 1.0);
      expect(details.project.status, 'active');
      expect(details.project.completedAt, isNull);

      // Explicit completion ceremony
      final ceremonyTime = DateTime(2026, 11, 13, 14, 0);
      await projectRepo.completeProject(
        project.id,
        completionNote: 'Shipped to production on time with 0 defects!',
        completedAt: ceremonyTime,
      );

      details = await projectRepo.getProjectById(project.id);
      expect(details!.project.status, 'completed');
      expect(details.project.completionNote, 'Shipped to production on time with 0 defects!');
      expect(details.project.completedAt, ceremonyTime);

      // Reopening preserves history and restores active status
      await projectRepo.reopenProject(project.id);
      details = await projectRepo.getProjectById(project.id);
      expect(details!.project.status, 'active');
      expect(details.project.completedAt, isNull);
      expect(details.project.completionNote, 'Shipped to production on time with 0 defects!');
    });
  });

  group('Pillar 2: Learning Progress, Time Targets & Curriculum Decoupling', () {
    test('Skill without time target honestly reports no target without fake 0% time bar', () async {
      final skill = await learningRepo.createSkill(
        name: 'Rust Systems Programming',
        category: 'Systems',
        targetMinutes: 0,
        progressMethod: 'topics',
      );

      final details = await learningRepo.getSkillById(skill.id);
      expect(details, isNotNull);
      expect(details!.hasTimeTarget, isFalse);
      expect(details.timeProgressPercentage, isNull, reason: 'Must be null so UI does not render 0%');
      expect(details.curriculumProgress, 0.0);
      expect(details.primaryProgress, 0.0);
    });

    test('Skill with time target calculates accurate time progress', () async {
      final skill = await learningRepo.createSkill(
        name: 'Distributed Systems',
        category: 'Architecture',
        targetMinutes: 1200, // 20 hours
        progressMethod: 'time',
      );

      // Log 6 hours (360 mins)
      await learningRepo.logLearningSession(
        skillId: skill.id,
        durationMinutes: 360,
        notes: 'Consensus algorithms & Raft',
      );

      final details = await learningRepo.getSkillById(skill.id);
      expect(details!.hasTimeTarget, isTrue);
      expect(details.timeProgressPercentage, closeTo(0.30, 0.001));
      expect(details.isTimeTargetExceeded, isFalse);
      expect(details.primaryProgress, closeTo(0.30, 0.001));
    });

    test('Skill over-achievement celebrates excess progress without capping or errors', () async {
      final skill = await learningRepo.createSkill(
        name: 'Flutter Animations',
        category: 'Frontend',
        targetMinutes: 600, // 10 hours
        progressMethod: 'time',
      );

      // Log 15 hours (900 mins) = 150% of target
      await learningRepo.logLearningSession(
        skillId: skill.id,
        durationMinutes: 900,
        notes: 'Advanced Rive, Canvas shaders, Physics springs',
      );

      final details = await learningRepo.getSkillById(skill.id);
      expect(details!.timeProgressPercentage, closeTo(1.50, 0.001));
      expect(details.isTimeTargetExceeded, isTrue);
    });

    test('Skill curriculum progress calculates completed topics over total topics', () async {
      final skill = await learningRepo.createSkill(
        name: 'Machine Learning Foundations',
        category: 'AI',
        progressMethod: 'topics',
      );

      await learningRepo.addModule(skillId: skill.id, title: 'Math Foundations');
      var details = await learningRepo.getSkillById(skill.id);
      final m1 = details!.modules.first;

      await learningRepo.addTopic(moduleId: m1.module.id, title: 'Linear Algebra');
      await learningRepo.addTopic(moduleId: m1.module.id, title: 'Calculus');
      await learningRepo.addTopic(moduleId: m1.module.id, title: 'Probability');

      details = await learningRepo.getSkillById(skill.id);
      expect(details!.totalTopics, 3);
      expect(details.completedTopics, 0);
      expect(details.curriculumProgress, 0.0);

      // Complete 2 topics
      final t1 = details.modules.first.topics[0];
      final t2 = details.modules.first.topics[1];

      await learningRepo.updateTopicStatus(t1.id, 'completed');
      await learningRepo.updateTopicStatus(t2.id, 'completed');

      details = await learningRepo.getSkillById(skill.id);
      expect(details!.completedTopics, 2);
      expect(details.curriculumProgress, closeTo(2 / 3, 0.001));
      expect(details.primaryProgress, closeTo(2 / 3, 0.001));
    });
  });

  group('Pillar 3: Global Focus Timer & Break Exclusion Logic', () {
    test('FocusTimerState computes effective focused seconds strictly excluding breaks', () {
      final baseTime = DateTime(2026, 11, 13, 10, 0, 0);

      // Running for 15 minutes (900 seconds)
      final stateRunning = FocusTimerState(
        status: FocusTimerStatus.running,
        targetMinutes: 25,
        accumulatedFocusedSeconds: 0,
        accumulatedBreakSeconds: 0,
        segmentStartEpochMs: baseTime.millisecondsSinceEpoch,
      );

      final timeAt15m = baseTime.add(const Duration(minutes: 15));
      expect(stateRunning.effectiveFocusedSeconds(now: timeAt15m), 900);

      // Now user takes a break after 15m focus
      final breakStartTime = timeAt15m;
      final stateOnBreak = FocusTimerState(
        status: FocusTimerStatus.onBreak,
        targetMinutes: 25,
        accumulatedFocusedSeconds: 900,
        accumulatedBreakSeconds: 0,
        segmentStartEpochMs: null,
        breakStartEpochMs: breakStartTime.millisecondsSinceEpoch,
      );

      // 5 minutes into the break
      final timeAt20m = breakStartTime.add(const Duration(minutes: 5));
      expect(stateOnBreak.effectiveFocusedSeconds(now: timeAt20m), 900,
          reason: 'Focused time must freeze and NOT advance during break');
      expect(stateOnBreak.effectiveBreakSeconds(now: timeAt20m), 300,
          reason: 'Break time must advance correctly');

      // User resumes from break
      final resumeTime = timeAt20m;
      final stateResumed = FocusTimerState(
        status: FocusTimerStatus.running,
        targetMinutes: 25,
        accumulatedFocusedSeconds: 900,
        accumulatedBreakSeconds: 300,
        segmentStartEpochMs: resumeTime.millisecondsSinceEpoch,
        breakStartEpochMs: null,
      );

      // 10 minutes after resuming (total 25m focused, 5m break)
      final timeAt30m = resumeTime.add(const Duration(minutes: 10));
      expect(stateResumed.effectiveFocusedSeconds(now: timeAt30m), 1500); // 900 + 600 = 1500s = 25m
      expect(stateResumed.accumulatedBreakSeconds, 300); // 5m break preserved
    });
  });

  group('Pillar 4: Dual Attribution & Single-Row Accounting (No Duplicate Focus Analytics)', () {
    test('Focus session linked to Project and Skill increments both without duplicating global time', () async {
      final project = await projectRepo.createProject(
        name: 'Next-Gen Mobile App',
        startDate: DateTime(2026, 1, 1),
        targetHours: 10,
      );
      final skill = await learningRepo.createSkill(
        name: 'Flutter Architecture',
        targetMinutes: 600,
      );

      final initialGlobalTotal = await focusRepo.getTotalFocusMinutes();
      final initialToday = await focusRepo.getTodayFocusMinutes();
      expect(initialGlobalTotal, 0);
      expect(initialToday, 0);

      // Record a 45-minute focus session with 10-minute break linked to BOTH project and skill
      await focusRepo.recordFocusSession(
        durationMinutes: 45,
        breakMinutes: 10,
        projectId: project.id,
        skillId: skill.id,
        sessionType: 'deepWork',
        notes: 'Implemented state management and drift persistence',
      );

      // 1. Project actual time was incremented by 45 minutes
      final projectDetails = await projectRepo.getProjectById(project.id);
      expect(projectDetails!.project.timeSpentMinutes, 45);

      // 2. Skill learning time was incremented by 45 minutes
      final skillDetails = await learningRepo.getSkillById(skill.id);
      expect(skillDetails!.skill.learningMinutes, 45);

      // 3. Authoritative single-source check: Global focus time increments by EXACTLY 45 minutes (NOT 90!)
      final updatedGlobalTotal = await focusRepo.getTotalFocusMinutes();
      final updatedToday = await focusRepo.getTodayFocusMinutes();
      expect(updatedGlobalTotal, 45, reason: 'Multi-attribution must record only 1 row in FocusSessions');
      expect(updatedToday, 45);

      // Verify break time was stored in the row
      final recentSessions = await db.select(db.focusSessions).get();
      expect(recentSessions.length, 1);
      expect(recentSessions.first.durationMinutes, 45);
      expect(recentSessions.first.breakMinutes, 10);
      expect(recentSessions.first.notes, 'Implemented state management and drift persistence');
    });

    test('Retroactive session deletion decrements linked entities and global totals safely', () async {
      final project = await projectRepo.createProject(
        name: 'Refactoring Phase',
        startDate: DateTime(2026, 1, 1),
      );
      final skill = await learningRepo.createSkill(name: 'Clean Code');

      await focusRepo.recordFocusSession(
        durationMinutes: 60,
        projectId: project.id,
        skillId: skill.id,
      );

      var projectDetails = await projectRepo.getProjectById(project.id);
      var skillDetails = await learningRepo.getSkillById(skill.id);
      expect(projectDetails!.project.timeSpentMinutes, 60);
      expect(skillDetails!.skill.learningMinutes, 60);
      expect(await focusRepo.getTotalFocusMinutes(), 60);

      // Fetch the created session ID
      final session = (await db.select(db.focusSessions).get()).first;

      // Delete the session retroactively
      await focusRepo.deleteFocusSession(session.id);

      // Verify all entities reconciled
      projectDetails = await projectRepo.getProjectById(project.id);
      skillDetails = await learningRepo.getSkillById(skill.id);
      expect(projectDetails!.project.timeSpentMinutes, 0);
      expect(skillDetails!.skill.learningMinutes, 0);
      expect(await focusRepo.getTotalFocusMinutes(), 0);
    });
  });
}
