import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

/// Meaningful, encouraging Empty State with optional illustration asset / custom visual,
/// crisp heading, concise supportive description, and clear primary CTA.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final String? illustrationAsset;
  final Widget? illustration;
  final double illustrationSize;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.illustrationAsset,
    this.illustration,
    this.illustrationSize = 118.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget visual;
    if (illustration != null) {
      visual = illustration!;
    } else if (illustrationAsset != null) {
      visual = SizedBox(
        width: illustrationSize,
        height: illustrationSize,
        child: Image.asset(
          illustrationAsset!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _FallbackIconBadge(icon: icon, isDark: isDark),
        ),
      );
    } else {
      visual = _FallbackIconBadge(icon: icon, isDark: isDark);
    }

    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            visual,
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300.0),
              child: Text(
                description,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                size: AppButtonSize.medium,
                variant: AppButtonVariant.primary,
              ),
            ],
            if (secondaryActionLabel != null && onSecondaryAction != null) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: secondaryActionLabel!,
                onPressed: onSecondaryAction,
                size: AppButtonSize.small,
                variant: AppButtonVariant.ghost,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FallbackIconBadge extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const _FallbackIconBadge({required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
        borderRadius: AppRadii.roundedLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.0,
        ),
      ),
      child: Icon(
        icon,
        size: 30.0,
        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
      ),
    );
  }
}

typedef EmptyState = EmptyStateView;

class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: isDark ? AppColors.error.withOpacity(0.15) : AppColors.errorSoft,
                borderRadius: AppRadii.roundedLg,
              ),
              child: const Icon(Icons.refresh_rounded, size: 28.0, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "Couldn't load this right now",
              style: AppTypography.cardTitle.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Try Again',
                onPressed: onRetry,
                size: AppButtonSize.small,
                variant: AppButtonVariant.outline,
                icon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

typedef ErrorState = ErrorStateView;

/// Controlled subtle opacity shimmer block that automatically stops when disposed
/// and disables motion cleanly if reduced motion is preferred.
class ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = AppRadii.roundedCard,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = AppMotion.isReducedMotion(context);
    if (reduced) {
      _controller?.dispose();
      _controller = null;
    } else {
      _controller ??= AnimationController(
        vsync: this,
        duration: AppMotion.shimmer,
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (_controller == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: widget.borderRadius,
          border: Border.all(color: borderColor, width: 0.7),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        final opacity = 0.55 + (_controller!.value * 0.40);
        return Opacity(
          opacity: opacity,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: widget.borderRadius,
              border: Border.all(color: borderColor, width: 0.7),
            ),
          ),
        );
      },
    );
  }
}

/// Generic multi-row card skeleton matching card spacing cleanly.
class LoadingSkeleton extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const LoadingSkeleton({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 84.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal, vertical: AppSpacing.sm),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: ShimmerBox(height: itemHeight),
          );
        }),
      ),
    );
  }
}

/// Dashboard-matched skeleton: Greeting, Hero Today card, 2x2 KPI grid, and Upcoming task rows.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.lg,
        AppSpacing.pageHorizontal,
        32.0,
      ),
      children: const [
        Row(
          children: [
            ShimmerBox(width: 44, height: 44, borderRadius: AppRadii.roundedMd),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 110, height: 12, borderRadius: AppRadii.roundedXs),
                  SizedBox(height: 8),
                  ShimmerBox(width: 170, height: 22, borderRadius: AppRadii.roundedSm),
                ],
              ),
            ),
            ShimmerBox(width: 40, height: 40, borderRadius: AppRadii.roundedMd),
          ],
        ),
        SizedBox(height: AppSpacing.xl),
        ShimmerBox(height: 126, borderRadius: AppRadii.roundedCardLg),
        SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 40, borderRadius: AppRadii.roundedFull)),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: ShimmerBox(height: 40, borderRadius: AppRadii.roundedFull)),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: ShimmerBox(height: 40, borderRadius: AppRadii.roundedFull)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 88)),
            SizedBox(width: AppSpacing.md),
            Expanded(child: ShimmerBox(height: 88)),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 88)),
            SizedBox(width: AppSpacing.md),
            Expanded(child: ShimmerBox(height: 88)),
          ],
        ),
        SizedBox(height: AppSpacing.xl),
        ShimmerBox(width: 140, height: 18, borderRadius: AppRadii.roundedXs),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 68),
        SizedBox(height: AppSpacing.sm),
        ShimmerBox(height: 68),
      ],
    );
  }
}

/// Tasks-matched skeleton: Filter strip + task card rows.
class TasksSkeleton extends StatelessWidget {
  const TasksSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.sm,
      ),
      children: const [
        ShimmerBox(height: 76),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 76),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 76),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 76),
      ],
    );
  }
}

/// Projects-matched skeleton: Folder/card layout placeholders.
class ProjectsSkeleton extends StatelessWidget {
  const ProjectsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.sm,
      ),
      children: const [
        ShimmerBox(height: 152, borderRadius: AppRadii.roundedCardLg),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 132),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 132),
      ],
    );
  }
}

/// Analytics-matched skeleton: Execution ring card + 2x2 KPIs + chart rectangle.
class AnalyticsSkeleton extends StatelessWidget {
  const AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
      child: Column(
        children: [
          ShimmerBox(height: 240, borderRadius: AppRadii.roundedCardLg),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 86)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: ShimmerBox(height: 86)),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 86)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: ShimmerBox(height: 86)),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          ShimmerBox(height: 168),
        ],
      ),
    );
  }
}

typedef LoadingState = LoadingSkeleton;
