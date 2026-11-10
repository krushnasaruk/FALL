import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../../core/utils/recurrence_util.dart';

class TaskWithSubtasks {
  final TaskEntry task;
  final List<SubtaskEntry> subtasks;
  final ProjectEntry? project;
  final SkillEntry? skill;

  TaskWithSubtasks({
    required this.task,
    required this.subtasks,
    this.project,
    this.skill,
  });

  bool get isOverdue {
    if (task.isCompleted || task.dueDate == null) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }

  int get completedSubtasksCount =>
      subtasks.where((s) => s.isCompleted).length;
}

class TaskRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  TaskRepository(this._db);

  Stream<List<TaskWithSubtasks>> watchAllTasksWithDetails() {
    return _db.select(_db.tasks).watch().asyncMap((taskList) async {
      final List<TaskWithSubtasks> result = [];
      for (final t in taskList) {
        final subs = await (_db.select(_db.subtasks)
              ..where((s) => s.taskId.equals(t.id))
              ..orderBy([(s) => OrderingTerm(expression: s.orderIndex)]))
            .get();

        ProjectEntry? project;
        if (t.projectId != null) {
          project = await (_db.select(_db.projects)
                ..where((p) => p.id.equals(t.projectId!)))
              .getSingleOrNull();
        }

        SkillEntry? skill;
        if (t.skillId != null) {
          skill = await (_db.select(_db.skills)
                ..where((s) => s.id.equals(t.skillId!)))
              .getSingleOrNull();
        }

        result.add(TaskWithSubtasks(
          task: t,
          subtasks: subs,
          project: project,
          skill: skill,
        ));
      }
      return result;
    });
  }

  Future<TaskWithSubtasks?> getTaskById(String id) async {
    final t = await (_db.select(_db.tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (t == null) return null;

    final subs = await (_db.select(_db.subtasks)
          ..where((s) => s.taskId.equals(t.id))
          ..orderBy([(s) => OrderingTerm(expression: s.orderIndex)]))
        .get();

    ProjectEntry? project;
    if (t.projectId != null) {
      project = await (_db.select(_db.projects)..where((p) => p.id.equals(t.projectId!))).getSingleOrNull();
    }

    SkillEntry? skill;
    if (t.skillId != null) {
      skill = await (_db.select(_db.skills)..where((s) => s.id.equals(t.skillId!))).getSingleOrNull();
    }

    return TaskWithSubtasks(task: t, subtasks: subs, project: project, skill: skill);
  }

  Future<TaskEntry> createTask({
    required String title,
    String? description,
    String priority = 'medium',
    DateTime? dueDate,
    bool hasDueTime = false,
    DateTime? reminderAt,
    String? projectId,
    String? skillId,
    int estimatedMinutes = 0,
    String recurrence = 'none',
    String tags = '',
    List<String> subtaskTitles = const [],
  }) async {
    final now = DateTime.now();
    final taskId = _uuid.v4();

    final taskCompanion = TasksCompanion(
      id: Value(taskId),
      title: Value(title.trim()),
      description: Value(description?.trim()),
      priority: Value(priority),
      dueDate: Value(dueDate),
      hasDueTime: Value(hasDueTime),
      reminderAt: Value(reminderAt),
      projectId: Value(projectId),
      skillId: Value(skillId),
      estimatedMinutes: Value(estimatedMinutes),
      actualMinutes: const Value(0),
      recurrence: Value(recurrence),
      tags: Value(tags.trim()),
      isCompleted: const Value(false),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _db.into(_db.tasks).insert(taskCompanion);

    // Insert subtasks
    for (int i = 0; i < subtaskTitles.length; i++) {
      if (subtaskTitles[i].trim().isNotEmpty) {
        await _db.into(_db.subtasks).insert(SubtasksCompanion(
              id: Value(_uuid.v4()),
              taskId: Value(taskId),
              title: Value(subtaskTitles[i].trim()),
              isCompleted: const Value(false),
              orderIndex: Value(i),
              createdAt: Value(now),
            ));
      }
    }

    // Log Activity
    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('task'),
          entityId: Value(taskId),
          action: const Value('created'),
          summary: Value('Created task "$title"'),
          createdAt: Value(now),
        ));

    return (await (_db.select(_db.tasks)..where((t) => t.id.equals(taskId))).getSingle());
  }

  Future<void> updateTask({
    required String id,
    required String title,
    String? description,
    required String priority,
    DateTime? dueDate,
    bool hasDueTime = false,
    DateTime? reminderAt,
    String? projectId,
    String? skillId,
    int? estimatedMinutes,
    int? actualMinutes,
    String? recurrence,
    String? tags,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        title: Value(title.trim()),
        description: Value(description?.trim()),
        priority: Value(priority),
        dueDate: Value(dueDate),
        hasDueTime: Value(hasDueTime),
        reminderAt: Value(reminderAt),
        projectId: Value(projectId),
        skillId: Value(skillId),
        estimatedMinutes: estimatedMinutes != null ? Value(estimatedMinutes) : const Value.absent(),
        actualMinutes: actualMinutes != null ? Value(actualMinutes) : const Value.absent(),
        recurrence: recurrence != null ? Value(recurrence) : const Value.absent(),
        tags: tags != null ? Value(tags.trim()) : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    final now = DateTime.now();
    final task = await (_db.select(_db.tasks)..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (task == null) return;

    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? now : null),
        updatedAt: Value(now),
      ),
    );

    // If completed and task has recurrence, spawn next recurring task
    if (isCompleted && task.recurrence != 'none' && task.dueDate != null) {
      final nextDueDate = RecurrenceUtil.getNextDueDate(task.dueDate!, task.recurrence);
      if (nextDueDate != null) {
        await createTask(
          title: task.title,
          description: task.description,
          priority: task.priority,
          dueDate: nextDueDate,
          hasDueTime: task.hasDueTime,
          reminderAt: task.reminderAt != null
              ? nextDueDate.subtract(task.dueDate!.difference(task.reminderAt!))
              : null,
          projectId: task.projectId,
          skillId: task.skillId,
          estimatedMinutes: task.estimatedMinutes,
          recurrence: task.recurrence,
          tags: task.tags,
        );
      }
    }

    // Log Activity
    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('task'),
          entityId: Value(taskId),
          action: Value(isCompleted ? 'completed' : 'reopened'),
          summary: Value('${isCompleted ? "Completed" : "Reopened"} task "${task.title}"'),
          createdAt: Value(now),
        ));
  }

  Future<void> deleteTask(String id) async {
    final task = await (_db.select(_db.tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();

    if (task != null) {
      await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
            id: Value(_uuid.v4()),
            entityType: const Value('task'),
            entityId: Value(id),
            action: const Value('deleted'),
            summary: Value('Deleted task "${task.title}"'),
            createdAt: Value(DateTime.now()),
          ));
    }
  }

  Future<void> addSubtask(String taskId, String title) async {
    final now = DateTime.now();
    final count = await (_db.select(_db.subtasks)..where((s) => s.taskId.equals(taskId))).get();
    await _db.into(_db.subtasks).insert(SubtasksCompanion(
          id: Value(_uuid.v4()),
          taskId: Value(taskId),
          title: Value(title.trim()),
          isCompleted: const Value(false),
          orderIndex: Value(count.length),
          createdAt: Value(now),
        ));
  }

  Future<void> toggleSubtaskCompletion(String subtaskId, bool isCompleted) async {
    await (_db.update(_db.subtasks)..where((s) => s.id.equals(subtaskId))).write(
      SubtasksCompanion(
        isCompleted: Value(isCompleted),
      ),
    );
  }

  Future<void> deleteSubtask(String subtaskId) async {
    await (_db.delete(_db.subtasks)..where((s) => s.id.equals(subtaskId))).go();
  }

  Future<void> addActualTime(String taskId, int minutes) async {
    final task = await (_db.select(_db.tasks)..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (task == null) return;
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        actualMinutes: Value(task.actualMinutes + minutes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<TaskEntry?> duplicateTask(String taskId) async {
    final taskData = await getTaskById(taskId);
    if (taskData == null) return null;

    final cloned = await createTask(
      title: '${taskData.task.title} (Copy)',
      description: taskData.task.description,
      priority: taskData.task.priority,
      dueDate: taskData.task.dueDate,
      hasDueTime: taskData.task.hasDueTime,
      reminderAt: taskData.task.reminderAt,
      projectId: taskData.task.projectId,
      skillId: taskData.task.skillId,
      estimatedMinutes: taskData.task.estimatedMinutes,
      recurrence: taskData.task.recurrence,
      tags: taskData.task.tags,
      subtaskTitles: taskData.subtasks.map((s) => s.title).toList(),
    );
    return cloned;
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TaskRepository(db);
});

final allTasksStreamProvider = StreamProvider<List<TaskWithSubtasks>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.watchAllTasksWithDetails();
});

