import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class AchievementDefinition {
  final String id;
  final String category;
  final String title;
  final String description;
  final String badgeAsset;

  const AchievementDefinition({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.badgeAsset,
  });
}

class XpAwardResult {
  final int xpAdded;
  final List<AchievementDefinition> newlyUnlocked;

  const XpAwardResult({
    required this.xpAdded,
    required this.newlyUnlocked,
  });
}

/// Auditable XP ledger & unlockable Achievements repository.
/// Prevents duplicate XP awards via unique `sourceKey` identifiers stored in SQLite.
class RewardsRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  RewardsRepository(this._db);

  static const int xpTaskCompleted = 15;
  static const int xpHabitCheckIn = 15;
  static const int xpTopicCompleted = 25;
  static const int xpFocusCompleted = 20;
  static const int xpMilestoneCompleted = 30;
  static const int xpGoalAchieved = 50;

  static const List<AchievementDefinition> catalog = [
    AchievementDefinition(
      id: 'first_spark',
      category: 'exploration',
      title: 'First Step',
      description: 'Completed your first task or focus block.',
      badgeAsset: 'assets/images/achievements/badge_exploration.png',
    ),
    AchievementDefinition(
      id: 'task_steady_5',
      category: 'consistency',
      title: 'Steady Pace',
      description: 'Completed 5 tasks cleanly across your workspace.',
      badgeAsset: 'assets/images/achievements/badge_consistency.png',
    ),
    AchievementDefinition(
      id: 'habit_3day',
      category: 'consistency',
      title: '3-Day Rhythm',
      description: 'Kept a daily practice going for 3 days.',
      badgeAsset: 'assets/images/achievements/badge_consistency.png',
    ),
    AchievementDefinition(
      id: 'habit_7day',
      category: 'milestones',
      title: 'Full Week Momentum',
      description: 'Reached a 7-day habit consistency streak.',
      badgeAsset: 'assets/images/achievements/badge_milestones.png',
    ),
    AchievementDefinition(
      id: 'focus_first',
      category: 'focus',
      title: 'Deep Work Initiated',
      description: 'Completed your first timed focus session.',
      badgeAsset: 'assets/images/achievements/badge_focus.png',
    ),
    AchievementDefinition(
      id: 'focus_120m',
      category: 'focus',
      title: 'Calm Concentration',
      description: 'Recorded 2 hours of genuine focused work.',
      badgeAsset: 'assets/images/achievements/badge_focus.png',
    ),
    AchievementDefinition(
      id: 'learning_topic_1',
      category: 'learning',
      title: 'Curious Mind',
      description: 'Completed a topic on your learning roadmap.',
      badgeAsset: 'assets/images/achievements/badge_learning.png',
    ),
    AchievementDefinition(
      id: 'project_milestone_1',
      category: 'projects',
      title: "Builder's Mark",
      description: 'Completed a milestone on one of your projects.',
      badgeAsset: 'assets/images/achievements/badge_projects.png',
    ),
  ];

  static AchievementDefinition? findById(String id) {
    for (final a in catalog) {
      if (a.id == id) return a;
    }
    return null;
  }

  /// Computes a gentle, human level progression (`100 XP` per level cleanly).
  static int levelForXp(int totalXp) => (totalXp ~/ 100) + 1;
  static double levelProgress(int totalXp) => (totalXp % 100) / 100.0;

  /// Records XP only if `sourceKey` has never been awarded before (prevents farming).
  Future<XpAwardResult> recordActivityAndEvaluate({
    required String sourceKey,
    required String sourceType,
    required int amount,
    required String summary,
  }) async {
    int xpAdded = 0;

    if (amount > 0) {
      await _db.transaction(() async {
        final existing = await (_db.select(_db.xpEvents)
              ..where((e) => e.sourceKey.equals(sourceKey)))
            .getSingleOrNull();
        if (existing == null) {
          await _db.into(_db.xpEvents).insert(
                XpEventsCompanion(
                  id: Value(_uuid.v4()),
                  sourceKey: Value(sourceKey),
                  sourceType: Value(sourceType),
                  amount: Value(amount),
                  summary: Value(summary.trim().isEmpty ? sourceType : summary.trim()),
                  createdAt: Value(DateTime.now()),
                ),
              );
          xpAdded = amount;
        }
      });
    }

    final newlyUnlocked = await evaluateAndUnlockAchievements();
    return XpAwardResult(xpAdded: xpAdded, newlyUnlocked: newlyUnlocked);
  }

  /// Evaluates real SQLite activity and records any newly qualified Achievements once.
  Future<List<AchievementDefinition>> evaluateAndUnlockAchievements() async {
    final alreadyUnlocked =
        (await _db.select(_db.unlockedAchievements).get()).map((e) => e.id).toSet();

    final completedTasks = await (_db.select(_db.tasks)
          ..where((t) => t.isCompleted.equals(true)))
        .get();
    final focusSessions = await _db.select(_db.focusSessions).get();
    final totalFocusMinutes = focusSessions.fold<int>(0, (acc, s) => acc + s.durationMinutes);
    final completedTopics = await (_db.select(_db.learningTopics)
          ..where((t) => t.status.equals('completed')))
        .get();
    final completedMilestones = await (_db.select(_db.milestones)
          ..where((m) => m.isCompleted.equals(true)))
        .get();

    // Calculate max streak across habits using local calendar days
    final habits = await _db.select(_db.habits).get();
    final habitLogs = await _db.select(_db.habitEntries).get();
    int bestHabitStreak = 0;
    for (final h in habits) {
      final logs = habitLogs.where((e) => e.habitId == h.id && e.isCompleted).toList();
      final streak = _calculateStreak(logs);
      if (streak > bestHabitStreak) bestHabitStreak = streak;
    }

    final qualifies = <String, bool>{
      'first_spark': completedTasks.isNotEmpty || focusSessions.isNotEmpty,
      'task_steady_5': completedTasks.length >= 5,
      'habit_3day': bestHabitStreak >= 3,
      'habit_7day': bestHabitStreak >= 7,
      'focus_first': focusSessions.isNotEmpty,
      'focus_120m': totalFocusMinutes >= 120,
      'learning_topic_1': completedTopics.isNotEmpty,
      'project_milestone_1': completedMilestones.isNotEmpty,
    };

    final List<AchievementDefinition> unlockedNow = [];
    for (final def in catalog) {
      if (!alreadyUnlocked.contains(def.id) && (qualifies[def.id] ?? false)) {
        await _db.into(_db.unlockedAchievements).insert(
              UnlockedAchievementsCompanion(
                id: Value(def.id),
                category: Value(def.category),
                title: Value(def.title),
                description: Value(def.description),
                unlockedAt: Value(DateTime.now()),
              ),
              mode: InsertMode.insertOrIgnore,
            );
        unlockedNow.add(def);
      }
    }
    return unlockedNow;
  }

  Stream<int> watchTotalXp() {
    return _db.select(_db.xpEvents).watch().map(
          (rows) => rows.fold<int>(0, (sum, row) => sum + row.amount),
        );
  }

  Stream<List<XpEventEntry>> watchRecentXpEvents({int limit = 25}) {
    return (_db.select(_db.xpEvents)
          ..orderBy([(e) => OrderingTerm(expression: e.createdAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  Stream<List<UnlockedAchievementEntry>> watchUnlockedAchievements() {
    return (_db.select(_db.unlockedAchievements)
          ..orderBy([(a) => OrderingTerm(expression: a.unlockedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  static int _calculateStreak(List<HabitDailyLog> entries) {
    if (entries.isEmpty) return 0;
    final sorted = entries
        .where((e) => e.isCompleted)
        .map((e) => DateTime.parse(e.dateStr))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    if (sorted.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final latest = DateTime(sorted.first.year, sorted.first.month, sorted.first.day);
    if (!latest.isAtSameMomentAs(today) && !latest.isAtSameMomentAs(yesterday)) {
      return 0;
    }

    int streak = 1;
    var current = latest;
    for (int i = 1; i < sorted.length; i++) {
      final prevDay = current.subtract(const Duration(days: 1));
      final check = DateTime(sorted[i].year, sorted[i].month, sorted[i].day);
      if (check.isAtSameMomentAs(prevDay)) {
        streak++;
        current = prevDay;
      }
    }
    return streak;
  }

  /// Computes a respectful, forgiving habit summary string when checking streak continuity.
  static String streakSupportMessage({
    required int currentStreak,
    required bool isCompletedToday,
    required List<HabitDailyLog> entries,
  }) {
    if (isCompletedToday && currentStreak > 0) {
      return currentStreak == 1
          ? 'Checked in today. Good start.'
          : '$currentStreak days in a row. Calm consistency.';
    }
    if (!isCompletedToday && currentStreak > 0) {
      return 'Your $currentStreak-day streak is waiting whenever you are ready.';
    }
    if (entries.isNotEmpty) {
      final yesterdayStr = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      final doneYesterday = entries.any((e) => e.dateStr == yesterdayStr && e.isCompleted);
      if (!doneYesterday) {
        return 'Yesterday was a break. Start again whenever you\'re ready.';
      }
    }
    return 'Small daily steps build lasting momentum.';
  }
}

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return RewardsRepository(db);
});

final totalXpStreamProvider = StreamProvider<int>((ref) {
  return ref.watch(rewardsRepositoryProvider).watchTotalXp();
});

final recentXpEventsProvider = StreamProvider<List<XpEventEntry>>((ref) {
  return ref.watch(rewardsRepositoryProvider).watchRecentXpEvents();
});

final unlockedAchievementsProvider = StreamProvider<List<UnlockedAchievementEntry>>((ref) {
  return ref.watch(rewardsRepositoryProvider).watchUnlockedAchievements();
});

