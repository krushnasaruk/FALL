import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';
import '../radar_models.dart';
import '../radar_repository.dart';
import '../radar_sync_service.dart';
import '../radar_taxonomy.dart';

/// Full discovery intelligence view distinguishing verified metadata from AI / deterministic explanations,
/// with bookmark collections, creator/org following, and one-tap conversion into FALL Tasks or Learning Roadmaps.
class RadarDetailScreen extends ConsumerStatefulWidget {
  final RadarDiscoveryItem item;

  const RadarDetailScreen({super.key, required this.item});

  @override
  ConsumerState<RadarDetailScreen> createState() => _RadarDetailScreenState();
}

class _RadarDetailScreenState extends ConsumerState<RadarDetailScreen> {
  late bool _bookmarked;
  late String _collection;
  late String _note;
  bool _isFollowed = false;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.item.isBookmarked;
    _collection = widget.item.bookmarkCollection ?? 'Saved';
    _note = widget.item.bookmarkNote ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(radarRepositoryProvider).markRead(widget.item.id);
    });
  }

  Future<void> _openSource() async {
    final feedback = ref.read(feedbackServiceProvider);
    await feedback.buttonTap();
    await ref.read(radarRepositoryProvider).markRead(widget.item.id, explored: true);
    final opened = await feedback.openExternalUrl(widget.item.canonicalUrl);
    if (!mounted) return;
    if (!opened) {
      AppToast.show(context, 'Source URL copied to clipboard: ${widget.item.canonicalUrl}');
    }
  }

  Future<void> _editBookmarkSheet() async {
    final colCtrl = TextEditingController(text: _collection);
    final noteCtrl = TextEditingController(text: _note);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Save Discovery & Note', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: colCtrl,
                decoration: const InputDecoration(
                  labelText: 'Collection (e.g. Build Later, Research, AI Tools)',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Personal note (optional)',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Remove',
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Save',
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    if (saved == null) return;
    await ref.read(radarSyncProvider.notifier).pushBookmark(
          widget.item,
          saved: saved,
          collection: colCtrl.text.trim().isEmpty ? 'Saved' : colCtrl.text.trim(),
          note: noteCtrl.text.trim(),
        );
    setState(() {
      _bookmarked = saved;
      _collection = colCtrl.text.trim().isEmpty ? 'Saved' : colCtrl.text.trim();
      _note = noteCtrl.text.trim();
    });
    if (mounted) {
      AppToast.show(context, saved ? 'Saved to $_collection' : 'Removed from Saved');
    }
  }

  Future<void> _sendToFallTask() async {
    final repo = ref.read(taskRepositoryProvider);
    final feedback = ref.read(feedbackServiceProvider);
    await repo.createTask(
      title: 'Explore: ${widget.item.title}',
      description: '${widget.item.displaySummary}\nSource: ${widget.item.canonicalUrl}',
      priority: 'medium',
      tags: 'radar',
    );
    await feedback.taskCompleted(completed: true);
    if (!mounted) return;
    AppToast.show(context, 'Added to Tasks as "Explore: ${widget.item.title}"');
  }

  Future<void> _addToFallLearning() async {
    final repo = ref.read(learningRepositoryProvider);
    final feedback = ref.read(feedbackServiceProvider);
    final cat = RadarTaxonomy.byCode(widget.item.primaryCategory);
    await repo.createSkill(
      name: widget.item.title.length > 48
          ? widget.item.title.substring(0, 48)
          : widget.item.title,
      category: cat.shortLabel,
      currentLevel: 'intermediate',
      targetLevel: 'advanced',
      notes: '${widget.item.displaySummary}\nSource: ${widget.item.canonicalUrl}',
    );
    await feedback.goalAchieved();
    if (!mounted) return;
    AppToast.show(context, 'Created Learning Roadmap item in FALL');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final item = widget.item;
    final cat = RadarTaxonomy.byCode(item.primaryCategory);
    final compact = NumberFormat.compact();
    final follows = ref.watch(radarFollowsStreamProvider).valueOrNull ?? const [];
    final followKey = (item.authorOrOrg ?? item.primaryCategory).toLowerCase();
    final isFollowing =
        _isFollowed || follows.any((f) => f.targetKey.toLowerCase() == followKey);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        elevation: 0,
        title: Text(cat.shortLabel, style: AppTypography.titleMedium),
        actions: [
          IconButton(
            onPressed: _editBookmarkSheet,
            tooltip: 'Save & annotate',
            icon: Icon(
              _bookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _bookmarked
                  ? (isDark ? AppColors.primaryDark : AppColors.primary)
                  : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.sm,
          AppSpacing.pageHorizontal,
          48.0,
        ),
        children: [
          // Header Card: Title, Provenance, Primary Link & Action Buttons
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: [
                    _PillBadge(
                      label: '${cat.name} · ${item.priorityTier}',
                      color: cat.accentColor,
                    ),
                    _PillBadge(
                      label: item.provenanceLabel,
                      color: item.analysisSource == 'gemini'
                          ? (isDark ? AppColors.primaryDark : AppColors.primary)
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Text(
                  item.title,
                  style: AppTypography.display.copyWith(
                    fontSize: 20.0,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${item.sourceName}${item.authorOrOrg != null ? " · ${item.authorOrOrg}" : ""}${item.sourceDomain.isNotEmpty ? " · ${item.sourceDomain}" : ""}',
                  style: AppTypography.metadata.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14.0),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Open Source',
                        icon: Icons.open_in_new_rounded,
                        onPressed: _openSource,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SecondaryButton(
                      label: isFollowing ? 'Following' : 'Follow',
                      icon: isFollowing ? Icons.check_rounded : Icons.add_rounded,
                      onPressed: () async {
                        final target = item.authorOrOrg ?? item.primaryCategory;
                        final active = await ref.read(radarRepositoryProvider).toggleFollow(
                              followType: item.authorOrOrg != null ? 'creator' : 'topic',
                              targetKey: target.toLowerCase(),
                              displayName: target,
                            );
                        setState(() => _isFollowed = active);
                        if (!context.mounted) return;
                        AppToast.show(
                          context,
                          active ? 'Following $target' : 'Unfollowed $target',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Verified Metrics Card (ONLY rendered if authentic factual metrics exist)
          if (item.primaryMetricValue != null ||
              item.secondaryMetricValue != null ||
              item.metricDeltaValue != null) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VERIFIED METRICS (SOURCE-REPORTED)',
                    style: AppTypography.metadata.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: [
                      if (item.primaryMetricLabel != null && item.primaryMetricValue != null)
                        _MetricTile(
                          label: item.primaryMetricLabel!,
                          value: compact.format(item.primaryMetricValue!),
                          isDark: isDark,
                        ),
                      if (item.secondaryMetricLabel != null && item.secondaryMetricValue != null)
                        _MetricTile(
                          label: item.secondaryMetricLabel!,
                          value: compact.format(item.secondaryMetricValue!),
                          isDark: isDark,
                        ),
                      if (item.metricDeltaLabel != null && item.metricDeltaValue != null)
                        _MetricTile(
                          label: '${item.metricDeltaLabel!} (observed)',
                          value:
                              '${item.metricDeltaValue! > 0 ? "+" : ""}${compact.format(item.metricDeltaValue!)}',
                          isDark: isDark,
                          valueColor: AppColors.success,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Intelligence Explanation Section (clearly labeled as AI vs Deterministic vs Excerpt)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.analysisSource == 'gemini'
                      ? 'INTELLIGENCE BRIEF (AI-EXPLAINED)'
                      : 'GROUNDED SUMMARY (${item.analysisSource.toUpperCase()})',
                  style: AppTypography.metadata.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  item.displaySummary,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    height: 1.48,
                  ),
                ),
                if (item.whyItMatters != null && item.whyItMatters!.isNotEmpty) ...[
                  const SizedBox(height: 12.0),
                  _InfoBlock(label: 'Why It Matters', text: item.whyItMatters!, isDark: isDark),
                ],
                if (item.whoItIsFor != null && item.whoItIsFor!.isNotEmpty)
                  _InfoBlock(label: 'Who Should Care', text: item.whoItIsFor!, isDark: isDark),
                if (item.howItCompares != null && item.howItCompares!.isNotEmpty)
                  _InfoBlock(label: 'Ecosystem Comparison', text: item.howItCompares!, isDark: isDark),
                if (item.practicalTakeaway != null && item.practicalTakeaway!.isNotEmpty)
                  _InfoBlock(label: 'Practical Takeaway', text: item.practicalTakeaway!, isDark: isDark),
                if (item.tryItSuggestion != null && item.tryItSuggestion!.isNotEmpty)
                  _InfoBlock(label: 'Quick Experiment', text: item.tryItSuggestion!, isDark: isDark),
                if (item.beginnerNote != null && item.beginnerNote!.isNotEmpty)
                  _InfoBlock(label: 'Context Note', text: item.beginnerNote!, isDark: isDark),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Convert Into Personal Execution in FALL
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TURN DISCOVERY INTO PROGRESS',
                  style: AppTypography.metadata.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Add to Tasks',
                        icon: AppIcons.tasksActive,
                        onPressed: _sendToFallTask,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Study Skill',
                        icon: AppIcons.learningActive,
                        onPressed: _addToFallLearning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await ref.read(radarSyncProvider.notifier).pushFeedback(item, 'relevant');
                          if (!context.mounted) return;
                          AppToast.show(context, 'Marked relevant — tuning your Radar');
                        },
                        icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
                        label: const Text('Relevant'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await ref
                              .read(radarSyncProvider.notifier)
                              .pushFeedback(item, 'not_relevant');
                          if (!context.mounted) return;
                          AppToast.show(context, 'Less like this noted');
                        },
                        icon: const Icon(Icons.thumb_down_alt_outlined, size: 16),
                        label: const Text('Not Relevant'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (item.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: item.tags
                  .map(
                    (t) => Chip(
                      label: Text('#$t', style: AppTypography.metadata),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PillBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: AppRadii.roundedXs,
      ),
      child: Text(
        label,
        style: AppTypography.metadata.copyWith(
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.statMedium.copyWith(
            color: valueColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
        Text(
          label,
          style: AppTypography.metadata.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String text;
  final bool isDark;

  const _InfoBlock({required this.label, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.metadata.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3.0),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              height: 1.42,
            ),
          ),
        ],
      ),
    );
  }
}
