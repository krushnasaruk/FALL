import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../data/repositories/task_repository.dart';

class TaskTile extends StatelessWidget {
  final TaskWithSubtasks taskWithSubtasks;
  final ValueChanged<bool>? onToggleComplete;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskTile({
    super.key,
    required this.taskWithSubtasks,
    this.onToggleComplete,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final task = taskWithSubtasks.task;
    final isDone = task.isCompleted;

    return Dismissible(
      key: Key('task_${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadii.roundedMd,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadii.roundedMd,
          border: Border.all(
            color: taskWithSubtasks.isOverdue
                ? AppColors.error.withOpacity(0.4)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadii.roundedMd,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadii.roundedMd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () => onToggleComplete?.call(!isDone),
                    child: Container(
                      width: 22.0,
                      height: 22.0,
                      margin: const EdgeInsets.only(top: 2.0, right: 12.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? AppColors.success : Colors.transparent,
                        border: Border.all(
                          color: isDone
                              ? AppColors.success
                              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                          width: 1.8,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check_rounded, size: 14.0, color: Colors.white)
                          : null,
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: AppTypography.bodyMedium.copyWith(
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            color: isDone
                                ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (task.description != null && task.description!.isNotEmpty) ...[
                          const SizedBox(height: 3.0),
                          Text(
                            task.description!,
                            style: AppTypography.caption.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8.0),
                        // Metadata chips
                        Wrap(
                          spacing: 6.0,
                          runSpacing: 4.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            AppPriorityBadge(priority: task.priority),
                            if (task.dueDate != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: taskWithSubtasks.isOverdue
                                      ? AppColors.errorSoft
                                      : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated),
                                  borderRadius: AppRadii.roundedXs,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 11.0,
                                      color: taskWithSubtasks.isOverdue
                                          ? AppColors.error
                                          : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      task.hasDueTime
                                          ? DateFormatters.dateTimeShort(task.dueDate!)
                                          : DateFormatters.relativeDate(task.dueDate!),
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 10.5,
                                        color: taskWithSubtasks.isOverdue
                                            ? AppColors.error
                                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (taskWithSubtasks.project != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: AppColors.infoSoft,
                                  borderRadius: AppRadii.roundedXs,
                                ),
                                child: Text(
                                  taskWithSubtasks.project!.name,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 10.5,
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            if (taskWithSubtasks.subtasks.isNotEmpty) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.checklist_rounded,
                                    size: 12.0,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                  const SizedBox(width: 3.0),
                                  Text(
                                    '${taskWithSubtasks.completedSubtasksCount}/${taskWithSubtasks.subtasks.length}',
                                    style: AppTypography.monoSmall.copyWith(
                                      fontSize: 10.5,
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (task.recurrence != 'none') ...[
                              Icon(
                                Icons.repeat_rounded,
                                size: 12.0,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
