import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../data/repositories/project_repository.dart';

class ProjectCard extends StatelessWidget {
  final ProjectWithDetails projectWithDetails;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.projectWithDetails,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final project = projectWithDetails.project;
    final techTags = project.techStack.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Status badge & Priority badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppStatusBadge(status: project.status),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                      borderRadius: AppRadii.roundedXs,
                    ),
                    child: Text(
                      project.category,
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
              AppPriorityBadge(priority: project.priority),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Project Title
          Text(
            project.name,
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          if (project.description != null && project.description!.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              project.description!,
              style: AppTypography.caption.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          // Progress Bar
          AppProgressBar(
            progress: projectWithDetails.progressPercentage,
            progressColor: AppColors.primary,
            label: '${projectWithDetails.completedMilestonesCount} of ${projectWithDetails.totalMilestonesCount} milestones',
            showPercentage: true,
          ),
          const SizedBox(height: AppSpacing.md),

          // Tech stack tags
          if (techTags.isNotEmpty) ...[
            Wrap(
              spacing: 6.0,
              runSpacing: 4.0,
              children: techTags.take(4).map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: AppRadii.roundedXs,
                  ),
                  child: Text(
                    tech,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Bottom metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timelapse_rounded,
                    size: 14.0,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    DateFormatters.formatMinutes(project.timeSpentMinutes),
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              if (project.targetDate != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 14.0,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'Due ${DateFormatters.monthDayYear(project.targetDate!)}',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
