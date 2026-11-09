import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../data/database/app_database.dart';
import '../data/database/database_provider.dart';

class WidgetSyncService {
  final AppDatabase _db;

  WidgetSyncService(this._db);

  /// Synchronizes all native Android home screen widgets with current local database state
  Future<void> syncAllWidgets() async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      // 1. Query today's tasks
      final allTasks = await _db.select(_db.tasks).get();
      final todayTasks = allTasks.where((t) {
        if (t.dueDate == null) return false;
        return t.dueDate!.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
            t.dueDate!.isBefore(todayEnd);
      }).toList();

      final completedToday = todayTasks.where((t) => t.isCompleted).length;
      final remainingToday = todayTasks.length - completedToday;
      final completionRate = todayTasks.isNotEmpty ? (completedToday / todayTasks.length) : 0.0;

      // 2. Query streak
      final habits = await _db.select(_db.habits).get();
      final habitEntries = await _db.select(_db.habitEntries).get();
      int maxStreak = 0;
      for (final h in habits) {
        final entries = habitEntries.where((e) => e.habitId == h.id && e.isCompleted).toList();
        final streak = _calculateHabitStreak(entries);
        if (streak > maxStreak) maxStreak = streak;
      }

      // 3. Query total learning hours
      final skills = await _db.select(_db.skills).get();
      int totalLearningMinutes = 0;
      for (final s in skills) {
        totalLearningMinutes += s.learningMinutes;
      }
      final learningHours = (totalLearningMinutes / 60.0).toStringAsFixed(1);

      // 4. Query active project
      final projects = await _db.select(_db.projects).get();
      final activeProjects = projects.where((p) => p.status == 'active').toList();
      String projectName = 'No active project';
      String nextMilestone = 'No pending milestone';
      int projectProgress = 0;

      if (activeProjects.isNotEmpty) {
        final currentProj = activeProjects.first;
        projectName = currentProj.name;
        final milestones = await (_db.select(_db.milestones)
              ..where((m) => m.projectId.equals(currentProj.id)))
            .get();
        final completedMilestones = milestones.where((m) => m.isCompleted).length;
        if (milestones.isNotEmpty) {
          projectProgress = ((completedMilestones / milestones.length) * 100).toInt();
          final pending = milestones.where((m) => !m.isCompleted).toList();
          if (pending.isNotEmpty) {
            nextMilestone = pending.first.title;
          } else {
            nextMilestone = 'All milestones completed!';
          }
        }
      }

      // Save key-values to native SharedPreferences via HomeWidget
      await HomeWidget.saveWidgetData<String>('today_date_str', DateFormat('EEEE, MMM d').format(now));
      await HomeWidget.saveWidgetData<int>('daily_completion_rate', (completionRate * 100).toInt());
      await HomeWidget.saveWidgetData<int>('completed_tasks_count', completedToday);
      await HomeWidget.saveWidgetData<int>('remaining_tasks_count', remainingToday);

      // Today's top tasks
      final topTasks = todayTasks.take(3).toList();
      for (int i = 0; i < 3; i++) {
        if (i < topTasks.length) {
          final t = topTasks[i];
          final timeStr = t.dueDate != null ? DateFormat('h:mm a').format(t.dueDate!) : '';
          await HomeWidget.saveWidgetData<String>('task_${i + 1}_title', t.title);
          await HomeWidget.saveWidgetData<String>('task_${i + 1}_priority', t.priority.toUpperCase());
          await HomeWidget.saveWidgetData<String>('task_${i + 1}_time', timeStr);
          await HomeWidget.saveWidgetData<bool>('task_${i + 1}_completed', t.isCompleted);
        } else {
          await HomeWidget.saveWidgetData<String>('task_${i + 1}_title', '');
          await HomeWidget.saveWidgetData<String>('task_${i + 1}_priority', '');
          await HomeWidget.saveWidgetData<String>('task_${i + 1}_time', '');
          await HomeWidget.saveWidgetData<bool>('task_${i + 1}_completed', false);
        }
      }

      // Streak & Skills
      await HomeWidget.saveWidgetData<int>('streak_days', maxStreak);
      await HomeWidget.saveWidgetData<String>('learning_hours', learningHours);

      // Active Project
      await HomeWidget.saveWidgetData<String>('project_name', projectName);
      await HomeWidget.saveWidgetData<int>('project_progress', projectProgress);
      await HomeWidget.saveWidgetData<String>('next_milestone', nextMilestone);

      // Update Native Widgets
      await HomeWidget.updateWidget(
        name: 'ProgressDailyWidgetProvider',
        androidName: 'ProgressDailyWidgetProvider',
      );
      await HomeWidget.updateWidget(
        name: 'ProgressTasksWidgetProvider',
        androidName: 'ProgressTasksWidgetProvider',
      );
      await HomeWidget.updateWidget(
        name: 'ProgressStreakWidgetProvider',
        androidName: 'ProgressStreakWidgetProvider',
      );
      await HomeWidget.updateWidget(
        name: 'ProgressProjectWidgetProvider',
        androidName: 'ProgressProjectWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing widgets: $e');
    }
  }

  int _calculateHabitStreak(List<HabitDailyLog> entries) {
    if (entries.isEmpty) return 0;
    final sortedDates = entries
        .map((e) => DateTime.parse(e.dateStr))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (sortedDates.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

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
        continue;
      } else {
        break;
      }
    }
    return streak;
  }
}

final widgetSyncServiceProvider = Provider<WidgetSyncService>((ref) {
  final db = ref.watch(databaseProvider);
  return WidgetSyncService(db);
});

