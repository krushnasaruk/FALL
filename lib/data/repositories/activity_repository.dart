import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class ActivityRepository {
  final AppDatabase _db;

  ActivityRepository(this._db);

  Stream<List<ActivityHistoryEntry>> watchRecentActivities({int limit = 50}) {
    return (_db.select(_db.activityHistory)
          ..orderBy([(a) => OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ActivityRepository(db);
});

final recentActivitiesStreamProvider = StreamProvider<List<ActivityHistoryEntry>>((ref) {
  final repo = ref.watch(activityRepositoryProvider);
  return repo.watchRecentActivities();
});

