import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';

class TodayProgressCard extends StatelessWidget {
  final double percentage; // 0.0 to 1.0
  final int completedTasks;
  final int totalTasks;
  final List<int>? dailyCompletedCounts; // Real 7-day completed task counts
  final VoidCallback? onTap;

  const TodayProgressCard({
    super.key,
    required this.percentage,
    required this.completedTasks,
    required this.totalTasks,
    this.dailyCompletedCounts,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clamped = percentage.clamp(0.0, 1.0);
    final percentInt = (clamped * 100).round();

    final bgColor = isDark ? AppColors.darkProjectSurface : const Color(0xFFEDF2FD);
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFD8E4FA);
    final primaryCol = isDark ? AppColors.primaryDark : AppColors.primary;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Semantics(
      button: onTap != null,
      label: "Today's Progress: $percentInt percent, $completedTasks of $totalTasks tasks completed",
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.roundedCardLg,
          side: BorderSide(color: borderColor, width: 1.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.roundedCardLg,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Progress",
                        style: AppTypography.cardTitle.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        totalTasks > 0 ? '$percentInt%' : '—',
                        style: AppTypography.statNumerical.copyWith(
                          fontSize: 34.0,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        totalTasks > 0
                            ? '$completedTasks of $totalTasks tasks'
                            : 'No tasks scheduled today • Tap to add',
                        style: AppTypography.secondary.copyWith(
                          color: subColor,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                _ThroughputBars(
                  dailyCounts: dailyCompletedCounts,
                  progress: clamped,
                  activeColor: primaryCol,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThroughputBars extends StatelessWidget {
  final List<int>? dailyCounts;
  final double progress;
  final Color activeColor;

  const _ThroughputBars({
    required this.dailyCounts,
    required this.progress,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final counts = dailyCounts;
    if (counts != null && counts.isNotEmpty) {
      final maxCount = counts.fold<int>(0, (a, b) => a > b ? a : b);
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(counts.length, (i) {
          final value = counts[i];
          final ratio = maxCount > 0 ? (value / maxCount).clamp(0.15, 1.0) : 0.14;
          final barHeight = 52.0 * ratio;
          final isToday = i == counts.length - 1;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 8.0,
            height: barHeight,
            margin: const EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(
              color: value > 0
                  ? (isToday ? activeColor : activeColor.withOpacity(0.55))
                  : activeColor.withOpacity(0.16),
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        }),
      );
    }

    // Fallback visualization strictly proportional to provided completion percentage
    const slotHeights = [18.0, 26.0, 22.0, 38.0, 48.0];
    final activeSlots = progress <= 0.0
        ? 0
        : (progress * slotHeights.length).ceil().clamp(1, slotHeights.length);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(slotHeights.length, (index) {
        final isActive = index < activeSlots;
        return Container(
          width: 8.0,
          height: slotHeights[index],
          margin: const EdgeInsets.only(left: 6.0),
          decoration: BoxDecoration(
            color: isActive ? activeColor : activeColor.withOpacity(0.18),
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
