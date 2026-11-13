import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class ProjectWithDetails {
  final ProjectEntry project;
  final List<MilestoneEntry> milestones;
  final List<TaskEntry> tasks;
  final List<ProjectDeliverableEntry> deliverables;

  ProjectWithDetails({
    required this.project,
    required this.milestones,
    required this.tasks,
    this.deliverables = const [],
  });

  int get completedMilestonesCount =>
      milestones.where((m) => m.isCompleted).length;

  int get totalMilestonesCount => milestones.length;

  int get completedTasksCount => tasks.where((t) => t.isCompleted).length;

  int get totalTasksCount => tasks.length;

  int get completedDeliverablesCount =>
      deliverables.where((d) => d.isCompleted).length;

  int get totalDeliverablesCount => deliverables.length;

  /// Progress calculated dynamically according to chosen completion criteria:
  /// - 'milestone': weighted milestone progress (fallback to equal count if weights <= 0)
  /// - 'task': completed tasks / total tasks (0.0 if no tasks)
  /// - 'deliverable': completed deliverables / total deliverables (0.0 if no deliverables)
  /// - 'manual': manualProgressPercentage
  double get progressPercentage {
    final criteria = project.completionCriteria;
    switch (criteria) {
      case 'milestone':
        if (milestones.isEmpty) {
          return project.status == 'completed' ? 1.0 : 0.0;
        }
        final totalWeight = milestones.fold<int>(
            0, (sum, m) => sum + (m.weight > 0 ? m.weight : 1));
        if (totalWeight <= 0) {
          return (completedMilestonesCount / milestones.length).clamp(0.0, 1.0);
        }
        final completedWeight = milestones
            .where((m) => m.isCompleted)
            .fold<int>(0, (sum, m) => sum + (m.weight > 0 ? m.weight : 1));
        return (completedWeight / totalWeight).clamp(0.0, 1.0);

      case 'task':
        if (tasks.isEmpty) {
          return project.status == 'completed' ? 1.0 : 0.0;
        }
        return (completedTasksCount / tasks.length).clamp(0.0, 1.0);

      case 'deliverable':
        if (deliverables.isEmpty) {
          return project.status == 'completed' ? 1.0 : 0.0;
        }
        return (completedDeliverablesCount / deliverables.length).clamp(0.0, 1.0);

      case 'manual':
        return (project.manualProgressPercentage).clamp(0.0, 1.0);

      default:
        if (milestones.isEmpty && tasks.isEmpty) {
          return project.status == 'completed' ? 1.0 : 0.0;
        }
        if (milestones.isNotEmpty) {
          return (completedMilestonesCount / milestones.length).clamp(0.0, 1.0);
        }
        return (completedTasksCount / tasks.length).clamp(0.0, 1.0);
    }
  }

  /// Human-readable description of the progress calculation for user transparency.
  String get criteriaDescription {
    switch (project.completionCriteria) {
      case 'milestone':
        final totalWeight = milestones.fold<int>(
            0, (sum, m) => sum + (m.weight > 0 ? m.weight : 1));
        final completedWeight = milestones
            .where((m) => m.isCompleted)
            .fold<int>(0, (sum, m) => sum + (m.weight > 0 ? m.weight : 1));
        final hasCustomWeights = milestones.any((m) => m.weight != 1);
        if (hasCustomWeights && totalWeight > 0) {
          return '$completedWeight of $totalWeight weighted pts ($completedMilestonesCount/$totalMilestonesCount done)';
        }
        return '$completedMilestonesCount of $totalMilestonesCount milestones';
      case 'task':
        return '$completedTasksCount of $totalTasksCount tasks';
      case 'deliverable':
        return '$completedDeliverablesCount of $totalDeliverablesCount deliverables';
      case 'manual':
        return 'User-reported (${(project.manualProgressPercentage * 100).toStringAsFixed(0)}%)';
      default:
        return '$completedMilestonesCount of $totalMilestonesCount milestones';
    }
  }

  String get criteriaLabel {
    switch (project.completionCriteria) {
      case 'milestone':
        return 'Milestones';
      case 'task':
        return 'Tasks';
      case 'deliverable':
        return 'Deliverables';
      case 'manual':
        return 'Manual';
      default:
        return 'Milestones';
    }
  }
}

class ProjectRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  ProjectRepository(this._db);

  Stream<List<ProjectWithDetails>> watchAllProjectsWithDetails() {
    return _db.select(_db.projects).watch().asyncMap((projects) async {
      final List<ProjectWithDetails> result = [];
      for (final p in projects) {
        final milestones = await (_db.select(_db.milestones)
              ..where((m) => m.projectId.equals(p.id))
              ..orderBy([(m) => OrderingTerm(expression: m.orderIndex)]))
            .get();

        final tasks = await (_db.select(_db.tasks)
              ..where((t) => t.projectId.equals(p.id)))
            .get();

        final deliverables = await (_db.select(_db.projectDeliverables)
              ..where((d) => d.projectId.equals(p.id))
              ..orderBy([(d) => OrderingTerm(expression: d.orderIndex)]))
            .get();

        result.add(ProjectWithDetails(
          project: p,
          milestones: milestones,
          tasks: tasks,
          deliverables: deliverables,
        ));
      }
      return result;
    });
  }

  Future<ProjectWithDetails?> getProjectById(String id) async {
    final project = await (_db.select(_db.projects)..where((p) => p.id.equals(id))).getSingleOrNull();
    if (project == null) return null;

    final milestones = await (_db.select(_db.milestones)
          ..where((m) => m.projectId.equals(id))
          ..orderBy([(m) => OrderingTerm(expression: m.orderIndex)]))
        .get();

    final tasks = await (_db.select(_db.tasks)..where((t) => t.projectId.equals(id))).get();

    final deliverables = await (_db.select(_db.projectDeliverables)
          ..where((d) => d.projectId.equals(id))
          ..orderBy([(d) => OrderingTerm(expression: d.orderIndex)]))
        .get();

    return ProjectWithDetails(
      project: project,
      milestones: milestones,
      tasks: tasks,
      deliverables: deliverables,
    );
  }

  Future<ProjectEntry> createProject({
    required String name,
    String? description,
    String category = 'Development',
    required DateTime startDate,
    DateTime? targetDate,
    String status = 'active',
    String priority = 'medium',
    String techStack = '',
    String? repositoryUrl,
    String? notes,
    String completionCriteria = 'milestone',
    double manualProgressPercentage = 0.0,
    double? targetHours,
    List<String> milestoneTitles = const [],
    List<String> deliverableTitles = const [],
  }) async {
    final now = DateTime.now();
    final projectId = _uuid.v4();

    final companion = ProjectsCompanion(
      id: Value(projectId),
      name: Value(name.trim()),
      description: Value(description?.trim()),
      category: Value(category),
      startDate: Value(startDate),
      targetDate: Value(targetDate),
      status: Value(status),
      priority: Value(priority),
      techStack: Value(techStack.trim()),
      repositoryUrl: Value(repositoryUrl?.trim()),
      notes: Value(notes?.trim()),
      timeSpentMinutes: const Value(0),
      completionCriteria: Value(completionCriteria),
      manualProgressPercentage: Value(manualProgressPercentage.clamp(0.0, 1.0)),
      targetHours: Value(targetHours),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _db.into(_db.projects).insert(companion);

    // Insert milestones
    for (int i = 0; i < milestoneTitles.length; i++) {
      if (milestoneTitles[i].trim().isNotEmpty) {
        await _db.into(_db.milestones).insert(MilestonesCompanion(
              id: Value(_uuid.v4()),
              projectId: Value(projectId),
              title: Value(milestoneTitles[i].trim()),
              isCompleted: const Value(false),
              orderIndex: Value(i),
              weight: const Value(1),
            ));
      }
    }

    // Insert deliverables
    for (int i = 0; i < deliverableTitles.length; i++) {
      if (deliverableTitles[i].trim().isNotEmpty) {
        await _db.into(_db.projectDeliverables).insert(ProjectDeliverablesCompanion(
              id: Value(_uuid.v4()),
              projectId: Value(projectId),
              title: Value(deliverableTitles[i].trim()),
              isCompleted: const Value(false),
              orderIndex: Value(i),
              createdAt: Value(now),
            ));
      }
    }

    // Log activity
    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('project'),
          entityId: Value(projectId),
          action: const Value('created'),
          summary: Value('Created project "$name"'),
          createdAt: Value(now),
        ));

    return (await (_db.select(_db.projects)..where((p) => p.id.equals(projectId))).getSingle());
  }

  Future<void> updateProject({
    required String id,
    required String name,
    String? description,
    required String category,
    DateTime? targetDate,
    required String status,
    required String priority,
    required String techStack,
    String? repositoryUrl,
    String? notes,
    String? completionCriteria,
    double? manualProgressPercentage,
    double? targetHours,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        name: Value(name.trim()),
        description: Value(description?.trim()),
        category: Value(category),
        targetDate: Value(targetDate),
        status: Value(status),
        priority: Value(priority),
        techStack: Value(techStack.trim()),
        repositoryUrl: Value(repositoryUrl?.trim()),
        notes: Value(notes?.trim()),
        completionCriteria: completionCriteria != null ? Value(completionCriteria) : const Value.absent(),
        manualProgressPercentage: manualProgressPercentage != null
            ? Value(manualProgressPercentage.clamp(0.0, 1.0))
            : const Value.absent(),
        targetHours: targetHours != null ? Value(targetHours) : const Value.absent(),
        updatedAt: Value(now),
      ),
    );

    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('project'),
          entityId: Value(id),
          action: const Value('progressed'),
          summary: Value('Updated project "$name" (Status: $status)'),
          createdAt: Value(now),
        ));
  }

  Future<void> updateManualProgress(String projectId, double progress) async {
    final now = DateTime.now();
    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId))).write(
      ProjectsCompanion(
        manualProgressPercentage: Value(progress.clamp(0.0, 1.0)),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> completeProject(
    String projectId, {
    String? completionNote,
    DateTime? completedAt,
  }) async {
    final now = completedAt ?? DateTime.now();
    final p = await (_db.select(_db.projects)..where((p) => p.id.equals(projectId))).getSingleOrNull();
    if (p == null) return;

    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId))).write(
      ProjectsCompanion(
        status: const Value('completed'),
        completedAt: Value(now),
        completionNote: Value(completionNote?.trim()),
        updatedAt: Value(now),
      ),
    );

    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('project'),
          entityId: Value(projectId),
          action: const Value('completed'),
          summary: Value('Completed project "${p.name}"'),
          createdAt: Value(now),
        ));
  }

  Future<void> reopenProject(String projectId) async {
    final now = DateTime.now();
    final p = await (_db.select(_db.projects)..where((p) => p.id.equals(projectId))).getSingleOrNull();
    if (p == null) return;

    await (_db.update(_db.projects)..where((p) => p.id.equals(projectId))).write(
      ProjectsCompanion(
        status: const Value('active'),
        completedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );

    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('project'),
          entityId: Value(projectId),
          action: const Value('reopened'),
          summary: Value('Reopened project "${p.name}"'),
          createdAt: Value(now),
        ));
  }

  Future<void> deleteProject(String id) async {
    final project = await (_db.select(_db.projects)..where((p) => p.id.equals(id))).getSingleOrNull();
    await (_db.delete(_db.projects)..where((p) => p.id.equals(id))).go();

    if (project != null) {
      await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
            id: Value(_uuid.v4()),
            entityType: const Value('project'),
            entityId: Value(id),
            action: const Value('deleted'),
            summary: Value('Deleted project "${project.name}"'),
            createdAt: Value(DateTime.now()),
          ));
    }
  }

  // Milestones CRUD
  Future<void> addMilestone({
    required String projectId,
    required String title,
    String? description,
    DateTime? targetDate,
    int weight = 1,
  }) async {
    final existing = await (_db.select(_db.milestones)..where((m) => m.projectId.equals(projectId))).get();
    await _db.into(_db.milestones).insert(MilestonesCompanion(
          id: Value(_uuid.v4()),
          projectId: Value(projectId),
          title: Value(title.trim()),
          description: Value(description?.trim()),
          targetDate: Value(targetDate),
          isCompleted: const Value(false),
          orderIndex: Value(existing.length),
          weight: Value(weight > 0 ? weight : 1),
        ));
  }

  Future<void> updateMilestoneWeight(String milestoneId, int weight) async {
    await (_db.update(_db.milestones)..where((m) => m.id.equals(milestoneId))).write(
      MilestonesCompanion(
        weight: Value(weight > 0 ? weight : 1),
      ),
    );
  }

  Future<void> toggleMilestoneCompletion(String milestoneId, bool isCompleted) async {
    final now = DateTime.now();
    final m = await (_db.select(_db.milestones)..where((m) => m.id.equals(milestoneId))).getSingleOrNull();
    if (m == null) return;

    await (_db.update(_db.milestones)..where((entry) => entry.id.equals(milestoneId))).write(
      MilestonesCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? now : null),
      ),
    );

    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('milestone'),
          entityId: Value(milestoneId),
          action: Value(isCompleted ? 'completed' : 'reopened'),
          summary: Value('${isCompleted ? "Completed" : "Reopened"} milestone "${m.title}"'),
          createdAt: Value(now),
        ));
  }

  Future<void> deleteMilestone(String milestoneId) async {
    await (_db.delete(_db.milestones)..where((m) => m.id.equals(milestoneId))).go();
  }

  // Deliverables CRUD
  Future<void> addDeliverable({
    required String projectId,
    required String title,
  }) async {
    final existing = await (_db.select(_db.projectDeliverables)..where((d) => d.projectId.equals(projectId))).get();
    await _db.into(_db.projectDeliverables).insert(ProjectDeliverablesCompanion(
          id: Value(_uuid.v4()),
          projectId: Value(projectId),
          title: Value(title.trim()),
          isCompleted: const Value(false),
          orderIndex: Value(existing.length),
          createdAt: Value(DateTime.now()),
        ));
  }

  Future<void> toggleDeliverable(String deliverableId, bool isCompleted) async {
    final now = DateTime.now();
    final d = await (_db.select(_db.projectDeliverables)..where((d) => d.id.equals(deliverableId))).getSingleOrNull();
    if (d == null) return;

    await (_db.update(_db.projectDeliverables)..where((entry) => entry.id.equals(deliverableId))).write(
      ProjectDeliverablesCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? now : null),
      ),
    );

    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('deliverable'),
          entityId: Value(deliverableId),
          action: Value(isCompleted ? 'completed' : 'reopened'),
          summary: Value('${isCompleted ? "Verified" : "Reopened"} deliverable "${d.title}"'),
          createdAt: Value(now),
        ));
  }

  Future<void> deleteDeliverable(String deliverableId) async {
    await (_db.delete(_db.projectDeliverables)..where((d) => d.id.equals(deliverableId))).go();
  }

  Future<void> addTimeSpent(String projectId, int minutes) async {
    final p = await (_db.select(_db.projects)..where((p) => p.id.equals(projectId))).getSingleOrNull();
    if (p == null) return;
    await (_db.update(_db.projects)..where((entry) => entry.id.equals(projectId))).write(
      ProjectsCompanion(
        timeSpentMinutes: Value(p.timeSpentMinutes + minutes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProjectRepository(db);
});

final allProjectsStreamProvider = StreamProvider<List<ProjectWithDetails>>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.watchAllProjectsWithDetails();
});
