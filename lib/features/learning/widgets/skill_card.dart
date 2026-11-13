import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../data/repositories/learning_repository.dart';

enum LearningCardVariant {
  standard,
}

/// Reusable Learning Card: Skill name, level progression, real progress calculation,
/// target recognition, and invested time.
class LearningCard extends StatelessWidget {
  final SkillWithRoadmap skillWithRoadmap;
  final VoidCallback onTap;
  final Gradient? gradient;

  const LearningCard({
    super.key,
    required this.skillWithRoadmap,
    required this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skill = skillWithRoadmap.skill;
    final method = skill.progressMethod;
    final progress = skillWithRoadmap.progressPercentage.clamp(0.0, 1.0);
    final isOverachieved = skillWithRoadmap.isTimeTargetExceeded;

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final accent = isDark ? AppColors.primaryDark : AppColors.learningAccent;

    final latestSession =
        skillWithRoadmap.sessions.isNotEmpty ? skillWithRoadmap.sessions.first : null;

    String badgeLabel;
    String percentText;

    if (method == 'time') {
      if (skillWithRoadmap.hasTimeTarget) {
        final pctInt = (skillWithRoadmap.timeProgressPercentage! * 100).round();
        percentText = '$pctInt%';
        if (isOverachieved) {
          badgeLabel = 'Overachieved! 🌟';
        } else {
          badgeLabel =
              '${(skill.learningMinutes / 60).toStringAsFixed(1)}h / ${(skill.targetMinutes / 60).toStringAsFixed(0)}h';
        }
      } else {
        percentText = '—';
        badgeLabel = 'No target set';
      }
    } else if (method == 'manual') {
      final pctInt = (skill.manualProgressPercentage * 100).round();
      percentText = '$pctInt%';
      badgeLabel = 'User-reported';
    } else {
      // 'topics'
      if (skillWithRoadmap.totalTopics > 0) {
        final pctInt = (progress * 100).round();
        percentText = '$pctInt%';
        badgeLabel = '${skillWithRoadmap.completedTopics} of ${skillWithRoadmap.totalTopics} topics';
      } else {
        percentText = '—';
        badgeLabel = 'No topics yet';
      }
    }

    return Material(
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.roundedCard,
        side: BorderSide(color: borderColor, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.roundedCard,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkLearningSurface : AppColors.learningSurface,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Icon(AppIcons.learningActive, color: accent, size: 20.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.name,
                          style: AppTypography.cardTitle.copyWith(color: textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${skill.category} • ${skill.currentLevel} → ${skill.targetLevel}',
                          style: AppTypography.metadata.copyWith(color: textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    percentText,
                    style: AppTypography.statMedium.copyWith(
                      fontSize: 18.0,
                      color: isOverachieved ? AppColors.warning : accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              AppProgressBar(
                progress: progress,
                progressColor: isOverachieved ? AppColors.warning : accent,
                backgroundColor: accent.withOpacity(0.14),
                height: 6.0,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AppBadge(
                      label: badgeLabel,
                      color: isOverachieved ? AppColors.warning : accent,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      latestSession != null
                          ? '${DateFormatters.formatMinutes(skill.learningMinutes)} • ${DateFormatters.relativeDate(latestSession.createdAt)}'
                          : DateFormatters.formatMinutes(skill.learningMinutes),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTypography.metadata.copyWith(
                        color: textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef SkillCard = LearningCard;
