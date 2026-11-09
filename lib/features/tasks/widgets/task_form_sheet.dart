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
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/notification_service.dart';
import '../../../services/widget_sync_service.dart';

class TaskFormSheet extends ConsumerStatefulWidget {
  final TaskWithSubtasks? taskToEdit;
  final String? preselectedProjectId;
  final String? preselectedSkillId;

  const TaskFormSheet({
    super.key,
    this.taskToEdit,
    this.preselectedProjectId,
    this.preselectedSkillId,
  });

  static Future<void> show(
    BuildContext context, {
    TaskWithSubtasks? taskToEdit,
    String? preselectedProjectId,
    String? preselectedSkillId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskFormSheet(
        taskToEdit: taskToEdit,
        preselectedProjectId: preselectedProjectId,
        preselectedSkillId: preselectedSkillId,
      ),
    );
  }

  @override
  ConsumerState<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends ConsumerState<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _tagsController;
  late TextEditingController _estimatedMinsController;
  final TextEditingController _subtaskInputController = TextEditingController();

  String _priority = 'medium';
  String _recurrence = 'none';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  DateTime? _reminderAt;
  String? _projectId;
  String? _skillId;
  final List<String> _subtasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final t = widget.taskToEdit?.task;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _tagsController = TextEditingController(text: t?.tags ?? '');
    _estimatedMinsController = TextEditingController(
      text: t != null && t.estimatedMinutes > 0 ? t.estimatedMinutes.toString() : '',
    );

    _priority = t?.priority ?? 'medium';
    _recurrence = t?.recurrence ?? 'none';
    _dueDate = t?.dueDate;
    if (t != null && t.hasDueTime && t.dueDate != null) {
      _dueTime = TimeOfDay.fromDateTime(t.dueDate!);
    }
    _reminderAt = t?.reminderAt;
    _projectId = t?.projectId ?? widget.preselectedProjectId;
    _skillId = t?.skillId ?? widget.preselectedSkillId;

