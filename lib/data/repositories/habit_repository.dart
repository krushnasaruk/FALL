import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class HabitWithEntries {
  final HabitEntryRecord habit;
  final List<HabitDailyLog> entries;

  HabitWithEntries({required this.habit, required this.entries});

  bool get isCompletedToday {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return entries.any((e) => e.dateStr == todayStr && e.isCompleted);
  }

  /// Calculates the continuous streak up to today or yesterday
  int get currentStreak {
    if (entries.isEmpty) return 0;

    final sortedDates = entries
        .where((e) => e.isCompleted)
        .map((e) => DateTime.parse(e.dateStr))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (sortedDates.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Must be completed today or yesterday to maintain an active streak
    final latest = DateTime(sortedDates.first.year, sortedDates.first.month, sortedDates.first.day);
    if (!latest.isAtSameMomentAs(today) && !latest.isAtSameMomentAs(yesterday)) {
      return 0;
    }

    int streak = 1;
    DateTime current = latest;

    for (int i = 1; i < sortedDates.length; i++) {
      final prevDay = current.subtract(const Duration(days: 1));
      final check = DateTime(sortedDates[i].year, sortedDates[i].month, sortedDates[i].day);

      if (check.isAtSameMomentAs(prevDay)) {
        streak++;
        current = prevDay;
      } else if (check.isAtSameMomentAs(current)) {
        // duplicate entry, ignore
        continue;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Returns check-in status for the past 7 days (including today)
  List<bool> get last7DaysActivity {
    final now = DateTime.now();
    final List<bool> result = [];
    final completedDateStrings = entries.where((e) => e.isCompleted).map((e) => e.dateStr).toSet();

    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final str = DateFormat('yyyy-MM-dd').format(d);
      result.add(completedDateStrings.contains(str));
    }
    return result;
  }
}

class HabitAndGoalRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  HabitAndGoalRepository(this._db);

  // Habits
  Stream<List<HabitWithEntries>> watchHabitsWithEntries() {
    return _db.select(_db.habits).watch().asyncMap((habits) async {
      final List<HabitWithEntries> result = [];
      for (final h in habits) {
        final entries = await (_db.select(_db.habitEntries)
              ..where((e) => e.habitId.equals(h.id))
              ..orderBy([(e) => OrderingTerm(expression: e.dateStr, mode: OrderingMode.desc)]))
            .get();
        result.add(HabitWithEntries(habit: h, entries: entries));
      }
      return result;
    });
  }

  Future<void> createHabit({
    required String title,
    String? description,
    String frequency = 'daily',
    int targetDaysPerWeek = 7,
    String? reminderTime,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.habits).insert(HabitsCompanion(
          id: Value(id),
          title: Value(title.trim()),
          description: Value(description?.trim()),
          frequency: Value(frequency),
          targetDaysPerWeek: Value(targetDaysPerWeek),
          reminderTime: Value(reminderTime),
          createdAt: Value(DateTime.now()),
        ));
  }

  Future<void> toggleHabitCheckIn(String habitId, DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final existing = await (_db.select(_db.habitEntries)
          ..where((e) => e.habitId.equals(habitId) & e.dateStr.equals(dateStr)))
        .getSingleOrNull();

    if (existing != null) {
      // Toggle or delete
      if (existing.isCompleted) {
        await (_db.delete(_db.habitEntries)..where((e) => e.id.equals(existing.id))).go();
      } else {
        await (_db.update(_db.habitEntries)..where((e) => e.id.equals(existing.id))).write(
          const HabitEntriesCompanion(isCompleted: Value(true)),
        );
      }
    } else {
      // Insert new completed check-in
      await _db.into(_db.habitEntries).insert(HabitEntriesCompanion(
            id: Value(_uuid.v4()),
            habitId: Value(habitId),
            dateStr: Value(dateStr),
            isCompleted: const Value(true),
            createdAt: Value(DateTime.now()),
          ));
    }
  }

  Future<void> deleteHabit(String id) async {
    await (_db.delete(_db.habits)..where((h) => h.id.equals(id))).go();
  }

  // Goals
  Stream<List<GoalEntry>> watchAllGoals() {
    return (_db.select(_db.goals)
          ..orderBy([(g) => OrderingTerm(expression: g.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<void> createGoal({
    required String title,
    String? description,
    String type = 'daily',
    required double targetValue,
    double currentValue = 0.0,
    String unit = 'hrs',
    DateTime? deadline,
  }) async {
    await _db.into(_db.goals).insert(GoalsCompanion(
          id: Value(_uuid.v4()),
          title: Value(title.trim()),
          description: Value(description?.trim()),
          type: Value(type),
          targetValue: Value(targetValue),
          currentValue: Value(currentValue),
          unit: Value(unit),
          deadline: Value(deadline),
          isAchieved: Value(currentValue >= targetValue),
          createdAt: Value(DateTime.now()),
        ));
  }

  Future<void> updateGoalProgress(String id, double delta) async {
    final goal = await (_db.select(_db.goals)..where((g) => g.id.equals(id))).getSingleOrNull();
    if (goal == null) return;

    final newVal = (goal.currentValue + delta).clamp(0.0, double.infinity);
    final achieved = newVal >= goal.targetValue;

    await (_db.update(_db.goals)..where((g) => g.id.equals(id))).write(
      GoalsCompanion(
        currentValue: Value(newVal),
        isAchieved: Value(achieved),
      ),
    );
  }

  Future<void> deleteGoal(String id) async {
    await (_db.delete(_db.goals)..where((g) => g.id.equals(id))).go();
  }
}

final habitRepositoryProvider = Provider<HabitAndGoalRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return HabitAndGoalRepository(db);
});

final allHabitsStreamProvider = StreamProvider<List<HabitWithEntries>>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return repo.watchHabitsWithEntries();
});

final allGoalsStreamProvider = StreamProvider<List<GoalEntry>>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return repo.watchAllGoals();
});
