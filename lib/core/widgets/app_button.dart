import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dimensions
    final double height;
    final EdgeInsets padding;
    final TextStyle textStyle;
    final double iconSize;

    switch (size) {
      case AppButtonSize.small:
        height = 34.0;
        padding = const EdgeInsets.symmetric(horizontal: 12.0);
        textStyle = AppTypography.caption.copyWith(fontWeight: FontWeight.w600);
        iconSize = 14.0;
        break;
      case AppButtonSize.medium:
        height = 42.0;
        padding = const EdgeInsets.symmetric(horizontal: 16.0);
        textStyle = AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600);
        iconSize = 18.0;
        break;
      case AppButtonSize.large:
        height = 50.0;
        padding = const EdgeInsets.symmetric(horizontal: 20.0);
        textStyle = AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600);
        iconSize = 20.0;
        break;
    }

    // Styling based on variant
    Color backgroundColor;
    Color foregroundColor;
    BorderSide border;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = const Color(0xFF0F172A);
        border = BorderSide.none;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;
        foregroundColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        border = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.0,
        );
        break;
      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        border = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.0,
        );
        break;
      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
        border = BorderSide.none;
        break;
      case AppButtonVariant.danger:
        backgroundColor = AppColors.error;
        foregroundColor = Colors.white;
        border = BorderSide.none;
        break;
    }

    final effectiveTextStyle = textStyle.copyWith(color: foregroundColor);

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: iconSize, color: foregroundColor),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(label, style: effectiveTextStyle),
      ],
    );

    final button = Material(
      color: onPressed == null ? backgroundColor.withOpacity(0.5) : backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.roundedMd,
        side: border,
      ),
      child: InkWell(
        onTap: (isLoading || onPressed == null) ? null : onPressed,
        borderRadius: AppRadii.roundedMd,
        child: Container(
          height: height,
          padding: padding,
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
