import 'package:flutter/material.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;
  final String? label;
  final bool showPercentage;
  final Color? textColor;

  const AppProgressBar({
    super.key,
    required this.progress,
    Color? progressColor,
    Color? barColor,
    this.backgroundColor,
    this.height = 5.0,
    this.label,
    this.showPercentage = false,
    this.textColor,
  }) : progressColor = barColor ?? progressColor;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final activeColor = progressColor ?? Colors.black87;
    final bg = backgroundColor ?? activeColor.withOpacity(0.18);
    final textStyle = AppTypography.caption.copyWith(
      color: textColor ?? Colors.black54,
      fontWeight: FontWeight.w600,
    );

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
                  style: textStyle,
                ),
              if (showPercentage)
                Text(
                  '${(clampedProgress * 100).toInt()}%',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor ?? activeColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6.0),
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
