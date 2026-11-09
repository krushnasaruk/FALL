import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final border = borderColor ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    final card = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.roundedMd,
        border: Border.all(color: border, width: 1.0),
      ),
      padding: padding ?? AppSpacing.card,
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: AppRadii.roundedMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.roundedMd,
          splashColor: (isDark ? AppColors.primary : Colors.black).withOpacity(0.06),
          child: card,
        ),
      );
    }

    return card;
  }
}

