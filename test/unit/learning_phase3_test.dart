import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/repositories/learning_repository.dart';

void main() {
  late AppDatabase db;
  late LearningRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LearningRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 3: Learning Roadmap, Topic Progression & Forecast Tests', () {
    test('addTopic saves resources and notes, updateTopicStatus updates progress', () async {
      final skill = await repo.createSkill(
        name: 'Rust Systems Programming',
        category: 'Systems & IoT',
        currentLevel: 'beginner',
        targetLevel: 'advanced',
      );

      await repo.addModule(skillId: skill.id, title: 'Ownership & Memory Safety');
      final skillData1 = await repo.getSkillById(skill.id);
      expect(skillData1!.modules.length, 1);
      final moduleId = skillData1.modules.first.module.id;

      await repo.addTopic(
        moduleId: moduleId,
        title: 'Borrow Checker & Lifetimes',
        resources: 'https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html',
        notes: 'Borrow Checker rules: references must always be valid; lifetime annotations do not change lifetimes.',
      );

      var skillData2 = await repo.getSkillById(skill.id);
      expect(skillData2!.totalTopics, 1);
      expect(skillData2.completedTopics, 0);
      expect(skillData2.progressPercentage, 0.0);
      final topic = skillData2.modules.first.topics.first;
      expect(topic.resources, contains('lifetime-syntax'));
      expect(topic.notes, contains('Borrow Checker'));

      // Cycle status to in_progress then completed
      await repo.updateTopicStatus(topic.id, 'in_progress');
      skillData2 = await repo.getSkillById(skill.id);
      expect(skillData2!.modules.first.topics.first.status, 'in_progress');

      await repo.updateTopicStatus(topic.id, 'completed');
      skillData2 = await repo.getSkillById(skill.id);
      expect(skillData2!.completedTopics, 1);
      expect(skillData2.progressPercentage, 1.0);
    });

    test('logLearningSession increments total learning minutes and records history', () async {
      final skill = await repo.createSkill(
        name: 'Embedded Systems',
        category: 'Systems & IoT',
        currentLevel: 'intermediate',
        targetLevel: 'expert',
      );

      await repo.logLearningSession(
        skillId: skill.id,
        durationMinutes: 90,
        notes: 'SPI communication protocol debugging with logic analyzer',
      );

      final skillData = await repo.getSkillById(skill.id);
      expect(skillData!.skill.learningMinutes, 90);
      expect(skillData.sessions.length, 1);
      expect(skillData.sessions.first.durationMinutes, 90);
      expect(skillData.sessions.first.notes, contains('logic analyzer'));
    });
  });
}
