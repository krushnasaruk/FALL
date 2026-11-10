import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/rewards_repository.dart';

/// Reusable Habit Card (Section 7G): habit title, today check-in control,
/// weekly scheduled days count, current calculated streak, and 7-day strip.
class HabitCard extends StatelessWidget {
  final HabitWithEntries habitWithEntries;
  final VoidCallback onToggleToday;
  final VoidCallback onDelete;
  final List<String> weekDayLabels;

  const HabitCard({
    super.key,
    required this.habitWithEntries,
    required this.onToggleToday,
    required this.onDelete,
    this.weekDayLabels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final habit = habitWithEntries.habit;
    final isDone = habitWithEntries.isCompletedToday;
    final streak = habitWithEntries.currentStreak;
    final activity = habitWithEntries.last7DaysActivity;
    final weeklyCompleted = activity.where((d) => d).length;

    final surfaceColor = isDark ? AppColors.darkHabitSurface : AppColors.habitSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.habitBorder;
    const accent = AppColors.habitAccent;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadii.roundedCard,
        border: Border.all(color: borderColor, width: 1.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1-Tap Check-in Circle (44dp tap target)
              Semantics(
                button: true,
                label: isDone ? '${habit.title} checked in today' : 'Check in ${habit.title} today',
                child: InkWell(
                  onTap: onToggleToday,
                  borderRadius: AppRadii.roundedFull,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone
                            ? accent
                            : (isDark ? AppColors.darkSurface : AppColors.surface),
                        border: Border.all(
                          color: isDone ? accent : borderColor,
                          width: 2.0,
                        ),
                      ),
                      child: isDone
                          ? const Icon(AppIcons.completion, size: 15.0, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: AppTypography.cardTitle.copyWith(
                        color: textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3.0),
                    Wrap(
                      spacing: 8.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '$weeklyCompleted/${habit.targetDaysPerWeek} this week',
                          style: AppTypography.metadata.copyWith(
                            color: textSecondary,
                            fontFeatures: AppTypography.tabularFigures,
                          ),
                        ),
                        if (habit.reminderTime != null && habit.reminderTime!.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(AppIcons.reminder, size: 12.0, color: accent),
                              const SizedBox(width: 3.0),
                              Text(
                                habit.reminderTime!,
                                style: AppTypography.metadata.copyWith(color: accent),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      RewardsRepository.streakSupportMessage(
                        currentStreak: streak,
                        isCompletedToday: isDone,
                        entries: habitWithEntries.entries,
                      ),
                      style: AppTypography.metadata.copyWith(
                        fontSize: 11.5,
                        color: textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              if (streak > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: AppBadge(
                    label: '${streak}d streak',
                    color: accent,
                    icon: Icons.local_fire_department_rounded,
                  ),
                ),
              IconButton(
                icon: const Icon(AppIcons.delete, size: 18.0, color: AppColors.error),
                tooltip: 'Delete habit',
                visualDensity: VisualDensity.compact,
                onPressed: () async {
                  final ok = await ConfirmationDialog.show(
                    context,
                    title: 'Delete habit?',
                    message: 'Remove "${habit.title}" and its check-in history?',
                  );
                  if (ok) onDelete();
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 7-day completion matrix
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface.withOpacity(0.85),
              borderRadius: AppRadii.roundedMd,
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (idx) {
                final done = activity[idx];
                final dayLabel = weekDayLabels.length > idx ? weekDayLabels[idx] : '';
                return Column(
                  children: [
                    Text(
                      dayLabel,
                      style: AppTypography.metadata.copyWith(
                        fontSize: 10.5,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done
                            ? accent
                            : (isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.surfaceElevated),
                      ),
                      child: done
                          ? const Icon(AppIcons.completion, size: 14.0, color: Colors.white)
                          : null,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
