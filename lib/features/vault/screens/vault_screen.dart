import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/pastel_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/notes_repository.dart';
import '../../../data/repositories/project_repository.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';
  final _searchController = TextEditingController();

  final _categories = ['all', 'quick', 'technical', 'idea', 'resource', 'general'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showNoteModal({NoteWithDetails? noteToEdit}) {
    final titleController = TextEditingController(text: noteToEdit?.note.title ?? '');
    final contentController = TextEditingController(text: noteToEdit?.note.content ?? '');
    final tagsController = TextEditingController(text: noteToEdit?.note.tags ?? '');
    String category = noteToEdit?.note.category ?? 'general';
    String? projectId = noteToEdit?.note.projectId;
    String? skillId = noteToEdit?.note.skillId;
    bool isPinned = noteToEdit?.note.isPinned ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final projectsAsync = ref.watch(allProjectsStreamProvider);
          final skillsAsync = ref.watch(allSkillsStreamProvider);

          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1.0,
              ),
            ),
            padding: EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        noteToEdit == null ? 'Create Vault Note' : 'Edit Note',
                        style: AppTypography.titleLarge,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                              color: isPinned ? AppColors.primary : null,
                            ),
                            onPressed: () => setModalState(() => isPinned = !isPinned),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: 'Note Title',
                    hintText: 'e.g. Flutter 3.24 Performance Tips, Startup Pitch Idea',
                    controller: titleController,
                    autofocus: noteToEdit == null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: category,
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: const [
                            DropdownMenuItem(value: 'quick', child: Text('Quick Note')),
                            DropdownMenuItem(value: 'technical', child: Text('Technical')),
                            DropdownMenuItem(value: 'idea', child: Text('Idea')),
                            DropdownMenuItem(value: 'resource', child: Text('Resource Link')),
                            DropdownMenuItem(value: 'general', child: Text('General')),
                          ],
                          onChanged: (val) => setModalState(() => category = val ?? 'general'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Link to Project or Skill
                  Row(
                    children: [
                      Expanded(
                        child: projectsAsync.when(
                          data: (projects) => DropdownButtonFormField<String?>(
                            value: projectId,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'Link Project'),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('No Project')),
                              ...projects.map((p) => DropdownMenuItem(
                                    value: p.project.id,
                                    child: Text(p.project.name, overflow: TextOverflow.ellipsis),
                                  )),
                            ],
                            onChanged: (val) => setModalState(() => projectId = val),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: skillsAsync.when(
                          data: (skills) => DropdownButtonFormField<String?>(
                            value: skillId,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'Link Skill'),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('No Skill')),
                              ...skills.map((s) => DropdownMenuItem(
                                    value: s.skill.id,
                                    child: Text(s.skill.name, overflow: TextOverflow.ellipsis),
                                  )),
                            ],
                            onChanged: (val) => setModalState(() => skillId = val),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: 'Content',
                    hintText: 'Markdown formatting, code snippets, reference URLs...',
                    controller: contentController,
                    maxLines: 6,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: 'Tags',
                    hintText: 'architecture, dart, algorithms (comma separated)',
                    controller: tagsController,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  AppButton(
                    label: noteToEdit == null ? 'Save Note' : 'Update Note',
                    size: AppButtonSize.large,
                    isFullWidth: true,
                    onPressed: () async {
                      if (titleController.text.trim().isNotEmpty) {
                        final repo = ref.read(notesRepositoryProvider);
                        if (noteToEdit == null) {
                          await repo.createNote(
                            title: titleController.text.trim(),
                            content: contentController.text.trim(),
                            category: category,
                            tags: tagsController.text.trim(),
                            projectId: projectId,
                            skillId: skillId,
                            isPinned: isPinned,
                          );
                        } else {
                          await repo.updateNote(
                            id: noteToEdit.note.id,
                            title: titleController.text.trim(),
                            content: contentController.text.trim(),
                            category: category,
                            tags: tagsController.text.trim(),
                            projectId: projectId,
                            skillId: skillId,
                            isPinned: isPinned,
                          );
                        }
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notesAsync = ref.watch(allNotesStreamProvider);
    final repo = ref.watch(notesRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => _showNoteModal(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteModal(),
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.note_add_rounded),
        label: const Text('New Note', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
            child: TextField(
              controller: _searchController,
              style: AppTypography.bodySmall,
              decoration: InputDecoration(
                hintText: 'Search vault by title, tags, or content...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
          ),

          // Categories Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: _categories.map((c) {
                final isSelected = _selectedCategory == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(c.toUpperCase()),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = c),
                    labelStyle: AppTypography.caption.copyWith(
                      color: isSelected
                          ? const Color(0xFF0F172A)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 10.0,
                    ),
                    selectedColor: AppColors.primary,
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.roundedMd,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),

          // Notes List
          Expanded(
            child: notesAsync.when(
              data: (notes) {
                var visible = notes;
                if (_selectedCategory != 'all') {
                  visible = visible.where((n) => n.note.category == _selectedCategory).toList();
                }
                if (_searchQuery.isNotEmpty) {
                  visible = visible.where((n) {
                    final title = n.note.title.toLowerCase();
                    final content = n.note.content.toLowerCase();
                    final tags = n.note.tags.toLowerCase();
                    return title.contains(_searchQuery) ||
                        content.contains(_searchQuery) ||
                        tags.contains(_searchQuery);
                  }).toList();
                }

                if (visible.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Vault is empty',
                    description: 'Store snippets, technical architecture insights, or future startup ideas.',
                    actionLabel: 'Create Note',
                    onAction: () => _showNoteModal(),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = visible[index];
                    final note = item.note;
                    final tags = note.tags.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

                    return PastelCard(
                      gradient: AppColors.notePastelGradient,
                      borderRadius: AppRadii.card,
                      onTap: () => _showNoteModal(noteToEdit: item),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (note.isPinned) ...[
                                    const Icon(Icons.push_pin, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                  ],
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                                      borderRadius: AppRadii.roundedXs,
                                    ),
                                    child: Text(
                                      note.category.toUpperCase(),
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  if (item.project != null) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.infoSoft,
                                        borderRadius: AppRadii.roundedXs,
                                      ),
                                      child: Text(
                                        item.project!.name,
                                        style: AppTypography.caption.copyWith(
                                          fontSize: 9.5,
                                          color: AppColors.info,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                    onPressed: () => repo.deleteNote(note.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Text(note.title, style: AppTypography.titleMedium),
                          const SizedBox(height: 4.0),
                          Text(
                            note.content,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (tags.isNotEmpty) ...[
                            const SizedBox(height: 8.0),
                            Wrap(
                              spacing: 4.0,
                              children: tags.map((t) => Text(
                                '#$t',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.darkTextMuted,
                                  fontSize: 10.5,
                                ),
                              )).toList(),
                            ),
                          ],
                          const SizedBox(height: 6.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormatters.monthDay(note.updatedAt),
                              style: AppTypography.caption.copyWith(
                                color: AppColors.darkTextMuted,
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorStateView(message: err.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

