import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../data/database/app_database.dart';

typedef Goal = GoalEntry;

/// Reusable Goal Card (Section 7F): outcome title, category cadence, target vs current,
/// deadline (if configured), progress bar, and incremental log actions.
class GoalCard extends StatelessWidget {
  final GoalEntry goal;
  final VoidCallback onIncrement;
  final VoidCallback onLogValue;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onIncrement,
    required this.onLogValue,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (goal.targetValue > 0)
        ? (goal.currentValue / goal.targetValue).clamp(0.0, 1.0)
        : 0.0;
    final percentInt = (progress * 100).round();

    final surfaceColor = isDark ? AppColors.darkGoalSurface : AppColors.goalSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.goalBorder;
    const accent = AppColors.goalAccent;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final currentStr = goal.currentValue.truncateToDouble() == goal.currentValue
        ? goal.currentValue.toStringAsFixed(0)
        : goal.currentValue.toStringAsFixed(1);
    final targetStr = goal.targetValue.truncateToDouble() == goal.targetValue
        ? goal.targetValue.toStringAsFixed(0)
        : goal.targetValue.toStringAsFixed(1);

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
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: AppRadii.roundedSm,
                  border: Border.all(color: borderColor),
                ),
                child: Icon(
                  goal.isAchieved ? AppIcons.goalsActive : AppIcons.goals,
                  size: 18.0,
                  color: goal.isAchieved ? AppColors.success : accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: AppTypography.cardTitle.copyWith(color: textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '$currentStr of $targetStr ${goal.unit}',
                      style: AppTypography.secondary.copyWith(
                        fontSize: 12.5,
                        color: textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(
                label: goal.type.replaceAll('_', ' ').toUpperCase(),
                color: goal.isAchieved ? AppColors.success : accent,
              ),
            ],
          ),

          if (goal.deadline != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(AppIcons.calendar, size: 12.0, color: textSecondary),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    'Deadline ${DateFormatters.monthDayYear(goal.deadline!)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.metadata.copyWith(color: textSecondary),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.md),
          AppProgressBar(
            progress: progress,
            height: 6.0,
            barColor: goal.isAchieved ? AppColors.success : accent,
            backgroundColor: accent.withOpacity(0.16),
            label: goal.isAchieved ? 'Target achieved' : 'Progress',
            showPercentage: true,
            textColor: textSecondary,
          ),

          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    SecondaryButton(
                      label: 'Update ($percentInt%)',
                      size: AppButtonSize.small,
                      icon: AppIcons.edit,
                      onPressed: onLogValue,
                    ),
                    PrimaryButton(
                      label: '+1 ${goal.unit}',
                      size: AppButtonSize.small,
                      onPressed: onIncrement,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(AppIcons.delete, size: 19.0, color: AppColors.error),
                tooltip: 'Delete goal',
                onPressed: () async {
                  final ok = await ConfirmationDialog.show(
                    context,
                    title: 'Delete goal?',
                    message: 'Remove "${goal.title}" permanently?',
                  );
                  if (ok) onDelete();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
