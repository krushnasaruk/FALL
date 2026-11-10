import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../radar_repository.dart';
import '../radar_sync_service.dart';
import '../radar_taxonomy.dart';

/// User controls for all 18 Technology Categories (P0-P3), Mute/Keywords, Exploration Ratio,
/// Local Radar Server URL, and Collection Health diagnostics.
class RadarPreferencesScreen extends ConsumerStatefulWidget {
  const RadarPreferencesScreen({super.key});

  @override
  ConsumerState<RadarPreferencesScreen> createState() => _RadarPreferencesScreenState();
}

class _RadarPreferencesScreenState extends ConsumerState<RadarPreferencesScreen> {
  late TextEditingController _urlCtrl;

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(text: ref.read(radarSyncProvider).backendUrl);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _editKeywordsDialog(
    String categoryCode,
    String categoryName,
    String boostJson,
    String muteJson,
  ) async {
    List<String> parseList(String raw) {
      try {
        return (jsonDecode(raw) as List).map((e) => e.toString()).toList();
      } catch (_) {
        return const [];
      }
    }

    final boostCtrl = TextEditingController(text: parseList(boostJson).join(', '));
    final muteCtrl = TextEditingController(text: parseList(muteJson).join(', '));

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(categoryName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: boostCtrl,
              decoration: const InputDecoration(
                labelText: 'Boost keywords (comma-separated)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: muteCtrl,
              decoration: const InputDecoration(
                labelText: 'Excluded keywords (comma-separated)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Apply')),
        ],
      ),
    );
    if (save != true) return;

    List<String> splitCsv(String raw) => raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    await ref.read(radarSyncProvider.notifier).pushTopicPref(
          categoryCode: categoryCode,
          boostKeywords: splitCsv(boostCtrl.text),
          mutedKeywords: splitCsv(muteCtrl.text),
        );
    if (mounted) AppToast.show(context, 'Updated keywords for $categoryName');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final syncState = ref.watch(radarSyncProvider);
    final prefsAsync = ref.watch(radarTopicPrefsStreamProvider);
    final followsAsync = ref.watch(radarFollowsStreamProvider);
    final explorePct = (syncState.exploreRatio * 100).round();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        elevation: 0,
        title: const Text('Radar Settings & Topics', style: AppTypography.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.sm,
          AppSpacing.pageHorizontal,
          48.0,
        ),
        children: [
          // Backend Connection & Direct Sync Fallback
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RADAR ENGINE CONNECTION', style: AppTypography.metadata),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _urlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Radar Backend Server URL',
                    hintText: RadarSyncState.cloudDefaultUrl,
                  ),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: [
                    ActionChip(
                      label: const Text('Always-On Cloud'),
                      avatar: const Icon(Icons.cloud_done_outlined, size: 15),
                      onPressed: () {
                        _urlCtrl.text = RadarSyncState.cloudDefaultUrl;
                        ref
                            .read(radarSyncProvider.notifier)
                            .setBackendUrl(RadarSyncState.cloudDefaultUrl);
                      },
                    ),
                    ActionChip(
                      label: const Text('Local Host (10.0.2.2)'),
                      avatar: const Icon(Icons.computer_rounded, size: 15),
                      onPressed: () {
                        _urlCtrl.text = RadarSyncState.localDefaultUrl;
                        ref
                            .read(radarSyncProvider.notifier)
                            .setBackendUrl(RadarSyncState.localDefaultUrl);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Save & Sync',
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await ref.read(radarSyncProvider.notifier).setBackendUrl(_urlCtrl.text);
                          await ref.read(radarSyncProvider.notifier).syncNow();
                          if (!mounted) return;
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                ref.read(radarSyncProvider).lastStatusMessage ?? 'Sync complete',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Collect Live',
                        onPressed: () async {
                          await ref.read(radarSyncProvider.notifier).setBackendUrl(_urlCtrl.text);
                          await ref
                              .read(radarSyncProvider.notifier)
                              .syncNow(triggerCollectOnBackend: true);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Direct Public Sync Fallback', style: AppTypography.bodySmall),
                  subtitle: const Text(
                    'Uses key-free public GitHub/HN/HF APIs directly if local Radar server is unreachable.',
                    style: AppTypography.metadata,
                  ),
                  value: syncState.allowDirectPublicFallback,
                  onChanged: (v) =>
                      ref.read(radarSyncProvider.notifier).setAllowDirectPublicFallback(v),
                ),
                if (syncState.backendHealth.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      'Server status: ${syncState.backendHealth["total_discoveries"] ?? 0} discoveries · '
                      'Gemini today: ${syncState.backendHealth["gemini_requests_today"] ?? 0}/'
                      '${syncState.backendHealth["gemini_daily_budget"] ?? 120}',
                      style: AppTypography.metadata.copyWith(color: AppColors.success),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Exploration Ratio Control (70% Aligned / 30% Exploratory default)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DISCOVERY BALANCE', style: AppTypography.metadata),
                const SizedBox(height: 6.0),
                Text(
                  '${100 - explorePct}% Interest-Aligned · $explorePct% Exploratory',
                  style: AppTypography.cardTitle,
                ),
                Slider(
                  value: syncState.exploreRatio,
                  min: 0.05,
                  max: 0.70,
                  divisions: 13,
                  label: '$explorePct% Explore',
                  onChanged: (v) => ref.read(radarSyncProvider.notifier).setExploreRatio(v),
                ),
                Text(
                  'Higher exploratory ratio surfaces unfamiliar technologies, cross-domain research & P2/P3 wildcards.',
                  style: AppTypography.metadata.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Followed Entities
          followsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (follows) {
              if (follows.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('FOLLOWED CREATORS & TOPICS', style: AppTypography.metadata),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: follows
                            .map(
                              (f) => InputChip(
                                label: Text(f.displayName),
                                onDeleted: () => ref.read(radarRepositoryProvider).toggleFollow(
                                      followType: f.followType,
                                      targetKey: f.targetKey,
                                      displayName: f.displayName,
                                    ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // All 18 Categories A-R Priority & Mute Controls
          Text(
            '18 TECHNOLOGY CATEGORIES (A–R)',
            style: AppTypography.metadata.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          prefsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
            data: (prefs) {
              return Column(
                children: prefs.map((pref) {
                  final cat = RadarTaxonomy.byCode(pref.categoryCode);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: cat.accentColor.withOpacity(0.14),
                                  borderRadius: AppRadii.roundedSm,
                                ),
                                child: Icon(cat.icon, size: 17, color: cat.accentColor),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cat.code}. ${cat.name}',
                                      style: AppTypography.cardTitle.copyWith(fontSize: 14.5),
                                    ),
                                    Text(
                                      cat.description,
                                      style: AppTypography.metadata.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Wrap(
                            spacing: 6.0,
                            runSpacing: 4.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ...['P0', 'P1', 'P2', 'P3'].map((prio) {
                                final selected = pref.priorityLevel == prio;
                                return ChoiceChip(
                                  label: Text(prio),
                                  selected: selected,
                                  visualDensity: VisualDensity.compact,
                                  onSelected: (_) => ref
                                      .read(radarSyncProvider.notifier)
                                      .pushTopicPref(
                                        categoryCode: pref.categoryCode,
                                        priorityLevel: prio,
                                      ),
                                );
                              }),
                              TextButton(
                                onPressed: () => _editKeywordsDialog(
                                  pref.categoryCode,
                                  cat.shortLabel,
                                  pref.boostKeywordsJson,
                                  pref.mutedKeywordsJson,
                                ),
                                child: const Text('Keywords'),
                              ),
                              IconButton(
                                tooltip: pref.isMuted ? 'Unmute category' : 'Mute category',
                                onPressed: () => ref.read(radarSyncProvider.notifier).pushTopicPref(
                                      categoryCode: pref.categoryCode,
                                      isMuted: !pref.isMuted,
                                    ),
                                icon: Icon(
                                  pref.isMuted
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_outlined,
                                  size: 18,
                                  color: pref.isMuted ? AppColors.error : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
