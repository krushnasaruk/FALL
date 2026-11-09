import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class FocusSessionWithDetails {
  final FocusSessionEntry session;
  final TaskEntry? task;
  final ProjectEntry? project;
  final SkillEntry? skill;

  FocusSessionWithDetails({
    required this.session,
    this.task,
    this.project,
    this.skill,
  });
}

class FocusRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  FocusRepository(this._db);

  Stream<List<FocusSessionWithDetails>> watchRecentSessions({int limit = 30}) {
    return (_db.select(_db.focusSessions)
          ..orderBy([(f) => OrderingTerm(expression: f.completedAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch()
        .asyncMap((sessions) async {
      final List<FocusSessionWithDetails> result = [];
      for (final s in sessions) {
        TaskEntry? task;
        if (s.taskId != null) {
          task = await (_db.select(_db.tasks)..where((t) => t.id.equals(s.taskId!))).getSingleOrNull();
        }

        ProjectEntry? project;
        if (s.projectId != null) {
          project = await (_db.select(_db.projects)..where((p) => p.id.equals(s.projectId!))).getSingleOrNull();
        }

        SkillEntry? skill;
        if (s.skillId != null) {
          skill = await (_db.select(_db.skills)..where((sk) => sk.id.equals(s.skillId!))).getSingleOrNull();
        }

        result.add(FocusSessionWithDetails(
          session: s,
          task: task,
          project: project,
          skill: skill,
        ));
      }
      return result;
    });
  }

  Future<void> recordFocusSession({
    String? taskId,
    String? projectId,
    String? skillId,
    required int durationMinutes,
    String sessionType = 'pomodoro',
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    await _db.into(_db.focusSessions).insert(FocusSessionsCompanion(
          id: Value(id),
          taskId: Value(taskId),
          projectId: Value(projectId),
          skillId: Value(skillId),
          durationMinutes: Value(durationMinutes),
          sessionType: Value(sessionType),
          completedAt: Value(now),
        ));

    // Update associated task if any
    if (taskId != null) {
      final t = await (_db.select(_db.tasks)..where((entry) => entry.id.equals(taskId))).getSingleOrNull();
      if (t != null) {
        await (_db.update(_db.tasks)..where((entry) => entry.id.equals(taskId))).write(
          TasksCompanion(
            actualMinutes: Value(t.actualMinutes + durationMinutes),
            updatedAt: Value(now),
          ),
        );
      }
    }

    // Update associated project if any
    if (projectId != null) {
      final p = await (_db.select(_db.projects)..where((entry) => entry.id.equals(projectId))).getSingleOrNull();
      if (p != null) {
        await (_db.update(_db.projects)..where((entry) => entry.id.equals(projectId))).write(
          ProjectsCompanion(
            timeSpentMinutes: Value(p.timeSpentMinutes + durationMinutes),
            updatedAt: Value(now),
          ),
        );
      }
    }

    // Update associated skill if any
    if (skillId != null) {
      final sk = await (_db.select(_db.skills)..where((entry) => entry.id.equals(skillId))).getSingleOrNull();
      if (sk != null) {
        await (_db.update(_db.skills)..where((entry) => entry.id.equals(skillId))).write(
          SkillsCompanion(
            learningMinutes: Value(sk.learningMinutes + durationMinutes),
            updatedAt: Value(now),
          ),
        );
      }
    }

    // Activity log
    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('focus'),
          entityId: Value(id),
          action: const Value('completed'),
          summary: Value('Completed ${durationMinutes}m focus session'),
          createdAt: Value(now),
        ));
  }
}

final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FocusRepository(db);
});

final recentFocusSessionsProvider = StreamProvider<List<FocusSessionWithDetails>>((ref) {
  final repo = ref.watch(focusRepositoryProvider);
  return repo.watchRecentSessions();
});

