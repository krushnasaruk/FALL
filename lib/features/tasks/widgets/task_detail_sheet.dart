import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/widget_sync_service.dart';
import 'task_form_sheet.dart';

class TaskDetailSheet extends ConsumerStatefulWidget {
  final TaskWithSubtasks taskWithSubtasks;

  const TaskDetailSheet({super.key, required this.taskWithSubtasks});

  static Future<void> show(BuildContext context, TaskWithSubtasks task) {
    return AppBottomSheet.show(
      context,
      builder: (_) => TaskDetailSheet(taskWithSubtasks: task),
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
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taskRepo = ref.watch(taskRepositoryProvider);
    final feedback = ref.read(feedbackServiceProvider);
    final notifService = ref.read(notificationServiceProvider);
    final widgetSync = ref.read(widgetSyncServiceProvider);

    final tasksAsync = ref.watch(allTasksStreamProvider);
    final currentTaskWithSubtasks = tasksAsync.value?.firstWhere(
          (t) => t.task.id == widget.taskWithSubtasks.task.id,
          orElse: () => widget.taskWithSubtasks,
        ) ??
        widget.taskWithSubtasks;

    final task = currentTaskWithSubtasks.task;
    final subtasks = currentTaskWithSubtasks.subtasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppPriorityBadge(priority: task.priority),
                if (task.recurrence != 'none') ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppBadge(
                    label: task.recurrence.toUpperCase(),
                    color: AppColors.info,
                    icon: AppIcons.habits,
                  ),
                ],
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20.0),
                  tooltip: 'Duplicate task',
                  onPressed: () async {
                    await taskRepo.duplicateTask(task.id);
                    await widgetSync.syncAllWidgets();
                    await feedback.buttonTap();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      AppToast.show(context, 'Duplicated "${task.title}"');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(AppIcons.edit, size: 20.0),
                  tooltip: 'Edit task',
                  onPressed: () {
                    Navigator.of(context).pop();
                    TaskFormSheet.show(context, taskToEdit: currentTaskWithSubtasks);
                  },
                ),
                IconButton(
                  icon: const Icon(AppIcons.delete, size: 20.0, color: AppColors.error),
                  tooltip: 'Delete task',
                  onPressed: () async {
                    final confirmed = await ConfirmationDialog.show(
                      context,
                      title: 'Delete task?',
                      message: 'Delete "${task.title}" and cancel any scheduled reminders?',
                      confirmLabel: 'Delete',
                    );
                    if (!confirmed) return;
                    await feedback.destructiveAction();
                    await notifService.cancelTaskReminder(task.id);
                    await taskRepo.deleteTask(task.id);
                    await widgetSync.syncAllWidgets();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                final next = !task.isCompleted;
                await feedback.taskCompleted(completed: next);
                await taskRepo.toggleTaskCompletion(task.id, next);
                if (next) await notifService.cancelTaskReminder(task.id);
                await widgetSync.syncAllWidgets();
              },
              borderRadius: AppRadii.roundedFull,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0, right: 12.0, bottom: 4.0),
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.isCompleted ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.success
                          : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
                      width: 2.0,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(AppIcons.completion, size: 15.0, color: Colors.white)
                      : null,
                ),
              ),
            ),
            Expanded(
              child: Text(
                task.title,
                style: AppTypography.sectionTitle.copyWith(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)
                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        if (task.description != null && task.description!.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: AppSpacing.compactCard,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
              borderRadius: AppRadii.roundedMd,
            ),
            child: Text(task.description!, style: AppTypography.bodySmall),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            if (task.dueDate != null)
              _MetaChip(
                icon: AppIcons.calendar,
                label: 'Due',
                value: task.hasDueTime
                    ? DateFormatters.dateTimeShort(task.dueDate!)
                    : DateFormatters.monthDayYear(task.dueDate!),
              ),
            if (task.reminderAt != null)
              _MetaChip(
                icon: AppIcons.reminder,
                label: 'Reminder',
                value: DateFormatters.dateTimeShort(task.reminderAt!),
              ),
            if (currentTaskWithSubtasks.project != null)
              _MetaChip(
                icon: AppIcons.projects,
                label: 'Project',
                value: currentTaskWithSubtasks.project!.name,
              ),
            if (currentTaskWithSubtasks.skill != null)
              _MetaChip(
                icon: AppIcons.learning,
                label: 'Skill',
                value: currentTaskWithSubtasks.skill!.name,
              ),
            if (task.estimatedMinutes > 0 || task.actualMinutes > 0)
              _MetaChip(
                icon: AppIcons.timer,
                label: 'Time',
                value:
                    '${DateFormatters.formatMinutes(task.actualMinutes)} / ${DateFormatters.formatMinutes(task.estimatedMinutes)}',
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        Text(
          'Subtasks (${currentTaskWithSubtasks.completedSubtasksCount}/${subtasks.length})',
          style: AppTypography.titleSmall.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        ...subtasks.map(
          (s) => Row(
            children: [
              Checkbox(
                value: s.isCompleted,
                onChanged: (val) async {
                  await feedback.selectionClick();
                  await taskRepo.toggleSubtaskCompletion(s.id, val ?? false);
                },
              ),
              Expanded(
                child: Text(
                  s.title,
                  style: AppTypography.bodySmall.copyWith(
                    decoration: s.isCompleted ? TextDecoration.lineThrough : null,
                    color: s.isCompleted
                        ? (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)
                        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(AppIcons.close, size: 16.0),
                onPressed: () => taskRepo.deleteSubtask(s.id),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newSubtaskController,
                style: AppTypography.bodySmall,
                decoration: const InputDecoration(
                  hintText: 'Add subtask step...',
                  isDense: true,
                ),
                onSubmitted: (_) => _addSubtask(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SecondaryButton(
              label: 'Add',
              size: AppButtonSize.small,
              onPressed: _addSubtask,
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
        borderRadius: AppRadii.roundedSm,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.0, color: AppColors.primary),
          const SizedBox(width: 6.0),
          Text(
            '$label: ',
            style: AppTypography.metadata.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.metadata.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
