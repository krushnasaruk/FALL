import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../data/repositories/rewards_repository.dart';
import 'app_badges.dart';
import 'app_button.dart';
import 'companion_avatar.dart';

/// Calm, celebratory achievement unlock dialog allowing immediate dismissal without waiting.
class RewardCelebrationDialog extends StatelessWidget {
  final AchievementDefinition achievement;
  final int? xpEarned;

  const RewardCelebrationDialog({
    super.key,
    required this.achievement,
    this.xpEarned,
  });

  static Future<void> show(
    BuildContext context, {
    required AchievementDefinition achievement,
    int? xpEarned,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => RewardCelebrationDialog(
        achievement: achievement,
        xpEarned: xpEarned,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryCol = isDark ? AppColors.primaryDark : AppColors.primary;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedXl),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CompanionAvatar(
                expression: CompanionExpression.achievement,
                size: 82.0,
                animate: true,
              ),
              const SizedBox(width: AppSpacing.sm),
              Image.asset(
                achievement.badgeAsset,
                width: 64.0,
                height: 64.0,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.emoji_events_rounded,
                  size: 46.0,
                  color: primaryCol,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppBadge(
            label: achievement.category.toUpperCase(),
            color: primaryCol,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            achievement.title,
            style: AppTypography.titleLarge.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            achievement.description,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          if (xpEarned != null && xpEarned! > 0) ...[
            const SizedBox(height: AppSpacing.md),
            AppBadge(
              label: '+$xpEarned XP',
              color: AppColors.success,
              icon: Icons.bolt_rounded,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Continue',
            isFullWidth: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

