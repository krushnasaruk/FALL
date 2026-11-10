import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Tasks,
  Subtasks,
  Projects,
  Milestones,
  Skills,
  LearningModules,
  LearningTopics,
  LearningSessions,
  Goals,
  Habits,
  HabitEntries,
  FocusSessions,
  Notes,
  ScheduledNotifications,
  ActivityHistory,
  XpEvents,
  UnlockedAchievements,
  RadarDiscoveries,
  RadarTopicPrefs,
  RadarFollows,
  RadarFeedbackLogs,
  RadarBriefings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 3;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'progress_os.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(xpEvents);
            await m.createTable(unlockedAchievements);
          }
          if (from < 3) {
            await m.createTable(radarDiscoveries);
            await m.createTable(radarTopicPrefs);
            await m.createTable(radarFollows);
            await m.createTable(radarFeedbackLogs);
            await m.createTable(radarBriefings);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Permanently wipes all user data and metrics from every local table,
  /// deleting child tables before parents to honor foreign-key constraints.
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(radarBriefings).go();
      await delete(radarFeedbackLogs).go();
      await delete(radarFollows).go();
      await delete(radarTopicPrefs).go();
      await delete(radarDiscoveries).go();
      await delete(unlockedAchievements).go();
      await delete(xpEvents).go();
      await delete(scheduledNotifications).go();
      await delete(activityHistory).go();
      await delete(subtasks).go();
      await delete(tasks).go();
      await delete(milestones).go();
      await delete(learningSessions).go();
      await delete(learningTopics).go();
      await delete(learningModules).go();
      await delete(skills).go();
      await delete(habitEntries).go();
      await delete(habits).go();
      await delete(goals).go();
      await delete(focusSessions).go();
      await delete(notes).go();
      await delete(projects).go();
    });
  }
}
