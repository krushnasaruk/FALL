import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class NoteWithDetails {
  final NoteEntry note;
  final ProjectEntry? project;
  final SkillEntry? skill;
  final TaskEntry? task;

  NoteWithDetails({
    required this.note,
    this.project,
    this.skill,
    this.task,
  });
}

class NotesRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  NotesRepository(this._db);

  Stream<List<NoteWithDetails>> watchAllNotes() {
    return (_db.select(_db.notes)
          ..orderBy([
            (n) => OrderingTerm(expression: n.isPinned, mode: OrderingMode.desc),
            (n) => OrderingTerm(expression: n.updatedAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .asyncMap((notes) async {
      final List<NoteWithDetails> result = [];
      for (final n in notes) {
        ProjectEntry? project;
        if (n.projectId != null) {
          project = await (_db.select(_db.projects)..where((p) => p.id.equals(n.projectId!))).getSingleOrNull();
        }

        SkillEntry? skill;
        if (n.skillId != null) {
          skill = await (_db.select(_db.skills)..where((s) => s.id.equals(n.skillId!))).getSingleOrNull();
        }

        TaskEntry? task;
        if (n.taskId != null) {
          task = await (_db.select(_db.tasks)..where((t) => t.id.equals(n.taskId!))).getSingleOrNull();
        }

        result.add(NoteWithDetails(
          note: n,
          project: project,
          skill: skill,
          task: task,
        ));
      }
      return result;
    });
  }

  Future<void> createNote({
    required String title,
    required String content,
    String category = 'general',
    String tags = '',
    String? projectId,
    String? skillId,
    String? taskId,
    bool isPinned = false,
  }) async {
    final now = DateTime.now();
    await _db.into(_db.notes).insert(NotesCompanion(
          id: Value(_uuid.v4()),
          title: Value(title.trim()),
          content: Value(content.trim()),
          category: Value(category),
          tags: Value(tags.trim()),
          projectId: Value(projectId),
          skillId: Value(skillId),
          taskId: Value(taskId),
          isPinned: Value(isPinned),
          createdAt: Value(now),
          updatedAt: Value(now),
        ));
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
    required String category,
    String tags = '',
    String? projectId,
    String? skillId,
    String? taskId,
    bool? isPinned,
  }) async {
    final now = DateTime.now();
    await (_db.update(_db.notes)..where((n) => n.id.equals(id))).write(
      NotesCompanion(
        title: Value(title.trim()),
        content: Value(content.trim()),
        category: Value(category),
        tags: Value(tags.trim()),
        projectId: Value(projectId),
        skillId: Value(skillId),
        taskId: Value(taskId),
        isPinned: isPinned != null ? Value(isPinned) : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> togglePin(String id, bool isPinned) async {
    await (_db.update(_db.notes)..where((n) => n.id.equals(id))).write(
      NotesCompanion(
        isPinned: Value(isPinned),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteNote(String id) async {
    await (_db.delete(_db.notes)..where((n) => n.id.equals(id))).go();
  }
}

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return NotesRepository(db);
});

final allNotesStreamProvider = StreamProvider<List<NoteWithDetails>>((ref) {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.watchAllNotes();
});

