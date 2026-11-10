import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_interaction.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/notes_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../services/feedback_service.dart';

/// Knowledge Vault & Developer Journal Screen.
/// Supports structured daily engineering logs (`category == 'journal'`) alongside
/// general technical notes, code snippets, ideas, and project-linked documentation.
class VaultScreen extends ConsumerStatefulWidget {
  final bool initialJournalMode;

  const VaultScreen({
    super.key,
    this.initialJournalMode = false,
  });

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  final _searchController = TextEditingController();
  late String _selectedCategory;
  String _searchQuery = '';

  static const _categories = <String, String>{
    'all': 'All',
    'journal': 'Dev Journal',
    'technical': 'Technical',
    'idea': 'Ideas',
    'resource': 'Resources',
    'quick': 'Quick Note',
    'general': 'General',
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialJournalMode ? 'journal' : 'all';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNoteEditor({NoteWithDetails? existing, bool forceJournalTemplate = false}) {
    final feedback = ref.read(feedbackServiceProvider);
    feedback.buttonTap();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NoteEditorSheet(
        existing: existing,
        initialCategory: existing?.note.category ??
            (forceJournalTemplate || _selectedCategory == 'journal' ? 'journal' : 'technical'),
      ),
    );
  }

  Future<void> _confirmDelete(NoteWithDetails item) async {
    final feedback = ref.read(feedbackServiceProvider);
    feedback.destructiveAction();
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Entry',
      message: 'Remove "${item.note.title}" from your local vault? This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      await ref.read(notesRepositoryProvider).deleteNote(item.note.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final feedback = ref.read(feedbackServiceProvider);
    final notesAsync = ref.watch(allNotesStreamProvider);

    final isJournalView = _selectedCategory == 'journal';

    return AppScaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        onPressed: () => _openNoteEditor(forceJournalTemplate: isJournalView),
        icon: Icon(isJournalView ? AppIcons.journal : AppIcons.add),
        label: Text(isJournalView ? 'New Journal Entry' : 'New Note'),
      ),
      body: Column(
        children: [
          PageTitle(
            title: isJournalView ? 'Developer Journal' : 'Knowledge Vault',
            subtitle: isJournalView
                ? 'Daily dev progress, bugs solved & next steps'
                : 'Technical notes, architecture decisions & references',
            showBackButton: Navigator.of(context).canPop(),
          ),

          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SearchField(
              controller: _searchController,
              hintText: 'Search titles, notes, tags...',
              onChanged: (v) => setState(() => _searchQuery = v.trim().toLowerCase()),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Category Chips
          SizedBox(
            height: 44.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
              children: _categories.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: AppFilterChip(
                    label: entry.value,
                    selected: _selectedCategory == entry.key,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _selectedCategory = entry.key);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Expanded(
            child: notesAsync.when(
              loading: () => const TasksSkeleton(),
              error: (err, _) => ErrorStateView(
                message: 'Failed to load vault: $err',
                onRetry: () => ref.invalidate(allNotesStreamProvider),
              ),
              data: (notes) {
                final filtered = notes.where((n) {
                  final matchCat = _selectedCategory == 'all' || n.note.category == _selectedCategory;
                  if (!matchCat) return false;
                  if (_searchQuery.isEmpty) return true;
                  return n.note.title.toLowerCase().contains(_searchQuery) ||
                      n.note.content.toLowerCase().contains(_searchQuery) ||
                      n.note.tags.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  if (_searchQuery.isNotEmpty) {
                    return EmptyStateView(
                      icon: AppIcons.search,
                      illustrationAsset: 'assets/images/empty/empty_search.png',
                      title: 'No matching notes.',
                      description: 'Try adjusting your search query.',
                      actionLabel: 'Clear search',
                      onAction: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    );
                  }
                  return EmptyStateView(
                    icon: isJournalView ? AppIcons.journal : AppIcons.notes,
                    illustrationAsset: isJournalView
                        ? 'assets/images/empty/empty_journal.png'
                        : 'assets/images/empty/empty_notes.png',
                    title: isJournalView
                        ? 'Every project has a story.'
                        : 'Keep your useful thoughts in one place.',
                    description: isJournalView
                        ? 'Document what you built today, issues solved, and next engineering steps.'
                        : 'Capture architecture specs, snippets, or ideas in one searchable vault.',
                    actionLabel: isJournalView ? 'Write your first entry' : 'Create a note',
                    onAction: () => _openNoteEditor(forceJournalTemplate: isJournalView),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.xs,
                    AppSpacing.pageHorizontal,
                    96.0,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _NoteCard(
                      item: item,
                      isDark: isDark,
                      onTap: () => _openNoteEditor(existing: item),
                      onTogglePin: () {
                        feedback.selectionClick();
                        ref.read(notesRepositoryProvider).togglePin(
                              item.note.id,
                              !item.note.isPinned,
                            );
                      },
                      onDelete: () => _confirmDelete(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteWithDetails item;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.item,
    required this.isDark,
    required this.onTap,
    required this.onTogglePin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final note = item.note;
    final isJournal = note.category == 'journal';
    final accentColor = isJournal
        ? (isDark ? AppColors.primaryDark : AppColors.primary)
        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);

    final tags = note.tags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .take(3)
        .toList();

    return AppCard(
      onTap: onTap,
      backgroundColor: note.isPinned
          ? (isDark ? AppColors.darkNoteSurface : AppColors.noteSurface)
          : null,
      borderColor: note.isPinned
          ? (isDark ? AppColors.primaryDark.withOpacity(0.4) : AppColors.noteBorder)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBadge(
                label: note.category == 'journal'
                    ? 'Dev Journal'
                    : note.category.toUpperCase(),
                color: accentColor,
                icon: isJournal ? AppIcons.journal : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  DateFormat('MMM d, y • h:mm a').format(note.updatedAt),
                  style: AppTypography.metadata.copyWith(
                    color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                  size: 18.0,
                  color: note.isPinned
                      ? (isDark ? AppColors.primaryDark : AppColors.primary)
                      : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                ),
                tooltip: note.isPinned ? 'Unpin' : 'Pin',
                visualDensity: VisualDensity.compact,
                onPressed: onTogglePin,
              ),
              IconButton(
                icon: Icon(
                  AppIcons.delete,
                  size: 18.0,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                ),
                tooltip: 'Delete',
                visualDensity: VisualDensity.compact,
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            note.title,
            style: AppTypography.cardTitle.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (note.content.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              note.content,
              style: AppTypography.secondary.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                height: 1.45,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (item.project != null || item.skill != null || tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: [
                if (item.project != null)
                  AppBadge(
                    label: item.project!.name,
                    icon: AppIcons.projects,
                    color: AppColors.projectAccent,
                  ),
                if (item.skill != null)
                  AppBadge(
                    label: item.skill!.name,
                    icon: AppIcons.learning,
                    color: AppColors.learningAccent,
                  ),
                for (final tag in tags)
                  AppBadge(
                    label: '#$tag',
                    isOutlined: true,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteEditorSheet extends ConsumerStatefulWidget {
  final NoteWithDetails? existing;
  final String initialCategory;

  const _NoteEditorSheet({
    this.existing,
    required this.initialCategory,
  });

  @override
  ConsumerState<_NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends ConsumerState<_NoteEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  late String _category;
  String? _projectId;
  String? _skillId;
  bool _isPinned = false;
  bool _isSaving = false;

  late String _initialTitle;
  late String _initialContent;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _category = e?.note.category ?? widget.initialCategory;
    _projectId = e?.note.projectId;
    _skillId = e?.note.skillId;
    _isPinned = e?.note.isPinned ?? false;

    final defaultJournalTitle = e != null
        ? e.note.title
        : (_category == 'journal'
            ? 'Dev Log — ${DateFormat('MMM d, y').format(DateTime.now())}'
            : '');
    final defaultJournalBody = e != null
        ? e.note.content
        : (_category == 'journal'
            ? '## Development Notes\n- \n\n## Problems & Solutions\n- \n\n## Next Steps\n- '
            : '');

    _initialTitle = defaultJournalTitle;
    _initialContent = defaultJournalBody;
    _titleController = TextEditingController(text: defaultJournalTitle);
    _contentController = TextEditingController(text: defaultJournalBody);
    _tagsController = TextEditingController(text: e?.note.tags ?? '');
  }

  bool _hasUnsavedChanges() {
    return _titleController.text != _initialTitle ||
        _contentController.text != _initialContent ||
        _tagsController.text.trim() != (widget.existing?.note.tags ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ref.read(feedbackServiceProvider).validationError();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title before saving.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(notesRepositoryProvider);
      if (widget.existing == null) {
        await repo.createNote(
          title: title,
          content: _contentController.text.trim(),
          category: _category,
          tags: _tagsController.text.trim(),
          projectId: _projectId,
          skillId: _skillId,
          isPinned: _isPinned,
        );
      } else {
        await repo.updateNote(
          id: widget.existing!.note.id,
          title: title,
          content: _contentController.text.trim(),
          category: _category,
          tags: _tagsController.text.trim(),
          projectId: _projectId,
          skillId: _skillId,
          isPinned: _isPinned,
        );
      }
      ref.read(feedbackServiceProvider).buttonTap();
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projects = ref.watch(allProjectsStreamProvider).value ?? [];
    final skills = ref.watch(allSkillsStreamProvider).value ?? [];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_isSaving || !_hasUnsavedChanges()) {
          if (mounted) Navigator.of(context).pop();
          return;
        }
        final choice = await confirmDiscardChanges(context, allowSaveOption: true);
        if (!context.mounted) return;
        if (choice == UnsavedChoice.discard) {
          Navigator.of(context).pop();
        } else if (choice == UnsavedChoice.save) {
          await _save();
        }
      },
      child: AppBottomSheet(
      title: widget.existing == null
          ? (_category == 'journal' ? 'New Journal Entry' : 'New Note')
          : 'Edit Entry',
      headerActions: [
        IconButton(
          icon: Icon(
            _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
            color: _isPinned ? AppColors.primary : null,
          ),
          tooltip: 'Pin Entry',
          onPressed: () => setState(() => _isPinned = !_isPinned),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Title',
              hintText: _category == 'journal' ? 'Dev Log — Today' : 'Note title',
              controller: _titleController,
            ),
            const SizedBox(height: AppSpacing.md),

            Text(
              'Category',
              style: AppTypography.metadata.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: const [
                ('journal', 'Dev Journal'),
                ('technical', 'Technical'),
                ('idea', 'Idea'),
                ('resource', 'Resource'),
                ('quick', 'Quick'),
                ('general', 'General'),
              ].map((cat) {
                return AppFilterChip(
                  label: cat.$2,
                  selected: _category == cat.$1,
                  onSelected: () => setState(() => _category = cat.$1),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Content',
              hintText: 'Write clean markdown, code snippets, or dev notes...',
              controller: _contentController,
              maxLines: 8,
            ),
            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Tags (comma-separated)',
              hintText: 'flutter, drift, architecture',
              controller: _tagsController,
            ),

            if (projects.isNotEmpty || skills.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (projects.isNotEmpty)
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _projectId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Link Project'),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('None')),
                          ...projects.map(
                            (p) => DropdownMenuItem(
                              value: p.project.id,
                              child: Text(p.project.name, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _projectId = v),
                      ),
                    ),
                  if (projects.isNotEmpty && skills.isNotEmpty)
                    const SizedBox(width: AppSpacing.md),
                  if (skills.isNotEmpty)
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _skillId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Link Skill'),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('None')),
                          ...skills.map(
                            (s) => DropdownMenuItem(
                              value: s.skill.id,
                              child: Text(s.skill.name, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _skillId = v),
                      ),
                    ),
                ],
              ),
            ],

            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: widget.existing == null ? 'Save Entry' : 'Update Entry',
              isFullWidth: true,
              isLoading: _isSaving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
