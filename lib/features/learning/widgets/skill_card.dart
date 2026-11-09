import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../data/repositories/learning_repository.dart';

class SkillCard extends StatelessWidget {
  final SkillWithRoadmap skillWithRoadmap;
  final VoidCallback onTap;

  const SkillCard({
    super.key,
    required this.skillWithRoadmap,
    required this.onTap,
  });

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'language':
        return AppColors.techLanguage;
      case 'framework':
        return AppColors.techFramework;
      case 'ai':
      case 'machine learning':
        return AppColors.techAI;
      case 'systems':
      case 'iot':
      case 'embedded':
        return AppColors.techSystems;
      case 'database':
      case 'sql':
        return AppColors.techDatabase;
      default:
        return AppColors.techCloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skill = skillWithRoadmap.skill;
    final categoryColor = _getCategoryColor(skill.category);

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Category chip & Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.12),
                  borderRadius: AppRadii.roundedXs,
                ),
                child: Text(
                  skill.category.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: categoryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.0,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.bolt_rounded, size: 14.0, color: AppColors.primary),
                  const SizedBox(width: 3.0),
                  Text(
                    '${skill.currentLevel.toUpperCase()} → ${skill.targetLevel.toUpperCase()}',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Skill Name
          Text(
            skill.name,
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          if (skill.notes != null && skill.notes!.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              skill.notes!,
              style: AppTypography.caption.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          // Progress Bar & Topic Metrics
          AppProgressBar(
            progress: skillWithRoadmap.progressPercentage,
            progressColor: categoryColor,
            label: '${skillWithRoadmap.completedTopics} of ${skillWithRoadmap.totalTopics} topics mastered',
            showPercentage: true,
          ),
          const SizedBox(height: AppSpacing.md),

          // Bottom metrics: Learning hours & session count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: 14.0,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${DateFormatters.formatMinutes(skill.learningMinutes)} logged',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 14.0,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${skillWithRoadmap.modules.length} modules',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
