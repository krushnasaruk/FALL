import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class ProjectWithDetails {
  final ProjectEntry project;
  final List<MilestoneEntry> milestones;
  final List<TaskEntry> tasks;

  ProjectWithDetails({
    required this.project,
    required this.milestones,
    required this.tasks,
  });

  int get completedMilestonesCount =>
      milestones.where((m) => m.isCompleted).length;

  int get totalMilestonesCount => milestones.length;

  int get completedTasksCount => tasks.where((t) => t.isCompleted).length;

  int get totalTasksCount => tasks.length;

  /// Progress calculated dynamically from milestones and tasks
  double get progressPercentage {
    if (milestones.isEmpty && tasks.isEmpty) {
      return project.status == 'completed' ? 1.0 : 0.0;
    }
    double milestoneWeight = milestones.isNotEmpty ? 0.6 : 0.0;
    double taskWeight = tasks.isNotEmpty ? (milestones.isNotEmpty ? 0.4 : 1.0) : 0.0;
    if (tasks.isEmpty) milestoneWeight = 1.0;

    double mScore = milestones.isNotEmpty ? (completedMilestonesCount / milestones.length) : 0.0;
    double tScore = tasks.isNotEmpty ? (completedTasksCount / tasks.length) : 0.0;

    return (mScore * milestoneWeight) + (tScore * taskWeight);
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

        result.add(ProjectWithDetails(
          project: p,
          milestones: milestones,
          tasks: tasks,
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

    return ProjectWithDetails(project: project, milestones: milestones, tasks: tasks);
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
    List<String> milestoneTitles = const [],
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
        updatedAt: Value(now),
      ),
    );

    // Log Activity if status changed
    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('project'),
          entityId: Value(id),
          action: const Value('progressed'),
          summary: Value('Updated project "$name" (Status: $status)'),
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

  Future<void> addMilestone({
    required String projectId,
    required String title,
    String? description,
    DateTime? targetDate,
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
        ));
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
