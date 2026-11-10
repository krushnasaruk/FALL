import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/repositories/task_repository.dart';

void main() {
  late AppDatabase db;
  late TaskRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = TaskRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 2: Advanced Task Management & Duplication Tests', () {
    test('duplicateTask clones task attributes and subtasks', () async {
      final task = await repo.createTask(
        title: 'Calibrate LIDAR sensor',
        description: 'Verify I2C communication and baud rate',
        priority: 'high',
        dueDate: DateTime(2026, 12, 1, 14, 0),
        hasDueTime: true,
        estimatedMinutes: 45,
        tags: 'robotics, hardware',
        subtaskTitles: ['Check wiring', 'Flash firmware', 'Test distance readouts'],
      );

      final duplicate = await repo.duplicateTask(task.id);
      expect(duplicate, isNotNull);
      expect(duplicate!.title, 'Calibrate LIDAR sensor (Copy)');
      expect(duplicate.priority, 'high');
      expect(duplicate.estimatedMinutes, 45);
      expect(duplicate.tags, 'robotics, hardware');

      final loadedDuplicate = await repo.getTaskById(duplicate.id);
      expect(loadedDuplicate, isNotNull);
      expect(loadedDuplicate!.subtasks.length, 3);
      expect(loadedDuplicate.subtasks.map((s) => s.title), containsAll(['Check wiring', 'Flash firmware', 'Test distance readouts']));
    });

    test('reopening task resets completedAt timestamp', () async {
      final task = await repo.createTask(
        title: 'Review PCB schematics',
        priority: 'urgent',
      );

      await repo.toggleTaskCompletion(task.id, true);
      var fetched = await repo.getTaskById(task.id);
      expect(fetched!.task.isCompleted, isTrue);
      expect(fetched.task.completedAt, isNotNull);

      // Reopen task
      await repo.toggleTaskCompletion(task.id, false);
      fetched = await repo.getTaskById(task.id);
      expect(fetched!.task.isCompleted, isFalse);
      expect(fetched.task.completedAt, isNull);
    });
  });
}
