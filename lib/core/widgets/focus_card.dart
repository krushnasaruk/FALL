import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable Focus Card summarizing accumulated focus minutes or quick launch target.
class FocusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeValue;
  final VoidCallback? onTap;
  final VoidCallback? onStartTap;

  const FocusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeValue,
    this.onTap,
    this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkFocusSurface : AppColors.focusSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.focusBorder;
    final fg = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subCol = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.roundedCard,
        side: BorderSide(color: border),
      ),
      child: InkWell(
        onTap: onTap ?? onStartTap,
        borderRadius: AppRadii.roundedCard,
        child: Padding(
          padding: AppSpacing.card,
          child: Row(
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: AppRadii.roundedMd,
                  border: Border.all(color: border),
                ),
                child: const Icon(AppIcons.focusActive, color: AppColors.focusAccent, size: 22.0),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.cardTitle.copyWith(color: fg),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: AppTypography.secondary.copyWith(color: subCol),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeValue,
                    style: AppTypography.statMedium.copyWith(
                      fontSize: 18.0,
                      color: fg,
                    ),
                  ),
                  if (onStartTap != null)
                    Text(
                      'Start session',
                      style: AppTypography.metadata.copyWith(
                        color: AppColors.focusAccent,
                        fontWeight: FontWeight.w600,
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

