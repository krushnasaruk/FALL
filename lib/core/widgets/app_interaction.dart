import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../services/feedback_service.dart';
import 'app_button.dart';

/// Tactile press wrapper giving subtle compression (`1.0 -> 0.97`) without distracting bounce.
class AppPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool triggerHaptic;

  const AppPressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.triggerHaptic = true,
  });

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _pressed = false;

  void _setPressed(bool next) {
    if (_pressed == next || widget.onTap == null) return;
    setState(() => _pressed = next);
  }

  @override
  Widget build(BuildContext context) {
    final reduced = AppMotion.isReducedMotion(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap != null ? (_) => _setPressed(true) : null,
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (widget.triggerHaptic) {
                FeedbackService.triggerButtonTapSafely(context);
              }
              widget.onTap!();
            },
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _pressed && !reduced ? AppMotion.pressScale : 1.0,
        duration: AppMotion.resolveDuration(context, AppMotion.fast),
        curve: AppMotion.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Calm numeric interpolation helper that settles smoothly whenever underlying metrics change
/// and avoids idle continuous animation loops.
class AnimatedNumericValue extends StatelessWidget {
  final double value;
  final Widget Function(BuildContext context, double animatedValue) builder;

  const AnimatedNumericValue({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value),
      duration: AppMotion.resolveDuration(context, AppMotion.slow),
      curve: AppMotion.easeOut,
      builder: (context, val, _) => builder(context, val),
    );
  }
}

/// Contextual first-encounter discovery banner shown once cleanly inside relevant workflows
/// until dismissed (persisted per tip ID).
class DismissibleTipBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onDismiss;
  final Color? accentColor;

  const DismissibleTipBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.onDismiss,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = accentColor ?? (isDark ? AppColors.primaryDark : AppColors.primary);
    final bg = isDark ? AppColors.darkProjectSurface : AppColors.primarySoft.withOpacity(0.55);
    final border = isDark ? AppColors.darkBorder : accent.withOpacity(0.22);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.fromLTRB(14.0, 12.0, 10.0, 12.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.roundedCard,
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: AppRadii.roundedSm,
            ),
            child: Icon(icon, size: 17.0, color: accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  message,
                  style: AppTypography.metadata.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    height: 1.38,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            tooltip: 'Dismiss tip',
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.close_rounded,
              size: 18.0,
              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

enum UnsavedChoice { keepEditing, discard, save }

/// Standardized guard when attempting to dismiss an edited form with unsaved input.
Future<UnsavedChoice> confirmDiscardChanges(
  BuildContext context, {
  bool allowSaveOption = false,
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final choice = await showDialog<UnsavedChoice>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedXl),
      title: Text(
        'Keep editing?',
        style: AppTypography.titleMedium.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      content: Text(
        'You have unsaved edits that will be lost if you close this screen.',
        style: AppTypography.bodySmall.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(UnsavedChoice.discard),
          child: const Text('Discard', style: TextStyle(color: AppColors.error)),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(UnsavedChoice.keepEditing),
          child: const Text('Keep editing'),
        ),
        if (allowSaveOption)
          AppButton(
            label: 'Save',
            size: AppButtonSize.small,
            onPressed: () => Navigator.of(ctx).pop(UnsavedChoice.save),
          ),
      ],
    ),
  );
  return choice ?? UnsavedChoice.keepEditing;
}

