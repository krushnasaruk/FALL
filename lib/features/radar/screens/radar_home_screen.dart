import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/companion_avatar.dart';
import '../../../core/widgets/state_views.dart';
import '../../../services/feedback_service.dart';
import '../radar_models.dart';
import '../radar_sync_service.dart';
import '../radar_taxonomy.dart';
import '../widgets/radar_discovery_card.dart';
import 'radar_detail_screen.dart';

/// Main ProgressOS Radar hub covering For You (70/30 mix), Explore, GitHub Radar,
/// Creators, AI & Models, Multi-Source Trends, Research, Opportunities, Saved & Global Search.
class RadarHomeScreen extends ConsumerStatefulWidget {
  const RadarHomeScreen({super.key});

  @override
  ConsumerState<RadarHomeScreen> createState() => _RadarHomeScreenState();
}

class _RadarHomeScreenState extends ConsumerState<RadarHomeScreen> {
  RadarFeedView _activeView = RadarFeedView.forYou;
  String? _selectedCategoryCode;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openCategoryFilterSheet() {
    showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        maxChildSize: 0.9,
        builder: (ctx, scrollCtrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Filter by Topic Category (A–R)', style: AppTypography.titleMedium),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(''),
                    child: const Text('All'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                children: RadarTaxonomy.categories.map((cat) {
                  final selected = _selectedCategoryCode == cat.code;
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: cat.accentColor.withOpacity(0.15),
                      child: Icon(cat.icon, size: 17, color: cat.accentColor),
                    ),
                    title: Text('${cat.code}. ${cat.name}'),
                    subtitle: Text(
                      '${cat.defaultPriority} · ${cat.description}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: selected ? const Icon(Icons.check_rounded) : null,
                    onTap: () => Navigator.of(ctx).pop(cat.code),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ).then((picked) {
      if (picked == null) return;
      setState(() => _selectedCategoryCode = picked.isEmpty ? null : picked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final syncState = ref.watch(radarSyncProvider);
    final feedback = ref.read(feedbackServiceProvider);
    final feedAsync = ref.watch(
      radarFeedStreamProvider((
        view: _activeView,
        categoryCode: _selectedCategoryCode,
        searchQuery: _searchQuery,
      )),
    );

    return AppScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.md,
              AppSpacing.pageHorizontal,
              AppSpacing.xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(
                  leading: const CompanionAvatar(
                    expression: CompanionExpression.curious,
                    size: 40.0,
                  ),
                  eyebrow: syncState.backendReachable
                      ? 'SERVER CONNECTED'
                      : 'PROGRESSOS RADAR',
                  title: 'Tech Radar',
                  actions: [
                    IconButton(
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        feedback.buttonTap();
                        context.push('/radar/briefings');
                      },
                      tooltip: 'Daily Tech Briefing',
                      icon: const Icon(Icons.newspaper_rounded, size: 21),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      onPressed: syncState.isSyncing
                          ? null
                          : () {
                              feedback.buttonTap();
                              ref.read(radarSyncProvider.notifier).syncNow();
                            },
                      tooltip: 'Sync Radar',
                      icon: syncState.isSyncing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync_rounded, size: 21),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        feedback.buttonTap();
                        context.push('/radar/settings');
                      },
                      tooltip: 'Radar Topics & Settings',
                      icon: const Icon(Icons.tune_rounded, size: 21),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Global Search + Category Filter Pill
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42.0,
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search repos, AI models, papers, creators...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 19),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 17),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                            filled: true,
                            fillColor:
                                isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
                            border: const OutlineInputBorder(
                              borderRadius: AppRadii.roundedFull,
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ActionChip(
                      avatar: Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: _selectedCategoryCode != null
                            ? (isDark ? AppColors.primaryDark : AppColors.primary)
                            : null,
                      ),
                      label: Text(
                        _selectedCategoryCode != null
                            ? RadarTaxonomy.byCode(_selectedCategoryCode!).shortLabel
                            : 'Topics (18)',
                      ),
                      onPressed: _openCategoryFilterSheet,
                    ),
                  ],
                ),

                if (syncState.lastStatusMessage != null) ...[
                  const SizedBox(height: 6.0),
                  Text(
                    syncState.lastStatusMessage!,
                    style: AppTypography.metadata.copyWith(
                      fontSize: 11.0,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Scrollable Tab Bar across all Radar Intelligence Lenses
          SizedBox(
            height: 44.0,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
              scrollDirection: Axis.horizontal,
              itemCount: RadarFeedView.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8.0),
              itemBuilder: (context, idx) {
                final v = RadarFeedView.values[idx];
                final selected = _activeView == v;
                return ChoiceChip(
                  label: Text(v.label),
                  selected: selected,
                  onSelected: (_) {
                    feedback.selectionClick();
                    setState(() => _activeView = v);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Active Feed / Trends Body
          Expanded(
            child: _activeView == RadarFeedView.trending
                ? _TrendingView(trends: syncState.trends, isDark: isDark)
                : feedAsync.when(
                    loading: () => const LoadingSkeleton(),
                    error: (err, _) => ErrorStateView(message: 'Failed to load feed: $err'),
                    data: (items) {
                      if (items.isEmpty) {
                        return EmptyStateView(
                          icon: Icons.radar_rounded,
                          title: _activeView == RadarFeedView.saved
                              ? 'Nothing bookmarked yet'
                              : 'Nothing synced in ${_activeView.label} yet',
                          description: _activeView == RadarFeedView.saved
                              ? 'Tap the bookmark icon on any Radar discovery to organize technologies & build ideas offline.'
                              : 'Tap Sync Radar to pull live discoveries from GitHub, Hacker News, Hugging Face, arXiv & creators.',
                          actionLabel:
                              _activeView == RadarFeedView.saved ? 'Browse For You' : 'Sync Radar',
                          onAction: () {
                            if (_activeView == RadarFeedView.saved) {
                              setState(() => _activeView = RadarFeedView.forYou);
                            } else {
                              ref.read(radarSyncProvider.notifier).syncNow();
                            }
                          },
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => ref.read(radarSyncProvider.notifier).syncNow(),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.pageHorizontal,
                            AppSpacing.xs,
                            AppSpacing.pageHorizontal,
                            88.0,
                          ),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, i) {
                            final item = items[i];
                            return RadarDiscoveryCard(
                              item: item,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RadarDetailScreen(item: item),
                                ),
                              ),
                              onToggleBookmark: () => ref
                                  .read(radarSyncProvider.notifier)
                                  .pushBookmark(item, saved: !item.isBookmarked),
                              onMoreLikeThis: () => ref
                                  .read(radarSyncProvider.notifier)
                                  .pushFeedback(item, 'relevant'),
                              onLessLikeThis: () => ref
                                  .read(radarSyncProvider.notifier)
                                  .pushFeedback(item, 'not_relevant'),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TrendingView extends ConsumerWidget {
  final List<RadarTrendCandidate> trends;
  final bool isDark;

  const _TrendingView({required this.trends, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (trends.isEmpty) {
      return EmptyStateView(
        icon: Icons.trending_up_rounded,
        title: 'No cross-source trends evaluated yet',
        description:
            'Run a Radar Server collection cycle and tap Sync to inspect emerging and growing multi-source signals.',
        actionLabel: 'Sync Radar',
        onAction: () => ref.read(radarSyncProvider.notifier).syncNow(),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.xs,
        AppSpacing.pageHorizontal,
        88.0,
      ),
      itemCount: trends.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final t = trends[i];
        final cat = RadarTaxonomy.byCode(t.primaryCategory);
        final statusColor = switch (t.status) {
          'emerging' => AppColors.primary,
          'growing' => AppColors.success,
          'established' => const Color(0xFF0EA5E9),
          'cooling' => AppColors.textTertiary,
          _ => AppColors.warning,
        };
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.14),
                      borderRadius: AppRadii.roundedXs,
                    ),
                    child: Text(
                      t.status.replaceAll('_', ' ').toUpperCase(),
                      style: AppTypography.metadata.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '${cat.shortLabel} · ${t.sourceDiversityCount} sources · ${t.mentionCount} items',
                    style: AppTypography.metadata.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(t.label, style: AppTypography.cardTitle),
              const SizedBox(height: 4.0),
              Text(
                t.explanation,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              if (t.evidence.isNotEmpty) ...[
                const SizedBox(height: 8.0),
                ...t.evidence.take(3).map(
                      (ev) => Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          '• [${ev.sourceName}] ${ev.evidenceSummary}',
                          style: AppTypography.metadata.copyWith(
                            fontSize: 11.5,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
              ],
            ],
          ),
        );
      },
    );
  }
}
