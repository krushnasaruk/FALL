import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../radar_models.dart';
import '../radar_taxonomy.dart';

/// Adaptive card tailored cleanly by discovery type (`repo`, `video`, `research`, `model`, `product`, `community`, `article`)
/// while showing only factual recorded metrics and explicit provenance indicators.
class RadarDiscoveryCard extends StatelessWidget {
  final RadarDiscoveryItem item;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;
  final VoidCallback? onMoreLikeThis;
  final VoidCallback? onLessLikeThis;

  const RadarDiscoveryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleBookmark,
    this.onMoreLikeThis,
    this.onLessLikeThis,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = RadarTaxonomy.byCode(item.primaryCategory);
    final compactFmt = NumberFormat.compact();

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Type badge + Category chip + Exploratory tag + Bookmark icon
          Row(
            children: [
              _TypeBadge(type: item.discoveryType, accent: cat.accentColor),
              const SizedBox(width: 6.0),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: cat.accentColor.withOpacity(isDark ? 0.20 : 0.10),
                    borderRadius: AppRadii.roundedXs,
                  ),
                  child: Text(
                    '${cat.shortLabel} · ${item.priorityTier}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.metadata.copyWith(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      color: cat.accentColor,
                    ),
                  ),
                ),
              ),
              if (item.isExploratory) ...[
                const SizedBox(width: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkFocusSurface : AppColors.focusSurface),
                    borderRadius: AppRadii.roundedXs,
                  ),
                  child: Text(
                    'Explore',
                    style: AppTypography.metadata.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.focusAccent,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                onPressed: onToggleBookmark,
                tooltip: item.isBookmarked ? 'Remove bookmark' : 'Save discovery',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                icon: Icon(
                  item.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  size: 20.0,
                  color: item.isBookmarked
                      ? (isDark ? AppColors.primaryDark : AppColors.primary)
                      : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Title
          Text(
            item.title,
            style: AppTypography.cardTitle.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              height: 1.28,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6.0),

          // Summary excerpt or grounded explanation
          if (item.displaySummary.trim().isNotEmpty)
            Text(
              item.displaySummary,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

          if (item.whyItMatters != null && item.whyItMatters!.trim().isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
                borderRadius: AppRadii.roundedSm,
              ),
              child: Text(
                'Why it matters: ${item.whyItMatters!}',
                style: AppTypography.metadata.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          const SizedBox(height: 10.0),

          // Bottom provenance, factual metrics & quick feedback
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _MetaChip(
                icon: Icons.rss_feed_rounded,
                label: item.authorOrOrg != null && item.authorOrOrg!.isNotEmpty
                    ? '${item.sourceName} · ${item.authorOrOrg}'
                    : item.sourceName,
                isDark: isDark,
              ),
              if (item.primaryMetricLabel != null && item.primaryMetricValue != null)
                _MetaChip(
                  icon: item.discoveryType == 'repo'
                      ? Icons.star_outline_rounded
                      : Icons.trending_up_rounded,
                  label: '${compactFmt.format(item.primaryMetricValue!)} ${item.primaryMetricLabel}',
                  isDark: isDark,
                ),
              if (item.metricDeltaLabel != null &&
                  item.metricDeltaValue != null &&
                  item.metricDeltaValue != 0)
                _MetaChip(
                  icon: Icons.north_east_rounded,
                  label:
                      '${item.metricDeltaValue! > 0 ? "+" : ""}${compactFmt.format(item.metricDeltaValue!)} ${item.metricDeltaLabel}',
                  isDark: isDark,
                  highlightColor: AppColors.success,
                ),
              if (item.analysisSource == 'gemini')
                _MetaChip(
                  icon: Icons.auto_awesome_outlined,
                  label: 'AI Brief',
                  isDark: isDark,
                  highlightColor: isDark ? AppColors.primaryDark : AppColors.primary,
                ),
            ],
          ),

          if (onMoreLikeThis != null || onLessLikeThis != null) ...[
            const SizedBox(height: 8.0),
            Row(
              children: [
                if (item.sources.length > 1)
                  Text(
                    'Seen in ${item.sources.length} sources',
                    style: AppTypography.metadata.copyWith(
                      fontSize: 11.0,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                  ),
                const Spacer(),
                if (onMoreLikeThis != null)
                  _FeedbackActionText(
                    icon: Icons.thumb_up_alt_outlined,
                    label: 'Relevant',
                    onTap: onMoreLikeThis!,
                    isDark: isDark,
                  ),
                if (onLessLikeThis != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  _FeedbackActionText(
                    icon: Icons.thumb_down_alt_outlined,
                    label: 'Less',
                    onTap: onLessLikeThis!,
                    isDark: isDark,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  final Color accent;

  const _TypeBadge({required this.type, required this.accent});

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String label) = switch (type.toLowerCase()) {
      'repo' => (Icons.folder_open_rounded, 'REPO'),
      'video' => (Icons.play_arrow_rounded, 'VIDEO'),
      'research' => (Icons.science_outlined, 'PAPER'),
      'model' => (Icons.hub_outlined, 'MODEL'),
      'product' => (Icons.rocket_launch_outlined, 'LAUNCH'),
      'community' => (Icons.forum_outlined, 'THREAD'),
      _ => (Icons.article_outlined, 'POST'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: AppRadii.roundedXs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.0, color: Colors.white),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: AppTypography.metadata.copyWith(
              fontSize: 10.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color? highlightColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.isDark,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        highlightColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.0, color: color),
        const SizedBox(width: 4.0),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 165.0),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.metadata.copyWith(
              fontSize: 11.5,
              color: color,
              fontWeight: highlightColor != null ? FontWeight.w600 : FontWeight.w500,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeedbackActionText extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _FeedbackActionText({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final col = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.roundedXs,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.0, color: col),
            const SizedBox(width: 4.0),
            Text(
              label,
              style: AppTypography.metadata.copyWith(fontSize: 11.0, color: col),
            ),
          ],
        ),
      ),
    );
  }
}

