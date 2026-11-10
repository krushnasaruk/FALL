import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

/// Neutral Information Card: clean white surface (light) or slate surface (dark),
/// subtle hairline border, consistent radius (18px), zero visual clutter.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius = AppRadii.card,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.surface);
    final border = borderColor ?? (isDark ? AppColors.darkBorder : AppColors.border);

    final inner = Container(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.card,
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: border, width: 1.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: (isDark ? AppColors.primaryDark : AppColors.primary).withOpacity(0.06),
          child: inner,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border, width: 1.0),
      ),
      padding: padding ?? AppSpacing.card,
      child: child,
    );
  }
}
