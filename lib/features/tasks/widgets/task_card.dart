import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/avatar_stack.dart';
import '../../../core/widgets/pastel_card.dart';
import '../../../data/repositories/task_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    final task = taskWithSubtasks.task;
    final isDone = task.isCompleted;

    // Pick card gradient based on priority/status if not provided
    final cardGradient = gradient ?? _gradientForTask(task.priority, isDone);

    final totalSubtasks = taskWithSubtasks.subtasks.length;
    final completedSubtasks = taskWithSubtasks.completedSubtasksCount;
    final progress = totalSubtasks > 0
        ? (completedSubtasks / totalSubtasks)
        : (isDone ? 1.0 : 0.0);
    final percentInt = (progress * 100).toInt();

    // Format date string: "Today · 4:00 PM" or "Nov 15 -> Nov 19"
    String dateLabel = '';
    if (task.dueDate != null) {
      if (task.hasDueTime) {
        dateLabel = DateFormatters.dateTimeShort(task.dueDate!);
      } else {
        dateLabel = DateFormatters.relativeDate(task.dueDate!);
      }
    }

    return Dismissible(
      key: Key('task_card_${task.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: PastelCard(
        gradient: cardGradient,
        borderRadius: AppRadii.card,
        padding: const EdgeInsets.all(16.0),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: Title + Checkbox/Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTypography.cardHeader.copyWith(
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone
                              ? const Color(0xFF64748B)
                              : const Color(0xFF1E293B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.description != null && task.description!.isNotEmpty) ...[
                        const SizedBox(height: 3.0),
                        Text(
                          task.description!,
                          style: AppTypography.cardSub.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                // Circular completion toggle button
                GestureDetector(
                  onTap: () => onToggleComplete?.call(!isDone),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? const Color(0xFF1E293B) : Colors.white,
                      border: Border.all(
                        color: isDone ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                        width: 1.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isDone
                        ? const Icon(Icons.check_rounded, size: 14.0, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12.0),

            // Progress bar row (only if subtasks exist or not compact)
            if (totalSubtasks > 0 || isDone) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: AppTypography.cardSub.copyWith(
                      color: const Color(0xFF475569),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$percentInt%',
                    style: AppTypography.cardPercent.copyWith(
                      fontSize: 12.0,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              AppProgressBar(
                progress: progress,
                height: 5.0,
                barColor: const Color(0xFF1E293B),
                backgroundColor: Colors.white.withOpacity(0.55),
              ),
              const SizedBox(height: 12.0),
            ],

            // Bottom metadata row: Avatars / Priority on left, Date capsule pill on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side: Avatar stack & Priority badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AvatarStack(
                      size: 20.0,
                      overlap: 7.0,
                      maxAvatars: 3,
                    ),
                    if (task.priority == 'urgent' || task.priority == 'high') ...[
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: task.priority == 'urgent'
                              ? const Color(0xFFFFD6E0)
                              : const Color(0xFFFFECC8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          task.priority.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: task.priority == 'urgent'
                                ? const Color(0xFFC92A2A)
                                : const Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Right side: Compact date pill
                if (dateLabel.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 11.0,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 4.5),
                        Text(
                          dateLabel,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static LinearGradient _gradientForTask(String priority, bool isDone) {
    if (isDone) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF1F5F9),
          Color(0xFFE2E8F0),
        ],
      );
    }
    switch (priority) {
      case 'urgent':
        return AppColors.projectPastelGradient; // Rose/Pink
      case 'high':
        return AppColors.goalPastelGradient; // Soft yellow
      case 'medium':
        return AppColors.taskPastelGradient; // Sky blue
      case 'low':
      default:
        return AppColors.learningPastelGradient; // Lavender
    }
  }
}
