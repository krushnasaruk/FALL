import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_interaction.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';
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
    return AppBottomSheet.show(
      context,
      title: taskToEdit == null ? 'New Task' : 'Edit Task',
      builder: (_) => TaskFormSheet(
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
  bool _showAdditionalOptions = false;
  bool _isLoading = false;

  bool _hasUnsavedChanges() {
    final t = widget.taskToEdit?.task;
    if (t == null) {
      return _titleController.text.trim().isNotEmpty ||
          _descController.text.trim().isNotEmpty ||
          _tagsController.text.trim().isNotEmpty ||
          _subtasks.isNotEmpty;
    }
    return _titleController.text.trim() != t.title ||
        _descController.text.trim() != (t.description ?? '') ||
        _tagsController.text.trim() != t.tags ||
        _priority != t.priority ||
        _recurrence != t.recurrence ||
        _projectId != t.projectId ||
        _skillId != t.skillId;
  }

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

    // Automatically open additional options if editing a task that already uses them
    _showAdditionalOptions = (t?.description?.isNotEmpty ?? false) ||
        (_recurrence != 'none') ||
        (t?.estimatedMinutes ?? 0) > 0 ||
        (t?.tags.isNotEmpty ?? false) ||
        _skillId != null;
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
          _dueDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _dueTime!.hour,
            _dueTime!.minute,
          );
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

  Future<void> _pickReminder() async {
    final notifService = ref.read(notificationServiceProvider);
    final granted = await notifService.requestPermissionsWithExplanation(context);
    if (!mounted) return;
    if (!granted) {
      AppToast.show(
        context,
        'Notification permission is disabled; reminder saved locally but OS alert may not fire.',
      );
    }

    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderAt ?? _dueDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _reminderAt != null
          ? TimeOfDay.fromDateTime(_reminderAt!)
          : (_dueTime ?? TimeOfDay.fromDateTime(now.add(const Duration(hours: 1)))),
    );
    if (pickedTime == null) return;

    setState(() {
      _reminderAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
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
    final feedback = ref.read(feedbackServiceProvider);
    if (!_formKey.currentState!.validate()) {
      await feedback.validationError();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final taskRepo = ref.read(taskRepositoryProvider);
      final notifService = ref.read(notificationServiceProvider);
      final widgetSync = ref.read(widgetSyncServiceProvider);

      final estimatedMins = int.tryParse(_estimatedMinsController.text.trim()) ?? 0;

      late String taskId;
      final taskTitle = _titleController.text.trim();

      if (widget.taskToEdit == null) {
        final created = await taskRepo.createTask(
          title: taskTitle,
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
        taskId = created.id;
      } else {
        taskId = widget.taskToEdit!.task.id;
        await taskRepo.updateTask(
          id: taskId,
          title: taskTitle,
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
        await notifService.cancelTaskReminder(taskId);
      }

      final scheduleTarget = _reminderAt ?? (_dueTime != null ? _dueDate : null);
      if (scheduleTarget != null && scheduleTarget.isAfter(DateTime.now())) {
        await notifService.scheduleTaskReminder(
          taskId: taskId,
          title: taskTitle,
          scheduledDate: scheduleTarget,
        );
      }

      await widgetSync.syncAllWidgets();
      await feedback.buttonTap();

      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final skillsAsync = ref.watch(allSkillsStreamProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_isLoading || !_hasUnsavedChanges()) {
          if (mounted) Navigator.of(context).pop();
          return;
        }
        final choice = await confirmDiscardChanges(context, allowSaveOption: true);
        if (!context.mounted) return;
        if (choice == UnsavedChoice.discard) {
          Navigator.of(context).pop();
        } else if (choice == UnsavedChoice.save) {
          await _saveTask();
        }
      },
      child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Essential Field: Title
          AppTextField(
            label: 'Task Title',
            hintText: 'What needs to be done?',
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

          // 2. Essential Field: Due Date & Time
          Row(
            children: [
              Expanded(
                child: SelectionField(
                  label: 'Due date',
                  valueText: _dueDate == null
                      ? 'Optional'
                      : DateFormatters.monthDayYear(_dueDate!),
                  icon: AppIcons.calendar,
                  isPlaceholder: _dueDate == null,
                  onTap: _pickDueDate,
                  onClear: _dueDate == null
                      ? null
                      : () => setState(() {
                            _dueDate = null;
                            _dueTime = null;
                          }),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SelectionField(
                  label: 'Due time',
                  valueText: _dueTime == null ? 'Optional' : _dueTime!.format(context),
                  icon: AppIcons.timer,
                  isPlaceholder: _dueTime == null,
                  onTap: _pickDueTime,
                  onClear: _dueTime == null ? null : () => setState(() => _dueTime = null),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 3. Essential Field: Priority
          Text(
            'Priority',
            style: AppTypography.secondary.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6.0),
          Row(
            children: [
              _buildPriorityChip('low', 'Low', Icons.low_priority_rounded, AppColors.priorityLow),
              const SizedBox(width: 6.0),
              _buildPriorityChip('medium', 'Med', Icons.flag_outlined, AppColors.priorityMedium),
              const SizedBox(width: 6.0),
              _buildPriorityChip('high', 'High', Icons.flag_rounded, AppColors.priorityHigh),
              const SizedBox(width: 6.0),
              _buildPriorityChip('urgent', 'Urgent', Icons.priority_high_rounded, AppColors.priorityUrgent),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 4. Essential Fields: Project & Reminder
          projectsAsync.when(
            data: (projects) => DropdownButtonFormField<String?>(
              value: _projectId,
              decoration: const InputDecoration(
                labelText: 'Project (Optional)',
                prefixIcon: Icon(AppIcons.projects, size: 18.0),
              ),
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('No project')),
                ...projects.map(
                  (p) => DropdownMenuItem(
                    value: p.project.id,
                    child: Text(p.project.name, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _projectId = val),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.md),

          SelectionField(
            label: 'Reminder notification',
            valueText: _reminderAt == null
                ? 'No reminder scheduled'
                : DateFormatters.dateTimeShort(_reminderAt!),
            icon: AppIcons.reminder,
            isPlaceholder: _reminderAt == null,
            onTap: _pickReminder,
            onClear: _reminderAt == null ? null : () => setState(() => _reminderAt = null),
          ),
          const SizedBox(height: AppSpacing.md),

          // 5. Progressive Disclosure Toggle for Advanced Options
          InkWell(
            onTap: () => setState(() => _showAdditionalOptions = !_showAdditionalOptions),
            borderRadius: AppRadii.roundedMd,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    _showAdditionalOptions
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 20.0,
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'Additional options (Recurrence, Subtasks, Tags & Estimates)',
                    style: AppTypography.secondary.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.primaryDark : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_showAdditionalOptions) ...[
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Notes / Description',
              hintText: 'Context, acceptance criteria, or links...',
              controller: _descController,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            skillsAsync.when(
              data: (skills) => DropdownButtonFormField<String?>(
                value: _skillId,
                decoration: const InputDecoration(
                  labelText: 'Skill / Learning Link',
                  prefixIcon: Icon(AppIcons.learning, size: 18.0),
                ),
                isExpanded: true,
                items: [
                  const DropdownMenuItem(value: null, child: Text('No skill linked')),
                  ...skills.map(
                    (s) => DropdownMenuItem(
                      value: s.skill.id,
                      child: Text(s.skill.name, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => _skillId = val),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.md),
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
                    label: 'Est. minutes',
                    hintText: '45',
                    controller: _estimatedMinsController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (widget.taskToEdit == null) ...[
              Text(
                'Subtasks',
                style: AppTypography.secondary.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subtaskInputController,
                      style: AppTypography.bodySmall,
                      decoration: const InputDecoration(
                        hintText: 'Add checklist step...',
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addSubtask(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppIconButton(
                    icon: AppIcons.add,
                    tooltip: 'Add step',
                    onPressed: _addSubtask,
                  ),
                ],
              ),
              if (_subtasks.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                ..._subtasks.asMap().entries.map(
                      (entry) => Row(
                        children: [
                          const Icon(Icons.check_box_outline_blank_rounded, size: 16.0),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: Text(entry.value, style: AppTypography.bodySmall)),
                          IconButton(
                            icon: const Icon(AppIcons.close, size: 16.0),
                            onPressed: () => setState(() => _subtasks.removeAt(entry.key)),
                          ),
                        ],
                      ),
                    ),
              ],
              const SizedBox(height: AppSpacing.md),
            ],
            AppTextField(
              label: 'Tags',
              hintText: 'backend, ui, research',
              controller: _tagsController,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),

          PrimaryButton(
            label: widget.taskToEdit == null ? 'Create Task' : 'Save Changes',
            onPressed: _saveTask,
            isLoading: _isLoading,
            isFullWidth: true,
            size: AppButtonSize.large,
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildPriorityChip(String value, String label, IconData icon, Color color) {
    final isSelected = _priority == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: '$label priority',
        child: InkWell(
          onTap: () => setState(() => _priority = value),
          borderRadius: AppRadii.roundedSm,
          child: Container(
            constraints: const BoxConstraints(minHeight: 40.0),
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withOpacity(0.16)
                  : (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated),
              borderRadius: AppRadii.roundedSm,
              border: Border.all(
                color: isSelected
                    ? color
                    : (isDark ? AppColors.darkBorder : AppColors.border),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 13.0,
                  color: isSelected
                      ? color
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
                const SizedBox(width: 4.0),
                Flexible(
                  child: Text(
                    label,
                    style: AppTypography.metadata.copyWith(
                      color: isSelected
                          ? color
                          : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
