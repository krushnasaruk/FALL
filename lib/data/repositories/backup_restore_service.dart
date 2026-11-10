import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class BackupRestoreService {
  final AppDatabase _db;

  BackupRestoreService(this._db);

  /// Exports the entire SQLite database into a JSON string
  Future<String> exportToJson() async {
    final tasks = await _db.select(_db.tasks).get();
    final subtasks = await _db.select(_db.subtasks).get();
    final projects = await _db.select(_db.projects).get();
    final milestones = await _db.select(_db.milestones).get();
    final skills = await _db.select(_db.skills).get();
    final modules = await _db.select(_db.learningModules).get();
    final topics = await _db.select(_db.learningTopics).get();
    final sessions = await _db.select(_db.learningSessions).get();
    final goals = await _db.select(_db.goals).get();
    final habits = await _db.select(_db.habits).get();
    final habitEntries = await _db.select(_db.habitEntries).get();
    final focusSessions = await _db.select(_db.focusSessions).get();
    final notes = await _db.select(_db.notes).get();
    final activities = await _db.select(_db.activityHistory).get();
    final xpEvents = await _db.select(_db.xpEvents).get();
    final unlockedAchievements = await _db.select(_db.unlockedAchievements).get();

    final data = {
      'version': 2,
      'exported_at': DateTime.now().toIso8601String(),
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'milestones': milestones.map((m) => m.toJson()).toList(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'learning_modules': modules.map((m) => m.toJson()).toList(),
      'learning_topics': topics.map((t) => t.toJson()).toList(),
      'learning_sessions': sessions.map((s) => s.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
      'habits': habits.map((h) => h.toJson()).toList(),
      'habit_entries': habitEntries.map((e) => e.toJson()).toList(),
      'focus_sessions': focusSessions.map((f) => f.toJson()).toList(),
      'notes': notes.map((n) => n.toJson()).toList(),
      'activity_history': activities.map((a) => a.toJson()).toList(),
      'xp_events': xpEvents.map((x) => x.toJson()).toList(),
      'unlocked_achievements': unlockedAchievements.map((u) => u.toJson()).toList(),
    };

    return jsonEncode(data);
  }

  /// Exports backup and triggers native share dialog
  Future<String> exportAndShare() async {
    final jsonStr = await exportToJson();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/progress_os_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonStr);

    await Share.shareXFiles([XFile(file.path)], text: 'ProgressOS Complete Backup');
    return file.path;
  }

  /// Restores database state from a backup JSON string
  Future<bool> importFromJson(String jsonContent) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonContent);

      await _db.transaction(() async {
        // Import tasks
        if (data['tasks'] != null) {
          for (final item in (data['tasks'] as List)) {
            final entry = TaskEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.tasks).insertOnConflictUpdate(entry);
          }
        }

        // Subtasks
        if (data['subtasks'] != null) {
          for (final item in (data['subtasks'] as List)) {
            final entry = SubtaskEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.subtasks).insertOnConflictUpdate(entry);
          }
        }

        // Projects
        if (data['projects'] != null) {
          for (final item in (data['projects'] as List)) {
            final entry = ProjectEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.projects).insertOnConflictUpdate(entry);
          }
        }

        // Milestones
        if (data['milestones'] != null) {
          for (final item in (data['milestones'] as List)) {
            final entry = MilestoneEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.milestones).insertOnConflictUpdate(entry);
          }
        }

        // Skills
        if (data['skills'] != null) {
          for (final item in (data['skills'] as List)) {
            final entry = SkillEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.skills).insertOnConflictUpdate(entry);
          }
        }

        // Modules
        if (data['learning_modules'] != null) {
          for (final item in (data['learning_modules'] as List)) {
            final entry = LearningModuleEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.learningModules).insertOnConflictUpdate(entry);
          }
        }

        // Topics
        if (data['learning_topics'] != null) {
          for (final item in (data['learning_topics'] as List)) {
            final entry = LearningTopicEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.learningTopics).insertOnConflictUpdate(entry);
          }
        }

        // Sessions
        if (data['learning_sessions'] != null) {
          for (final item in (data['learning_sessions'] as List)) {
            final entry = LearningSessionEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.learningSessions).insertOnConflictUpdate(entry);
          }
        }

        // Goals
        if (data['goals'] != null) {
          for (final item in (data['goals'] as List)) {
            final entry = GoalEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.goals).insertOnConflictUpdate(entry);
          }
        }

        // Habits
        if (data['habits'] != null) {
          for (final item in (data['habits'] as List)) {
            final entry = HabitEntryRecord.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.habits).insertOnConflictUpdate(entry);
          }
        }

        // Habit Entries
        if (data['habit_entries'] != null) {
          for (final item in (data['habit_entries'] as List)) {
            final entry = HabitDailyLog.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.habitEntries).insertOnConflictUpdate(entry);
          }
        }

        // Focus Sessions
        if (data['focus_sessions'] != null) {
          for (final item in (data['focus_sessions'] as List)) {
            final entry = FocusSessionEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.focusSessions).insertOnConflictUpdate(entry);
          }
        }

        // Notes
        if (data['notes'] != null) {
          for (final item in (data['notes'] as List)) {
            final entry = NoteEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.notes).insertOnConflictUpdate(entry);
          }
        }

        // Activity History
        if (data['activity_history'] != null) {
          for (final item in (data['activity_history'] as List)) {
            final entry = ActivityHistoryEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.activityHistory).insertOnConflictUpdate(entry);
          }
        }

        // XP Events
        if (data['xp_events'] != null) {
          for (final item in (data['xp_events'] as List)) {
            final entry = XpEventEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.xpEvents).insertOnConflictUpdate(entry);
          }
        }

        // Unlocked Achievements
        if (data['unlocked_achievements'] != null) {
          for (final item in (data['unlocked_achievements'] as List)) {
            final entry = UnlockedAchievementEntry.fromJson(item as Map<String, dynamic>);
            await _db.into(_db.unlockedAchievements).insertOnConflictUpdate(entry);
          }
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}

final backupRestoreServiceProvider = Provider<BackupRestoreService>((ref) {
  final db = ref.watch(databaseProvider);
  return BackupRestoreService(db);
});
