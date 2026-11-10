import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../data/repositories/project_repository.dart';

enum ProjectCardVariant {
  heroBanner,
  folderGrid,
  standard,
}

/// Reusable Project Card (Section 7D): displays project name, status badge,
/// real calculated progress percentage & bar, next pending milestone/task, and target date.
class ProjectCard extends StatelessWidget {
  final ProjectWithDetails projectWithDetails;
  final VoidCallback onTap;
  final ProjectCardVariant variant;
  final int colorIndex;

  const ProjectCard({
    super.key,
    required this.projectWithDetails,
    required this.onTap,
    this.variant = ProjectCardVariant.standard,
    this.colorIndex = 0,
  });

  String _nextStepLabel() {
    final pendingMilestones =
        projectWithDetails.milestones.where((m) => !m.isCompleted).toList();
    if (pendingMilestones.isNotEmpty) {
      return 'Next milestone: ${pendingMilestones.first.title}';
    }
    final openTasks =
        projectWithDetails.tasks.where((t) => !t.isCompleted).toList();
    if (openTasks.isNotEmpty) {
      return 'Next task: ${openTasks.first.title}';
    }
    if (projectWithDetails.milestones.isEmpty && projectWithDetails.tasks.isEmpty) {
      return 'Tap to add milestones or tasks';
    }
    return 'All milestones and tasks completed';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final project = projectWithDetails.project;
    final progress = projectWithDetails.progressPercentage.clamp(0.0, 1.0);
    final percentInt = (progress * 100).round();

    final surfaceColor =
        isDark ? AppColors.darkProjectSurface : AppColors.projectSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.projectBorder;
    final accentColor = isDark ? AppColors.primaryDark : AppColors.projectAccent;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Material(
      color: variant == ProjectCardVariant.standard
          ? (isDark ? AppColors.darkSurface : AppColors.surface)
          : surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.roundedCard,
        side: BorderSide(
          color: variant == ProjectCardVariant.standard
              ? (isDark ? AppColors.darkBorder : AppColors.border)
              : borderColor,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.roundedCard,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Category chip + Status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AppBadge(
                      label: project.category,
                      color: accentColor,
                      icon: AppIcons.projects,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(child: AppStatusBadge(status: project.status)),
                ],
              ),
              const SizedBox(height: 12.0),

              // Project Name
              Text(
                project.name,
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 17.0,
                  color: textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),

              // Next real milestone or task
              Text(
                _nextStepLabel(),
                style: AppTypography.secondary.copyWith(
                  fontSize: 12.5,
                  color: textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14.0),

              // Progress header + percentage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${projectWithDetails.completedMilestonesCount}/${projectWithDetails.totalMilestonesCount} milestones • ${projectWithDetails.totalTasksCount} tasks',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.metadata.copyWith(
                        color: textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '$percentInt%',
                    style: AppTypography.cardPercent.copyWith(color: accentColor),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              AppProgressBar(
                progress: progress,
                progressColor: accentColor,
                backgroundColor: accentColor.withOpacity(0.15),
                height: 6.0,
              ),

              if (project.targetDate != null) ...[
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Icon(AppIcons.calendar, size: 12.0, color: textSecondary),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        'Target ${DateFormatters.monthDayYear(project.targetDate!)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.metadata.copyWith(color: textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
