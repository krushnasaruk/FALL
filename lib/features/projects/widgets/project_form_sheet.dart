import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../services/widget_sync_service.dart';

class ProjectFormSheet extends ConsumerStatefulWidget {
  final ProjectWithDetails? projectToEdit;

  const ProjectFormSheet({super.key, this.projectToEdit});

  static Future<void> show(BuildContext context, {ProjectWithDetails? projectToEdit}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProjectFormSheet(projectToEdit: projectToEdit),
    );
  }

  @override
  ConsumerState<ProjectFormSheet> createState() => _ProjectFormSheetState();
}

class _ProjectFormSheetState extends ConsumerState<ProjectFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _techStackController;
  late TextEditingController _repoUrlController;
  late TextEditingController _notesController;
  final TextEditingController _milestoneInputController = TextEditingController();

  String _category = 'Startup';
  String _status = 'active';
  String _priority = 'medium';
  DateTime _startDate = DateTime.now();
  DateTime? _targetDate;
  final List<String> _milestones = [];
  bool _isLoading = false;

  final _categories = ['Startup', 'Web App', 'Mobile App', 'ML / AI', 'IoT & Hardware', 'College', 'Open Source', 'General'];
  final _statuses = ['planning', 'active', 'on_hold', 'completed', 'archived'];

  @override
  void initState() {
    super.initState();
    final p = widget.projectToEdit?.project;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _techStackController = TextEditingController(text: p?.techStack ?? '');
    _repoUrlController = TextEditingController(text: p?.repositoryUrl ?? '');
    _notesController = TextEditingController(text: p?.notes ?? '');

    if (p != null) {
      _category = p.category;
      _status = p.status;
      _priority = p.priority;
      _startDate = p.startDate;
      _targetDate = p.targetDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _techStackController.dispose();
    _repoUrlController.dispose();
    _notesController.dispose();
    _milestoneInputController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now.add(const Duration(days: 30)),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  void _addMilestone() {
    final text = _milestoneInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _milestones.add(text);
        _milestoneInputController.clear();
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(projectRepositoryProvider);
      final widgetSync = ref.read(widgetSyncServiceProvider);

      if (widget.projectToEdit == null) {
        await repo.createProject(
          name: _nameController.text.trim(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
          category: _category,
          startDate: _startDate,
          targetDate: _targetDate,
          status: _status,
          priority: _priority,
          techStack: _techStackController.text.trim(),
          repositoryUrl: _repoUrlController.text.trim().isEmpty ? null : _repoUrlController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          milestoneTitles: _milestones,
        );
      } else {
        await repo.updateProject(
          id: widget.projectToEdit!.project.id,
          name: _nameController.text.trim(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
          category: _category,
          targetDate: _targetDate,
          status: _status,
          priority: _priority,
          techStack: _techStackController.text.trim(),
          repositoryUrl: _repoUrlController.text.trim().isEmpty ? null : _repoUrlController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      }

      await widgetSync.syncAllWidgets();

      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.projectToEdit == null ? 'Create Project' : 'Edit Project',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Name
              AppTextField(
                label: 'Project Name',
                hintText: 'e.g. ProgressOS Mobile, IoT Weather Station',
                controller: _nameController,
                autofocus: widget.projectToEdit == null,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Project name is required';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              AppTextField(
                label: 'Description',
                hintText: 'What is this project and what problem does it solve?',
                controller: _descController,
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.md),

              // Category & Status Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _categories.contains(_category) ? _category : 'Startup',
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onChanged: (val) => setState(() => _category = val ?? 'Startup'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: _statuses
                          .map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase())))
                          .toList(),
                      onChanged: (val) => setState(() => _status = val ?? 'active'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Tech Stack & Repo URL
              AppTextField(
                label: 'Tech Stack (Comma Separated)',
                hintText: 'Flutter, Dart, SQLite, Riverpod, Kotlin',
                controller: _techStackController,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                label: 'Repository URL (GitHub / GitLab)',
                hintText: 'https://github.com/username/project',
                controller: _repoUrlController,
              ),
              const SizedBox(height: AppSpacing.md),

              // Target Date Picker
              OutlinedButton.icon(
                onPressed: _pickTargetDate,
                icon: const Icon(Icons.flag_outlined, size: 16),
                label: Text(
                  _targetDate == null
                      ? 'Set Target Completion Date'
                      : 'Target: ${DateFormatters.monthDayYear(_targetDate!)}',
                  style: AppTypography.caption,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Initial Milestones (for new projects)
              if (widget.projectToEdit == null) ...[
                Text(
                  'Initial Milestones',
                  style: AppTypography.titleSmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _milestoneInputController,
                        style: AppTypography.bodySmall,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Design DB schema, Implement MVP...',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onSubmitted: (_) => _addMilestone(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                      onPressed: _addMilestone,
                    ),
                  ],
                ),
                if (_milestones.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  ..._milestones.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.flag_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(entry.value, style: AppTypography.bodySmall)),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 16),
                              onPressed: () => setState(() => _milestones.removeAt(entry.key)),
                            ),
                          ],
                        ),
                      )),
                ],
                const SizedBox(height: AppSpacing.md),
              ],

              // Notes
              AppTextField(
                label: 'Project Notes & Architecture Decisions',
                hintText: 'Document goals, hardware pinouts, or architecture...',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Save button
              AppButton(
                label: widget.projectToEdit == null ? 'Create Project' : 'Save Changes',
                onPressed: _save,
                isLoading: _isLoading,
                isFullWidth: true,
                size: AppButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
