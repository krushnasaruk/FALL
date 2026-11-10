import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/repositories/project_repository.dart';

void main() {
  late AppDatabase db;
  late ProjectRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ProjectRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 4: Project Management, Milestones & Blueprint Notes Tests', () {
    test('createProject stores architecture blueprint notes and tech stack', () async {
      final project = await repo.createProject(
        name: 'Autonomous Rover Firmware',
        description: 'RTOS-based ground vehicle navigation',
        category: 'Hardware',
        startDate: DateTime(2026, 1, 1),
        targetDate: DateTime(2026, 6, 1),
        status: 'active',
        priority: 'high',
        techStack: 'C++, FreeRTOS, STM32, CAN bus',
        repositoryUrl: 'https://github.com/developer/rover-firmware',
        notes: 'Microcontroller: STM32F407. CAN Baud: 500kbps. Watchdog timeout: 250ms.',
        milestoneTitles: ['CAN Transceiver driver', 'Motor PID loop', 'EKF Sensor fusion'],
      );

      final fetched = await repo.getProjectById(project.id);
      expect(fetched, isNotNull);
      expect(fetched!.project.name, 'Autonomous Rover Firmware');
      expect(fetched.project.category, 'Hardware');
      expect(fetched.project.techStack, contains('FreeRTOS'));
      expect(fetched.project.notes, contains('STM32F407'));
      expect(fetched.milestones.length, 3);
      expect(fetched.progressPercentage, 0.0);
    });

    test('toggleMilestoneCompletion updates milestone status and project progress', () async {
      final project = await repo.createProject(
        name: 'High-Throughput Message Broker',
        startDate: DateTime.now(),
        milestoneTitles: ['In-memory buffer', 'Disk WAL logger'],
      );

      var fetched = await repo.getProjectById(project.id);
      expect(fetched!.milestones.length, 2);
      expect(fetched.completedMilestonesCount, 0);

      // Complete 1 of 2 milestones
      final m1 = fetched.milestones.first;
      await repo.toggleMilestoneCompletion(m1.id, true);

      fetched = await repo.getProjectById(project.id);
      expect(fetched!.completedMilestonesCount, 1);
      expect(fetched.progressPercentage, 0.5);

      // Reopen milestone
      await repo.toggleMilestoneCompletion(m1.id, false);
      fetched = await repo.getProjectById(project.id);
      expect(fetched!.completedMilestonesCount, 0);
      expect(fetched.progressPercentage, 0.0);
    });

    test('deleteMilestone removes milestone and adjusts progress', () async {
      final project = await repo.createProject(
        name: 'Compiler Frontend',
        startDate: DateTime.now(),
        milestoneTitles: ['Lexer', 'Parser', 'AST'],
      );

      var fetched = await repo.getProjectById(project.id);
      expect(fetched!.milestones.length, 3);

      final mToRemove = fetched.milestones.last;
      await repo.deleteMilestone(mToRemove.id);

      fetched = await repo.getProjectById(project.id);
      expect(fetched!.milestones.length, 2);
    });
  });
}

