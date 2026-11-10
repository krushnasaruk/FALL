import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';
import 'app_progress_bar.dart';
import 'pastel_card.dart';

/// Clean Progress Summary Card with real progress bar and factual metadata.
class ProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String? subtitle;
  final String? date;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.subtitle,
    this.date,
    this.gradient,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentInt = (progress.clamp(0.0, 1.0) * 100).toInt();

    return PastelCard(
      backgroundColor: isDark ? AppColors.darkProjectSurface : AppColors.projectSurface,
      borderColor: isDark ? AppColors.darkBorder : AppColors.projectBorder,
      borderRadius: AppRadii.card,
      padding: const EdgeInsets.all(16.0),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cardTitle.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onMore != null)
                IconButton(
                  onPressed: onMore,
                  icon: const Icon(Icons.more_horiz_rounded, size: 20.0),
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTypography.metadata.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              Text(
                '$percentInt%',
                style: AppTypography.cardPercent.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          AppProgressBar(
            progress: progress,
            height: 6.0,
            barColor: isDark ? AppColors.primaryDark : AppColors.primary,
            backgroundColor: isDark
                ? Colors.white.withOpacity(0.10)
                : AppColors.primary.withOpacity(0.14),
          ),
          if (subtitle != null || (date != null && date!.isNotEmpty)) ...[
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: AppTypography.metadata.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (date != null && date!.isNotEmpty) ...[
                  const SizedBox(width: 8.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.calendar,
                        size: 12.0,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        date!,
                        style: AppTypography.metadata.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
