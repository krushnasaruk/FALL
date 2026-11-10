import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../services/feedback_service.dart';

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

/// Consistent, accessible button component.
/// Uses MainAxisSize.min cleanly so it works safely inside ListTile.trailing and Rows.
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

    final double minHeight;
    final EdgeInsets padding;
    final TextStyle textStyle;
    final double iconSize;

    switch (size) {
      case AppButtonSize.small:
        minHeight = 36.0;
        padding = const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0);
        textStyle = AppTypography.metadata.copyWith(fontWeight: FontWeight.w600, fontSize: 12.5);
        iconSize = 15.0;
        break;
      case AppButtonSize.medium:
        minHeight = 44.0;
        padding = const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0);
        textStyle = AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600);
        iconSize = 18.0;
        break;
      case AppButtonSize.large:
        minHeight = 52.0;
        padding = const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0);
        textStyle = AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600);
        iconSize = 20.0;
        break;
    }

    Color backgroundColor;
    Color foregroundColor;
    BorderSide border;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = isDark ? AppColors.primaryDark : AppColors.primary;
        foregroundColor = Colors.white;
        border = BorderSide.none;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated;
        foregroundColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
        border = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.0,
        );
        break;
      case AppButtonVariant.outline:
        backgroundColor = isDark ? Colors.transparent : AppColors.surface;
        foregroundColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
        border = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.0,
        );
        break;
      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
        border = BorderSide.none;
        break;
      case AppButtonVariant.danger:
        backgroundColor = AppColors.error;
        foregroundColor = Colors.white;
        border = BorderSide.none;
        break;
    }

    final effectiveTextStyle = textStyle.copyWith(color: foregroundColor);

    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: iconSize, color: foregroundColor),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            style: effectiveTextStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );

    final button = Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: label,
      child: _TapScaleWrapper(
        enabled: !isLoading && onPressed != null,
        child: Material(
          color: onPressed == null ? backgroundColor.withOpacity(0.5) : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.roundedFull,
            side: border,
          ),
          child: InkWell(
            onTap: (isLoading || onPressed == null)
                ? null
                : () {
                    FeedbackService.triggerButtonTapSafely(context);
                    onPressed!();
                  },
            borderRadius: AppRadii.roundedFull,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Padding(
                padding: padding,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

/// Named Primary CTA alias matching design system specification.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonSize size;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = AppButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
    );
  }
}

/// Named Secondary Action button alias matching design system specification.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonSize size;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = AppButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
    );
  }
}

/// Consistent 44x44 / 48x48 accessible rounded icon button.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size = 44.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.surface);
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final fg = iconColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);

    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
            side: BorderSide(color: border, width: 1.0),
          ),
          child: _TapScaleWrapper(
            enabled: onPressed != null,
            child: InkWell(
              onTap: onPressed == null
                  ? null
                  : () {
                      FeedbackService.triggerButtonTapSafely(context);
                      onPressed!();
                    },
              borderRadius: BorderRadius.circular(14.0),
              child: SizedBox(
                width: size,
                height: size,
                child: Icon(icon, size: 20.0, color: fg),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TapScaleWrapper extends StatefulWidget {
  final bool enabled;
  final Widget child;

  const _TapScaleWrapper({required this.enabled, required this.child});

  @override
  State<_TapScaleWrapper> createState() => _TapScaleWrapperState();
}

class _TapScaleWrapperState extends State<_TapScaleWrapper> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduced = AppMotion.isReducedMotion(context);
    return Listener(
      onPointerDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onPointerUp: (_) {
        if (_pressed) setState(() => _pressed = false);
      },
      onPointerCancel: (_) {
        if (_pressed) setState(() => _pressed = false);
      },
      child: AnimatedScale(
        scale: (_pressed && widget.enabled && !reduced) ? AppMotion.pressScale : 1.0,
        duration: AppMotion.resolveDuration(context, AppMotion.fast),
        curve: AppMotion.easeOut,
        child: widget.child,
      ),
    );
  }
}
