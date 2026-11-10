import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../data/repositories/task_repository.dart';

/// Compact Task Card (Section 7C): clean neutral surface, 1-tap circular checkbox,
/// priority badge (icon + label), optional project badge, due date/time, and reminder indicator.
class TaskCard extends StatelessWidget {
  final TaskWithSubtasks taskWithSubtasks;
  final ValueChanged<bool>? onToggleComplete;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Gradient? gradient;
  final bool compact;

  const TaskCard({
    super.key,
    required this.taskWithSubtasks,
    this.onToggleComplete,
    this.onTap,
    this.onDelete,
    this.gradient,
    this.compact = false,
  });

  Color _priorityStripeColor(String priority, bool isDone) {
    if (isDone) return AppColors.success;
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppColors.priorityUrgent;
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
      default:
        return AppColors.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final task = taskWithSubtasks.task;
    final isDone = task.isCompleted;
    final isOverdue = taskWithSubtasks.isOverdue;

    final totalSubtasks = taskWithSubtasks.subtasks.length;
    final completedSubtasks = taskWithSubtasks.completedSubtasksCount;

    String dateLabel = '';
    if (task.dueDate != null) {
      final rel = DateFormatters.relativeDate(task.dueDate!);
      dateLabel = task.hasDueTime
          ? '$rel • ${DateFormatters.timeOnly(task.dueDate!)}'
          : rel;
    }

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final stripeColor = _priorityStripeColor(task.priority, isDone);

    return Dismissible(
      key: Key('task_card_${task.id}'),
      direction: onDelete != null ? DismissDirection.endToStart : DismissDirection.none,
      confirmDismiss: (_) async {
        if (onDelete == null) return false;
        return ConfirmationDialog.show(
          context,
          title: 'Delete task?',
          message: 'Remove "${task.title}"? This action cannot be undone.',
          confirmLabel: 'Delete',
          isDestructive: true,
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        decoration: const BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadii.roundedCard,
        ),
        child: const Icon(AppIcons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: Material(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.roundedCard,
          side: BorderSide(color: borderColor, width: 1.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.roundedCard,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtle left priority stripe
                Container(
                  width: 3.5,
                  height: compact ? 36.0 : 44.0,
                  margin: const EdgeInsets.only(top: 2.0, right: 10.0),
                  decoration: BoxDecoration(
                    color: stripeColor.withOpacity(isDone ? 0.45 : 0.85),
                    borderRadius: AppRadii.roundedFull,
                  ),
                ),

                // Comfortable 1-tap circular checkbox
                Semantics(
                  button: true,
                  label: isDone ? 'Mark ${task.title} incomplete' : 'Complete ${task.title}',
                  child: InkWell(
                    onTap: () => onToggleComplete?.call(!isDone),
                    borderRadius: AppRadii.roundedFull,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: 22.0,
                        height: 22.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone ? AppColors.success : Colors.transparent,
                          border: Border.all(
                            color: isDone
                                ? AppColors.success
                                : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
                            width: 2.0,
                          ),
                        ),
                        child: isDone
                            ? const Icon(AppIcons.completion, size: 14.0, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),

                // Task Title & Restrained Metadata Row
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: AppTypography.cardTitle.copyWith(
                                fontSize: 15.5,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                                color: isDone
                                    ? (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (task.reminderAt != null && !isDone) ...[
                            const SizedBox(width: 6.0),
                            const Icon(
                              AppIcons.reminder,
                              size: 15.0,
                              color: AppColors.primary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 6.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppPriorityBadge(priority: task.priority),
                          if (taskWithSubtasks.project != null)
                            AppBadge(
                              label: taskWithSubtasks.project!.name,
                              color: AppColors.projectAccent,
                              icon: AppIcons.projects,
                            ),
                          if (dateLabel.isNotEmpty)
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 180.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    AppIcons.calendar,
                                    size: 12.0,
                                    color: isOverdue
                                        ? AppColors.error
                                        : (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Flexible(
                                    child: Text(
                                      dateLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.metadata.copyWith(
                                        color: isOverdue
                                            ? AppColors.error
                                            : (isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.textSecondary),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (totalSubtasks > 0)
                            Text(
                              '$completedSubtasks/$totalSubtasks steps',
                              style: AppTypography.metadata.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                                fontFeatures: AppTypography.tabularFigures,
                              ),
                            ),
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
    );
  }
}