    if (widget.taskToEdit != null) {
      for (final s in widget.taskToEdit!.subtasks) {
        _subtasks.add(s.title);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagsController.dispose();
    _estimatedMinsController.dispose();
    _subtaskInputController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        if (_dueTime != null) {
          _dueDate = DateTime(picked.year, picked.month, picked.day, _dueTime!.hour, _dueTime!.minute);
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  Future<void> _pickDueTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _dueTime = picked;
        final base = _dueDate ?? DateTime.now();
        _dueDate = DateTime(base.year, base.month, base.day, picked.hour, picked.minute);
      });
    }
  }

  void _addSubtask() {
    final text = _subtaskInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _subtasks.add(text);
        _subtaskInputController.clear();
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final taskRepo = ref.read(taskRepositoryProvider);
      final notifService = ref.read(notificationServiceProvider);
      final widgetSync = ref.read(widgetSyncServiceProvider);

      final estimatedMins = int.tryParse(_estimatedMinsController.text.trim()) ?? 0;

      if (widget.taskToEdit == null) {
        // Create new
        final created = await taskRepo.createTask(
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
          priority: _priority,
          dueDate: _dueDate,
          hasDueTime: _dueTime != null,
          reminderAt: _reminderAt,
          projectId: _projectId,
          skillId: _skillId,
          estimatedMinutes: estimatedMins,
          recurrence: _recurrence,
          tags: _tagsController.text.trim(),
          subtaskTitles: _subtasks,
        );

        if (_dueDate != null) {
          await notifService.scheduleTaskReminder(
            taskId: created.id,
            title: created.title,
            scheduledDate: _dueDate!,
          );
        }
      } else {
        // Update existing
        final id = widget.taskToEdit!.task.id;
        await taskRepo.updateTask(
          id: id,
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
          priority: _priority,
          dueDate: _dueDate,
          hasDueTime: _dueTime != null,
          reminderAt: _reminderAt,
          projectId: _projectId,
          skillId: _skillId,
          estimatedMinutes: estimatedMins,
          recurrence: _recurrence,
          tags: _tagsController.text.trim(),
        );

        if (_dueDate != null) {
          await notifService.scheduleTaskReminder(
            taskId: id,
            title: _titleController.text.trim(),
            scheduledDate: _dueDate!,
          );
        }
      }

      // Sync Native Widgets
      await widgetSync.syncAllWidgets();

      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    widget.taskToEdit == null ? 'Create Task' : 'Edit Task',
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

              // Title
              AppTextField(
                label: 'Task Title',
                hintText: 'e.g. Implement Drift migrations or Write unit tests',
                controller: _titleController,
                autofocus: widget.taskToEdit == null,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              AppTextField(
                label: 'Description (Optional)',
                hintText: 'Add context, specifications, or notes...',
                controller: _descController,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.md),

              // Priority Selector
              Text(
                'Priority',
                style: AppTypography.titleSmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  _buildPriorityChip('low', 'Low', AppColors.priorityLow),
                  const SizedBox(width: 8),
                  _buildPriorityChip('medium', 'Medium', AppColors.priorityMedium),
                  const SizedBox(width: 8),
                  _buildPriorityChip('high', 'High', AppColors.priorityHigh),
                  const SizedBox(width: 8),
                  _buildPriorityChip('urgent', 'Urgent', AppColors.priorityUrgent),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Date & Time Picker Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDueDate,
                      icon: const Icon(Icons.calendar_today_rounded, size: 16),
                      label: Text(
                        _dueDate == null ? 'Set Due Date' : DateFormatters.monthDayYear(_dueDate!),
                        style: AppTypography.caption,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _dueDate == null ? null : _pickDueTime,
                      icon: const Icon(Icons.access_time_rounded, size: 16),
                      label: Text(
                        _dueTime == null ? 'Set Time' : _dueTime!.format(context),
                        style: AppTypography.caption,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Project & Skill Row
              Row(
                children: [
                  // Project
                  Expanded(
                    child: projectsAsync.when(
                      data: (projects) => DropdownButtonFormField<String?>(
                        value: _projectId,
                        decoration: const InputDecoration(labelText: 'Project'),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('No Project')),
                          ...projects.map((p) => DropdownMenuItem(
                                value: p.project.id,
                                child: Text(p.project.name, overflow: TextOverflow.ellipsis),
                              )),
                        ],
                        onChanged: (val) => setState(() => _projectId = val),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Skill
                  Expanded(
                    child: skillsAsync.when(
                      data: (skills) => DropdownButtonFormField<String?>(
                        value: _skillId,
                        decoration: const InputDecoration(labelText: 'Skill / Roadmap'),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('No Skill')),
                          ...skills.map((s) => DropdownMenuItem(
                                value: s.skill.id,
                                child: Text(s.skill.name, overflow: TextOverflow.ellipsis),
                              )),
                        ],
                        onChanged: (val) => setState(() => _skillId = val),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Recurrence & Estimated Minutes
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _recurrence,
                      decoration: const InputDecoration(labelText: 'Recurrence'),
                      items: const [
                        DropdownMenuItem(value: 'none', child: Text('None')),
                        DropdownMenuItem(value: 'daily', child: Text('Daily')),
                        DropdownMenuItem(value: 'weekdays', child: Text('Weekdays')),
                        DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                      ],
                      onChanged: (val) => setState(() => _recurrence = val ?? 'none'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      label: 'Est. Duration',
                      hintText: 'Minutes (e.g. 45)',
                      controller: _estimatedMinsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtasks input (for new tasks)
              if (widget.taskToEdit == null) ...[
                Text(
                  'Subtasks',
                  style: AppTypography.titleSmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _subtaskInputController,
                        style: AppTypography.bodySmall,
                        decoration: const InputDecoration(
                          hintText: 'Add subtask item...',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onSubmitted: (_) => _addSubtask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                      onPressed: _addSubtask,
                    ),
                  ],
                ),
                if (_subtasks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  ..._subtasks.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_box_outline_blank_rounded, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(entry.value, style: AppTypography.bodySmall)),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 16),
                              onPressed: () => setState(() => _subtasks.removeAt(entry.key)),
                            ),
                          ],
                        ),
                      )),
                ],
                const SizedBox(height: AppSpacing.md),
              ],

              // Tags
              AppTextField(
                label: 'Tags',
                hintText: 'e.g. backend, flutter, homework (comma separated)',
                controller: _tagsController,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              AppButton(
                label: widget.taskToEdit == null ? 'Create Task' : 'Save Changes',
                onPressed: _saveTask,
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

  Widget _buildPriorityChip(String value, String label, Color color) {
    final isSelected = _priority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.18) : Colors.transparent,
            borderRadius: AppRadii.roundedSm,
            border: Border.all(
              color: isSelected ? color : AppColors.darkBorder,
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isSelected ? color : AppColors.darkTextSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

