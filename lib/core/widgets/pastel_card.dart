import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Restrained Pastel Feature Card: soft tinted background with high-contrast text
/// and subtle hairline border. Zero decorative blobs or heavy drop shadows.
class PastelCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool hasOrganicWave; // Kept as optional flag defaulting false for API compatibility
  final Color? waveColor;

  const PastelCard({
    super.key,
    required this.child,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = AppRadii.card,
    this.width,
    this.height,
    this.hasOrganicWave = false,
    this.waveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveBorder = borderColor ??
        (isDark ? AppColors.darkBorder : Colors.black.withOpacity(0.05));

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isDark && backgroundColor == null ? null : gradient,
        color: backgroundColor ?? (isDark ? AppColors.darkSurface : null),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorder, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: (isDark ? AppColors.primaryDark : AppColors.primary).withOpacity(0.06),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
