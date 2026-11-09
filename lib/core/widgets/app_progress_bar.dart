import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;
  final String? label;
  final bool showPercentage;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.progressColor,
    this.backgroundColor,
    this.height = 8.0,
    this.label,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedProgress = progress.clamp(0.0, 1.0);

    final bg = backgroundColor ??
        (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated);
    final activeColor = progressColor ?? AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: AppTypography.caption.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              if (showPercentage)
                Text(
                  '${(clampedProgress * 100).toInt()}%',
                  style: AppTypography.monoSmall.copyWith(
                    color: activeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppRadii.roundedFull,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * clampedProgress,
                    height: height,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: AppRadii.roundedFull,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
