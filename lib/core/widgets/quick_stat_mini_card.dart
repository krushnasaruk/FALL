import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

enum QuickStatVariant {
  tasks,
  projects,
  learning,
  focus,
  goals,
}

class QuickStatMiniCard extends StatelessWidget {
  final QuickStatVariant variant;
  final String title;
  final String value;
  final String? badgeText;
  final VoidCallback? onTap;

  const QuickStatMiniCard({
    super.key,
    required this.variant,
    required this.title,
    required this.value,
    this.badgeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _configForVariant(variant, isDark);

    return Semantics(
      button: onTap != null,
      label: '$title: $value${badgeText != null ? ", $badgeText" : ""}',
      child: Material(
        color: config.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.roundedCard,
          side: BorderSide(color: config.borderColor, width: 1.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.roundedCard,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 26.0,
                      height: 26.0,
                      decoration: BoxDecoration(
                        color: config.accentColor.withOpacity(isDark ? 0.22 : 0.14),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(config.icon, size: 15.0, color: config.accentColor),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.secondary.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children: [
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.statMedium.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      if (badgeText != null && badgeText!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.white.withOpacity(0.85),
                            borderRadius: AppRadii.roundedXs,
                          ),
                          child: Text(
                            badgeText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.metadata.copyWith(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                              color: config.accentColor,
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _StatConfig _configForVariant(QuickStatVariant variant, bool isDark) {
    switch (variant) {
      case QuickStatVariant.tasks:
        return _StatConfig(
          backgroundColor: isDark ? AppColors.darkTaskSurface : AppColors.taskSurface,
          borderColor: isDark ? AppColors.darkBorder : AppColors.taskBorder,
          accentColor: AppColors.taskAccent,
          icon: AppIcons.tasks,
        );
      case QuickStatVariant.projects:
        return _StatConfig(
          backgroundColor: isDark ? AppColors.darkProjectSurface : AppColors.projectSurface,
          borderColor: isDark ? AppColors.darkBorder : AppColors.projectBorder,
          accentColor: AppColors.projectAccent,
          icon: AppIcons.projects,
        );
      case QuickStatVariant.learning:
        return _StatConfig(
          backgroundColor: isDark ? AppColors.darkLearningSurface : AppColors.learningSurface,
          borderColor: isDark ? AppColors.darkBorder : AppColors.learningBorder,
          accentColor: AppColors.learningAccent,
          icon: AppIcons.learning,
        );
      case QuickStatVariant.focus:
        return _StatConfig(
          backgroundColor: isDark ? AppColors.darkFocusSurface : AppColors.focusSurface,
          borderColor: isDark ? AppColors.darkBorder : AppColors.focusBorder,
          accentColor: AppColors.focusAccent,
          icon: AppIcons.focus,
        );
      case QuickStatVariant.goals:
        return _StatConfig(
          backgroundColor: isDark ? AppColors.darkGoalSurface : AppColors.goalSurface,
          borderColor: isDark ? AppColors.darkBorder : AppColors.goalBorder,
          accentColor: AppColors.goalAccent,
          icon: AppIcons.goals,
        );
    }
  }
}

class _StatConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color accentColor;
  final IconData icon;

  const _StatConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.accentColor,
    required this.icon,
  });
}
