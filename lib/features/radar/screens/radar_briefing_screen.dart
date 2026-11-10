import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/state_views.dart';
import '../../../services/feedback_service.dart';
import '../radar_sync_service.dart';
import '../radar_taxonomy.dart';

/// Displays structured 10-section Daily Briefing synced from ProgressOS Radar Server.
class RadarBriefingScreen extends ConsumerWidget {
  const RadarBriefingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final briefingAsync = ref.watch(radarDailyBriefingStreamProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        elevation: 0,
        title: const Text('Daily Tech Briefing', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            onPressed: () => ref.read(radarSyncProvider.notifier).syncNow(),
            tooltip: 'Refresh Briefing',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: briefingAsync.when(
        loading: () => const LoadingSkeleton(),
        error: (err, _) => ErrorStateView(message: 'Failed to load briefing: $err'),
        data: (briefing) {
          if (briefing == null || briefing.sections.isEmpty) {
            return EmptyStateView(
              icon: Icons.newspaper_rounded,
              title: 'No briefing synced yet',
              description:
                  'Connect to your ProgressOS Radar Server and tap Sync Radar to generate today\'s structured 10-part technology briefing.',
              actionLabel: 'Sync Radar Now',
              onAction: () => ref.read(radarSyncProvider.notifier).syncNow(),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.sm,
              AppSpacing.pageHorizontal,
              40.0,
            ),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      briefing.briefingDate.isEmpty ? 'Latest Briefing' : briefing.briefingDate,
                      style: AppTypography.metadata.copyWith(
                        color: isDark ? AppColors.primaryDark : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      briefing.headline,
                      style: AppTypography.titleLarge.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...briefing.sections.map((section) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: AppTypography.sectionTitle.copyWith(
                            fontSize: 15.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        if (section.items.isEmpty)
                          Text(
                            section.emptyNote ?? 'No qualifying items yet in this category.',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          )
                        else
                          ...section.items.map((item) {
                            final title = (item['title'] ?? '').toString();
                            final summary = (item['summary'] ?? '').toString();
                            final source = (item['source_name'] ?? '').toString();
                            final url = (item['canonical_url'] ?? '').toString();
                            final cat = RadarTaxonomy.byCode(
                              (item['category_code'] ?? 'B').toString(),
                            );
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: InkWell(
                                borderRadius: AppRadii.roundedSm,
                                onTap: url.isEmpty
                                    ? null
                                    : () async {
                                        final ok = await ref
                                            .read(feedbackServiceProvider)
                                            .openExternalUrl(url);
                                        if (!ok && context.mounted) {
                                          AppToast.show(context, 'Link copied: $url');
                                        }
                                      },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurfaceElevated
                                        : AppColors.surfaceElevated,
                                    borderRadius: AppRadii.roundedSm,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: AppTypography.cardTitle.copyWith(
                                          fontSize: 14.5,
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (summary.isNotEmpty) ...[
                                        const SizedBox(height: 4.0),
                                        Text(
                                          summary,
                                          style: AppTypography.bodySmall.copyWith(
                                            color: isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.textSecondary,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${cat.shortLabel} · $source',
                                        style: AppTypography.metadata.copyWith(
                                          fontSize: 11.0,
                                          color: cat.accentColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
