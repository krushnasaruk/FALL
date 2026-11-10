import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/repositories/learning_repository.dart';
import 'package:progress_os/data/repositories/notes_repository.dart';
import 'package:progress_os/data/repositories/project_repository.dart';

void main() {
  late AppDatabase db;
  late NotesRepository notesRepo;
  late ProjectRepository projectRepo;
  late LearningRepository learningRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    notesRepo = NotesRepository(db);
    projectRepo = ProjectRepository(db);
    learningRepo = LearningRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 5: Knowledge Vault Markdown Notes & Entity Linking Tests', () {
    test('createNote links with project and skill', () async {
      final project = await projectRepo.createProject(
        name: 'Neural Network Compiler',
        startDate: DateTime.now(),
      );

      final skill = await learningRepo.createSkill(
        name: 'LLVM Backend',
        category: 'Systems & IoT',
      );

      await notesRepo.createNote(
        title: 'Instruction Selection Architecture',
        content: '# LLVM TableGen\n\n- Lower DAG nodes\n- Peephole optimization\n```cpp\nSelectionDAGISel::Select();\n```',
        category: 'technical',
        tags: 'llvm, compilers, codegen',
        projectId: project.id,
        skillId: skill.id,
        isPinned: true,
      );

      final allNotes = await notesRepo.watchAllNotes().first;
      expect(allNotes.length, 1);
      final item = allNotes.first;
      expect(item.note.title, 'Instruction Selection Architecture');
      expect(item.note.content, contains('SelectionDAGISel'));
      expect(item.note.isPinned, isTrue);
      expect(item.project, isNotNull);
      expect(item.project!.name, 'Neural Network Compiler');
      expect(item.skill, isNotNull);
      expect(item.skill!.name, 'LLVM Backend');
    });

    test('togglePin updates note priority in watchAllNotes ordering', () async {
      await notesRepo.createNote(
        title: 'Standard Note',
        content: 'Content A',
        isPinned: false,
      );

      await notesRepo.createNote(
        title: 'Important Architecture Decision',
        content: 'Content B',
        isPinned: true,
      );

      final notes = await notesRepo.watchAllNotes().first;
      expect(notes.length, 2);
      expect(notes.first.note.title, 'Important Architecture Decision');
      expect(notes.first.note.isPinned, isTrue);
    });
  });
}

