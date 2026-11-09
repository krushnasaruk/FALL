import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/avatar_stack.dart';
import '../../../core/widgets/pastel_card.dart';
import '../../../data/repositories/project_repository.dart';

enum ProjectCardVariant {
  heroBanner,
  folderGrid,
  standard,
}

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

  static const List<LinearGradient> _folderGradients = [
    AppColors.projectPastelGradient,
    AppColors.taskPastelGradient,
    AppColors.habitPastelGradient,
    AppColors.learningPastelGradient,
    AppColors.goalPastelGradient,
    AppColors.analyticsPastelGradient,
  ];

  static const List<Color> _accentColors = [
    AppColors.projectPinkHero,
    Color(0xFF0284C7),
    Color(0xFF16A34A),
    Color(0xFF9333EA),
    Color(0xFFCA8A04),
    Color(0xFF0D9488),
  ];

  @override
  Widget build(BuildContext context) {
    final project = projectWithDetails.project;
    final progress = projectWithDetails.progressPercentage;
    final percent = (progress * 100).toInt();

    // 1. Hero Banner Variant (as seen on Reference Screen 1)
    if (variant == ProjectCardVariant.heroBanner) {
      return PastelCard(
        onTap: onTap,
        gradient: AppColors.projectHeroGradient,
        borderRadius: AppRadii.cardLg,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: AppTypography.cardHeader.copyWith(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Progress label & percent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: AppTypography.cardSub.copyWith(color: Colors.white70),
                ),
                Text(
                  '$percent%',
                  style: AppTypography.cardPercent.copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            AppProgressBar(
              progress: progress,
              progressColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.3),
              height: 5.0,
            ),
            const SizedBox(height: 16.0),

            // Metadata row
            Row(
              children: [
                const Icon(Icons.description_outlined, size: 14.0, color: Colors.white70),
                const SizedBox(width: 4.0),
                Text(
                  '${projectWithDetails.totalTasksCount} Tasks',
                  style: AppTypography.caption.copyWith(color: Colors.white),
                ),
                Container(
                  width: 1.0,
                  height: 12.0,
                  color: Colors.white38,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
                const Icon(Icons.flag_outlined, size: 14.0, color: Colors.white70),
                const SizedBox(width: 4.0),
                Text(
                  '${projectWithDetails.totalMilestonesCount} Milestones',
                  style: AppTypography.caption.copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Bottom row: Avatars + Date Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AvatarStack(size: 24.0, maxAvatars: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: AppRadii.roundedFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 11.0, color: Colors.white),
                      const SizedBox(width: 5.0),
                      Text(
                        project.targetDate != null
                            ? DateFormatters.monthDayYear(project.targetDate!)
                            : 'Active',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 2. Folder Grid Variant (as seen under "On Going Projects" on Screen 1)
    if (variant == ProjectCardVariant.folderGrid) {
      final gradient = _folderGradients[colorIndex % _folderGradients.length];
      final accent = _accentColors[colorIndex % _accentColors.length];

      return PastelCard(
        onTap: onTap,
        gradient: gradient,
        borderRadius: AppRadii.card,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: AppRadii.roundedXs,
                  ),
                  child: Text(
                    project.category.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      color: accent,
                      fontSize: 9.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.more_horiz_rounded, size: 16.0, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              project.name,
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${projectWithDetails.totalTasksCount} tasks',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.0,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  '$percent%',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            AppProgressBar(
              progress: progress,
              progressColor: accent,
              backgroundColor: accent.withOpacity(0.18),
              height: 4.5,
            ),
          ],
        ),
      );
    }

    // 3. Standard List Card Variant
    final gradient = _folderGradients[colorIndex % _folderGradients.length];
    final accent = _accentColors[colorIndex % _accentColors.length];

    return PastelCard(
      onTap: onTap,
      gradient: gradient,
      borderRadius: AppRadii.card,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: AppRadii.roundedSm,
                ),
                child: Text(
                  project.category.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: accent,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: AppRadii.roundedFull,
                    ),
                    child: Text(
                      project.status.toUpperCase(),
                      style: AppTypography.caption.copyWith(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            project.name,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                '$percent%',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          AppProgressBar(
            progress: progress,
            progressColor: accent,
            backgroundColor: accent.withOpacity(0.18),
            height: 5.0,
          ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AvatarStack(size: 22.0, maxAvatars: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: AppRadii.roundedFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 11.0, color: accent),
                    const SizedBox(width: 4.0),
                    Text(
                      project.targetDate != null
                          ? DateFormatters.monthDay(project.targetDate!)
                          : 'Ongoing',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
