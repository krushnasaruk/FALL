import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class ModuleWithTopics {
  final LearningModuleEntry module;
  final List<LearningTopicEntry> topics;

  ModuleWithTopics({required this.module, required this.topics});

  int get completedCount => topics.where((t) => t.status == 'completed').length;
  int get totalCount => topics.length;
}

class SkillWithRoadmap {
  final SkillEntry skill;
  final List<ModuleWithTopics> modules;
  final List<LearningSessionEntry> sessions;
  final List<FocusSessionEntry> focusSessions;

  SkillWithRoadmap({
    required this.skill,
    required this.modules,
    required this.sessions,
    this.focusSessions = const [],
  });

  int get totalTopics {
    int count = 0;
    for (final m in modules) {
      count += m.topics.length;
    }
    return count;
  }

  int get completedTopics {
    int count = 0;
    for (final m in modules) {
      count += m.completedCount;
    }
    return count;
  }

  /// Curriculum / topic-based progress: completedTopics / totalTopics
  double get curriculumProgress {
    if (totalTopics == 0) return 0.0;
    return (completedTopics / totalTopics).clamp(0.0, 1.0);
  }

  bool get hasTimeTarget => skill.targetMinutes > 0;

  /// Time progress against targetMinutes (null if no time target configured)
  double? get timeProgressPercentage {
    if (skill.targetMinutes <= 0) return null;
    return skill.learningMinutes / skill.targetMinutes;
  }

  bool get isTimeTargetExceeded =>
      skill.targetMinutes > 0 && skill.learningMinutes > skill.targetMinutes;

  /// Primary progress based on skill.progressMethod:
  /// - 'topics': curriculumProgress
  /// - 'time': timeProgressPercentage clamped to 1.0 (or 0.0 if no target)
  /// - 'manual': skill.manualProgressPercentage
  double get primaryProgress {
    switch (skill.progressMethod) {
      case 'time':
        if (!hasTimeTarget) return 0.0;
        return (timeProgressPercentage ?? 0.0).clamp(0.0, 1.0);
      case 'manual':
        return skill.manualProgressPercentage.clamp(0.0, 1.0);
      case 'topics':
      default:
        return curriculumProgress;
    }
  }

  /// Backward-compatible getter
  double get progressPercentage => primaryProgress;
}

class LearningRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  LearningRepository(this._db);

  Stream<List<SkillWithRoadmap>> watchAllSkillsWithRoadmaps() {
    return _db.select(_db.skills).watch().asyncMap((skills) async {
      final List<SkillWithRoadmap> result = [];
      for (final s in skills) {
        final modules = await (_db.select(_db.learningModules)
              ..where((m) => m.skillId.equals(s.id))
              ..orderBy([(m) => OrderingTerm(expression: m.orderIndex)]))
            .get();

        final List<ModuleWithTopics> moduleList = [];
        for (final m in modules) {
          final topics = await (_db.select(_db.learningTopics)
                ..where((t) => t.moduleId.equals(m.id))
                ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
              .get();
          moduleList.add(ModuleWithTopics(module: m, topics: topics));
        }

        final sessions = await (_db.select(_db.learningSessions)
              ..where((sess) => sess.skillId.equals(s.id))
              ..orderBy([(sess) => OrderingTerm(expression: sess.createdAt, mode: OrderingMode.desc)]))
            .get();

        final focusSessions = await (_db.select(_db.focusSessions)
              ..where((f) => f.skillId.equals(s.id))
              ..orderBy([(f) => OrderingTerm(expression: f.completedAt, mode: OrderingMode.desc)]))
            .get();

        result.add(SkillWithRoadmap(
          skill: s,
          modules: moduleList,
          sessions: sessions,
          focusSessions: focusSessions,
        ));
      }
      return result;
    });
  }

  Future<SkillWithRoadmap?> getSkillById(String id) async {
    final skill = await (_db.select(_db.skills)..where((s) => s.id.equals(id))).getSingleOrNull();
    if (skill == null) return null;

    final modules = await (_db.select(_db.learningModules)
          ..where((m) => m.skillId.equals(id))
          ..orderBy([(m) => OrderingTerm(expression: m.orderIndex)]))
        .get();

    final List<ModuleWithTopics> moduleList = [];
    for (final m in modules) {
      final topics = await (_db.select(_db.learningTopics)
            ..where((t) => t.moduleId.equals(m.id))
            ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
          .get();
      moduleList.add(ModuleWithTopics(module: m, topics: topics));
    }

    final sessions = await (_db.select(_db.learningSessions)
          ..where((sess) => sess.skillId.equals(id))
          ..orderBy([(sess) => OrderingTerm(expression: sess.createdAt, mode: OrderingMode.desc)]))
        .get();

    final focusSessions = await (_db.select(_db.focusSessions)
          ..where((f) => f.skillId.equals(id))
          ..orderBy([(f) => OrderingTerm(expression: f.completedAt, mode: OrderingMode.desc)]))
        .get();

    return SkillWithRoadmap(
      skill: skill,
      modules: moduleList,
      sessions: sessions,
      focusSessions: focusSessions,
    );
  }

  Future<SkillEntry> createSkill({
    required String name,
    String category = 'General',
    String currentLevel = 'beginner',
    String targetLevel = 'intermediate',
    String? notes,
    String progressMethod = 'topics',
    int targetMinutes = 0,
    int targetTopicsCount = 0,
    double manualProgressPercentage = 0.0,
  }) async {
    final now = DateTime.now();
    final skillId = _uuid.v4();

    final companion = SkillsCompanion(
      id: Value(skillId),
      name: Value(name.trim()),
      category: Value(category.trim()),
      currentLevel: Value(currentLevel),
      targetLevel: Value(targetLevel),
      notes: Value(notes?.trim()),
      learningMinutes: const Value(0),
      progressMethod: Value(progressMethod),
      targetMinutes: Value(targetMinutes),
      targetTopicsCount: Value(targetTopicsCount),
      manualProgressPercentage: Value(manualProgressPercentage.clamp(0.0, 1.0)),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await _db.into(_db.skills).insert(companion);

    await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
          id: Value(_uuid.v4()),
          entityType: const Value('skill'),
          entityId: Value(skillId),
          action: const Value('created'),
          summary: Value('Added skill "$name"'),
          createdAt: Value(now),
        ));

    return (await (_db.select(_db.skills)..where((s) => s.id.equals(skillId))).getSingle());
  }

  Future<void> updateSkill({
    required String id,
    required String name,
    required String category,
    required String currentLevel,
    required String targetLevel,
    String? notes,
    String? progressMethod,
    int? targetMinutes,
    int? targetTopicsCount,
    double? manualProgressPercentage,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.skills)..where((s) => s.id.equals(id))).write(
      SkillsCompanion(
        name: Value(name.trim()),
        category: Value(category.trim()),
        currentLevel: Value(currentLevel),
        targetLevel: Value(targetLevel),
        notes: Value(notes?.trim()),
        progressMethod: progressMethod != null ? Value(progressMethod) : const Value.absent(),
        targetMinutes: targetMinutes != null ? Value(targetMinutes) : const Value.absent(),
        targetTopicsCount: targetTopicsCount != null ? Value(targetTopicsCount) : const Value.absent(),
        manualProgressPercentage: manualProgressPercentage != null
            ? Value(manualProgressPercentage.clamp(0.0, 1.0))
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> updateSkillTargets({
    required String id,
    required String progressMethod,
    required int targetMinutes,
    int targetTopicsCount = 0,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.skills)..where((s) => s.id.equals(id))).write(
      SkillsCompanion(
        progressMethod: Value(progressMethod),
        targetMinutes: Value(targetMinutes),
        targetTopicsCount: Value(targetTopicsCount),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> updateManualProgress(String skillId, double progress) async {
    final now = DateTime.now();
    await (_db.update(_db.skills)..where((s) => s.id.equals(skillId))).write(
      SkillsCompanion(
        manualProgressPercentage: Value(progress.clamp(0.0, 1.0)),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> deleteSkill(String id) async {
    await (_db.delete(_db.skills)..where((s) => s.id.equals(id))).go();
  }

  Future<void> addModule({
    required String skillId,
    required String title,
    String? description,
  }) async {
    final count = await (_db.select(_db.learningModules)..where((m) => m.skillId.equals(skillId))).get();
    await _db.into(_db.learningModules).insert(LearningModulesCompanion(
          id: Value(_uuid.v4()),
          skillId: Value(skillId),
          title: Value(title.trim()),
          description: Value(description?.trim()),
          orderIndex: Value(count.length),
        ));
  }

  Future<void> deleteModule(String moduleId) async {
    await (_db.delete(_db.learningModules)..where((m) => m.id.equals(moduleId))).go();
  }

  Future<void> addTopic({
    required String moduleId,
    required String title,
    String resources = '',
    String? notes,
  }) async {
    final count = await (_db.select(_db.learningTopics)..where((t) => t.moduleId.equals(moduleId))).get();
    await _db.into(_db.learningTopics).insert(LearningTopicsCompanion(
          id: Value(_uuid.v4()),
          moduleId: Value(moduleId),
          title: Value(title.trim()),
          status: const Value('planned'),
          resources: Value(resources.trim()),
          notes: Value(notes?.trim()),
          orderIndex: Value(count.length),
        ));
  }

  Future<void> updateTopicStatus(String topicId, String status) async {
    final now = DateTime.now();
    await (_db.update(_db.learningTopics)..where((t) => t.id.equals(topicId))).write(
      LearningTopicsCompanion(
        status: Value(status),
        completedAt: Value(status == 'completed' ? now : null),
      ),
    );
  }

  Future<void> updateTopic({
    required String id,
    required String title,
    String resources = '',
    String? notes,
    required String status,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.learningTopics)..where((t) => t.id.equals(id))).write(
      LearningTopicsCompanion(
        title: Value(title.trim()),
        resources: Value(resources.trim()),
        notes: Value(notes?.trim()),
        status: Value(status),
        completedAt: Value(status == 'completed' ? now : null),
      ),
    );
  }

  Future<void> deleteTopic(String topicId) async {
    await (_db.delete(_db.learningTopics)..where((t) => t.id.equals(topicId))).go();
  }

  Future<void> logLearningSession({
    required String skillId,
    String? topicId,
    required int durationMinutes,
    String? notes,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    // 1. Record in learningSessions
    await _db.into(_db.learningSessions).insert(LearningSessionsCompanion(
          id: Value(id),
          skillId: Value(skillId),
          topicId: Value(topicId),
          durationMinutes: Value(durationMinutes),
          notes: Value(notes?.trim()),
          createdAt: Value(now),
        ));

    // 2. Also record in focusSessions so global focus totals and calendar capture this study time
    await _db.into(_db.focusSessions).insert(FocusSessionsCompanion(
          id: Value(_uuid.v4()),
          skillId: Value(skillId),
          durationMinutes: Value(durationMinutes),
          sessionType: const Value('study'),
          completedAt: Value(now),
          notes: Value(notes?.trim()),
        ));

    // 3. Update skill total minutes
    final skill = await (_db.select(_db.skills)..where((s) => s.id.equals(skillId))).getSingleOrNull();
    if (skill != null) {
      await (_db.update(_db.skills)..where((s) => s.id.equals(skillId))).write(
        SkillsCompanion(
          learningMinutes: Value(skill.learningMinutes + durationMinutes),
          updatedAt: Value(now),
        ),
      );

      await _db.into(_db.activityHistory).insert(ActivityHistoryCompanion(
            id: Value(_uuid.v4()),
            entityType: const Value('skill'),
            entityId: Value(skillId),
            action: const Value('logged'),
            summary: Value('Logged ${durationMinutes}m learning "${skill.name}"'),
            createdAt: Value(now),
          ));
    }
  }
}

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LearningRepository(db);
});

final allSkillsStreamProvider = StreamProvider<List<SkillWithRoadmap>>((ref) {
  final repo = ref.watch(learningRepositoryProvider);
  return repo.watchAllSkillsWithRoadmaps();
});
