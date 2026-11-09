import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/widget_sync_service.dart';
import 'task_form_sheet.dart';

class TaskDetailSheet extends ConsumerStatefulWidget {
  final TaskWithSubtasks taskWithSubtasks;

  const TaskDetailSheet({super.key, required this.taskWithSubtasks});

  static Future<void> show(BuildContext context, TaskWithSubtasks task) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(taskWithSubtasks: task),
    );
  }

  @override
  ConsumerState<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends ConsumerState<TaskDetailSheet> {
  final TextEditingController _newSubtaskController = TextEditingController();

  @override
  void dispose() {
    _newSubtaskController.dispose();
    super.dispose();
  }

  Future<void> _addSubtask() async {
    final title = _newSubtaskController.text.trim();
    if (title.isEmpty) return;

    final repo = ref.read(taskRepositoryProvider);
    await repo.addSubtask(widget.taskWithSubtasks.task.id, title);
    _newSubtaskController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taskRepo = ref.watch(taskRepositoryProvider);

    // Watch live updates for this specific task
    final tasksAsync = ref.watch(allTasksStreamProvider);
    final currentTaskWithSubtasks = tasksAsync.value?.firstWhere(
          (t) => t.task.id == widget.taskWithSubtasks.task.id,
          orElse: () => widget.taskWithSubtasks,
        ) ??
        widget.taskWithSubtasks;

    final task = currentTaskWithSubtasks.task;
    final subtasks = currentTaskWithSubtasks.subtasks;

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppPriorityBadge(priority: task.priority),
                    const SizedBox(width: 8),
                    if (task.recurrence != 'none')
                      AppBadge(
                        label: task.recurrence.toUpperCase(),
                        color: AppColors.info,
                        icon: Icons.repeat_rounded,
                      ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () {
                        Navigator.of(context).pop();
                        TaskFormSheet.show(context, taskToEdit: currentTaskWithSubtasks);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                      onPressed: () async {
                        await taskRepo.deleteTask(task.id);
                        await ref.read(widgetSyncServiceProvider).syncAllWidgets();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Title with completion checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    await taskRepo.toggleTaskCompletion(task.id, !task.isCompleted);
                    await ref.read(widgetSyncServiceProvider).syncAllWidgets();
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    margin: const EdgeInsets.only(top: 2.0, right: 12.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isCompleted ? AppColors.success : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted ? AppColors.success : AppColors.darkTextMuted,
                        width: 2.0,
                      ),
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check_rounded, size: 16.0, color: Colors.white)
                        : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: AppTypography.titleLarge.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? AppColors.darkTextMuted : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Description
            if (task.description != null && task.description!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                  borderRadius: AppRadii.roundedMd,
                ),
                child: Text(
                  task.description!,
                  style: AppTypography.bodyMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Metadata Grid
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              children: [
                if (task.dueDate != null)
                  _buildMetaItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Due Date',
                    value: task.hasDueTime
                        ? DateFormatters.dateTimeShort(task.dueDate!)
                        : DateFormatters.monthDayYear(task.dueDate!),
                  ),
                if (currentTaskWithSubtasks.project != null)
                  _buildMetaItem(
                    icon: Icons.rocket_launch_outlined,
                    label: 'Project',
                    value: currentTaskWithSubtasks.project!.name,
                  ),
                if (currentTaskWithSubtasks.skill != null)
                  _buildMetaItem(
                    icon: Icons.school_outlined,
                    label: 'Skill',
                    value: currentTaskWithSubtasks.skill!.name,
                  ),
                _buildMetaItem(
                  icon: Icons.timer_outlined,
                  label: 'Time Spent',
                  value: '${DateFormatters.formatMinutes(task.actualMinutes)} / ${DateFormatters.formatMinutes(task.estimatedMinutes)} est.',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Subtasks Section
            Text(
              'Subtasks (${currentTaskWithSubtasks.completedSubtasksCount}/${subtasks.length})',
              style: AppTypography.titleSmall.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            ...subtasks.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: s.isCompleted,
                        onChanged: (val) async {
                          await taskRepo.toggleSubtaskCompletion(s.id, val ?? false);
                        },
                      ),
                      Expanded(
                        child: Text(
                          s.title,
                          style: AppTypography.bodyMedium.copyWith(
                            decoration: s.isCompleted ? TextDecoration.lineThrough : null,
                            color: s.isCompleted ? AppColors.darkTextMuted : null,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 16),
                        onPressed: () => taskRepo.deleteSubtask(s.id),
                      ),
                    ],
                  ),
                )),

            // Add subtask inline field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newSubtaskController,
                    style: AppTypography.bodySmall,
                    decoration: const InputDecoration(
                      hintText: 'Add new subtask...',
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addSubtask(),
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  label: 'Add',
                  onPressed: _addSubtask,
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.secondary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
        borderRadius: AppRadii.roundedSm,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.0, color: AppColors.primary),
          const SizedBox(width: 6.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTypography.caption.copyWith(fontSize: 9.5, color: AppColors.darkTextMuted),
              ),
              Text(
                value,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

