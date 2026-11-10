import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/database/app_database.dart';
import '../../data/database/database_provider.dart';
import 'radar_models.dart';
import 'radar_taxonomy.dart';

/// Offline-first Drift repository for ProgressOS Radar discoveries, topic preferences,
/// bookmarks, follows, feedback adaptation, and cached Daily Briefings.
class RadarRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  RadarRepository(this._db);

  Future<void> ensureTopicPreferencesSeeded() async {
    final existing = await _db.select(_db.radarTopicPrefs).get();
    if (existing.length >= RadarTaxonomy.categories.length) return;
    final existingCodes = existing.map((e) => e.categoryCode).toSet();
    final now = DateTime.now();

    await _db.batch((batch) {
      for (final cat in RadarTaxonomy.categories) {
        if (existingCodes.contains(cat.code)) continue;
        batch.insert(
          _db.radarTopicPrefs,
          RadarTopicPrefsCompanion(
            categoryCode: Value(cat.code),
            categoryName: Value(cat.name),
            priorityLevel: Value(cat.defaultPriority),
            isMuted: const Value(false),
            boostKeywordsJson: Value(jsonEncode(cat.defaultKeywords)),
            mutedKeywordsJson: const Value('[]'),
            affinityAdjustment: const Value(0.0),
            updatedAt: Value(now),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Stream<List<RadarTopicPrefEntry>> watchTopicPrefs() {
    ensureTopicPreferencesSeeded();
    return (_db.select(_db.radarTopicPrefs)
          ..orderBy([(t) => OrderingTerm(expression: t.categoryCode)]))
        .watch();
  }

  Future<List<RadarTopicPrefEntry>> getTopicPrefs() async {
    await ensureTopicPreferencesSeeded();
    return (_db.select(_db.radarTopicPrefs)
          ..orderBy([(t) => OrderingTerm(expression: t.categoryCode)]))
        .get();
  }

  Future<void> updateTopicPref({
    required String categoryCode,
    String? priorityLevel,
    bool? isMuted,
    List<String>? boostKeywords,
    List<String>? mutedKeywords,
  }) async {
    await ensureTopicPreferencesSeeded();
    await (_db.update(_db.radarTopicPrefs)..where((t) => t.categoryCode.equals(categoryCode))).write(
      RadarTopicPrefsCompanion(
        priorityLevel: priorityLevel != null ? Value(priorityLevel) : const Value.absent(),
        isMuted: isMuted != null ? Value(isMuted) : const Value.absent(),
        boostKeywordsJson:
            boostKeywords != null ? Value(jsonEncode(boostKeywords)) : const Value.absent(),
        mutedKeywordsJson:
            mutedKeywords != null ? Value(jsonEncode(mutedKeywords)) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> upsertDiscoveries(List<RadarDiscoveriesCompanion> entries) async {
    if (entries.isEmpty) return;
    await _db.transaction(() async {
      for (final comp in entries) {
        final existing = await (_db.select(_db.radarDiscoveries)
              ..where((d) => d.canonicalUrl.equals(comp.canonicalUrl.value)))
            .getSingleOrNull();
        if (existing == null) {
          await _db.into(_db.radarDiscoveries).insert(comp);
        } else {
          await (_db.update(_db.radarDiscoveries)..where((d) => d.id.equals(existing.id))).write(
            RadarDiscoveriesCompanion(
              title: comp.title,
              discoveryType: comp.discoveryType,
              primaryCategory: comp.primaryCategory,
              categoriesJson: comp.categoriesJson,
              tagsJson: comp.tagsJson,
              priorityTier: comp.priorityTier,
              sourceName: comp.sourceName,
              authorOrOrg: comp.authorOrOrg,
              rawSummary: comp.rawSummary,
              plainEnglishSummary: comp.plainEnglishSummary,
              whyItMatters: comp.whyItMatters,
              whoItIsFor: comp.whoItIsFor,
              howItCompares: comp.howItCompares,
              practicalTakeaway: comp.practicalTakeaway,
              tryItSuggestion: comp.tryItSuggestion,
              beginnerNote: comp.beginnerNote,
              analysisSource: comp.analysisSource,
              primaryMetricLabel: comp.primaryMetricLabel,
              primaryMetricValue: comp.primaryMetricValue,
              secondaryMetricLabel: comp.secondaryMetricLabel,
              secondaryMetricValue: comp.secondaryMetricValue,
              metricDeltaLabel: comp.metricDeltaLabel,
              metricDeltaValue: comp.metricDeltaValue,
              sourcesJson: comp.sourcesJson,
              rankScore: comp.rankScore,
              isExploratory: comp.isExploratory,
            ),
          );
        }
      }
    });
  }

  Stream<List<RadarDiscoveryItem>> watchFeed(
    RadarFeedView view, {
    String? categoryCode,
    String searchQuery = '',
    double exploreRatio = 0.30,
  }) {
    final baseQuery = _db.select(_db.radarDiscoveries)
      ..orderBy([
        (t) => OrderingTerm(expression: t.rankScore, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.discoveredAt, mode: OrderingMode.desc),
      ]);

    return baseQuery.watch().asyncMap((rows) async {
      final prefs = await getTopicPrefs();
      final mutedCodes = prefs.where((p) => p.isMuted).map((p) => p.categoryCode).toSet();
      final prefMap = {for (final p in prefs) p.categoryCode: p};
      final q = searchQuery.trim().toLowerCase();

      final items = rows
          .where((r) => !r.isHidden)
          .map(RadarDiscoveryItem.fromDb)
          .where((item) {
        if (view != RadarFeedView.saved && mutedCodes.contains(item.primaryCategory)) {
          return false;
        }
        final pref = prefMap[item.primaryCategory];
        if (pref != null) {
          final mutedKws = _decodeList(pref.mutedKeywordsJson);
          final haystack = '${item.title} ${item.rawSummary} ${item.tags.join(" ")}'.toLowerCase();
          if (mutedKws.any((k) => k.isNotEmpty && haystack.contains(k.toLowerCase()))) {
            return false;
          }
        }
        if (categoryCode != null && categoryCode.isNotEmpty) {
          if (item.primaryCategory != categoryCode && !item.categories.contains(categoryCode)) {
            return false;
          }
        }
        if (q.isNotEmpty) {
          final hay =
              '${item.title} ${item.displaySummary} ${item.authorOrOrg ?? ""} ${item.sourceName} ${item.tags.join(" ")}'
                  .toLowerCase();
          if (!hay.contains(q)) return false;
        }

        switch (view) {
          case RadarFeedView.forYou:
            return true;
          case RadarFeedView.explore:
            return item.isExploratory ||
                item.priorityTier == 'P2' ||
                item.priorityTier == 'P3';
          case RadarFeedView.github:
            return item.discoveryType == 'repo' || item.primaryCategory == 'B';
          case RadarFeedView.creators:
            return item.discoveryType == 'video' || item.primaryCategory == 'E';
          case RadarFeedView.aiModels:
            return item.primaryCategory == 'A' || item.discoveryType == 'model';
          case RadarFeedView.research:
            return item.discoveryType == 'research' || item.primaryCategory == 'H';
          case RadarFeedView.opportunities:
            return const {'D', 'O', 'P', 'R'}.contains(item.primaryCategory);
          case RadarFeedView.saved:
            return item.isBookmarked;
          case RadarFeedView.trending:
            return true;
        }
      }).toList();

      if (view == RadarFeedView.forYou && items.length > 4) {
        return _interleaveForYouMix(items, prefMap, exploreRatio);
      }
      return items;
    });
  }

  List<RadarDiscoveryItem> _interleaveForYouMix(
    List<RadarDiscoveryItem> items,
    Map<String, RadarTopicPrefEntry> prefs,
    double exploreRatio,
  ) {
    final aligned = <RadarDiscoveryItem>[];
    final exploratory = <RadarDiscoveryItem>[];
    for (final it in items) {
      final prio = prefs[it.primaryCategory]?.priorityLevel ?? it.priorityTier;
      if (it.isExploratory || prio == 'P2' || prio == 'P3') {
        exploratory.add(it);
      } else {
        aligned.add(it);
      }
    }
    if (exploratory.isEmpty || aligned.isEmpty) return items;
    final alignedPerExplore =
        exploreRatio <= 0.05 ? 99 : ((1.0 - exploreRatio) / exploreRatio).round().clamp(1, 8);
    final mixed = <RadarDiscoveryItem>[];
    var aIdx = 0;
    var eIdx = 0;
    while (aIdx < aligned.length || eIdx < exploratory.length) {
      for (var k = 0; k < alignedPerExplore && aIdx < aligned.length; k++) {
        mixed.add(aligned[aIdx++]);
      }
      if (eIdx < exploratory.length) {
        mixed.add(exploratory[eIdx++]);
      }
    }
    return mixed;
  }

  Future<void> toggleBookmark(
    String discoveryId, {
    required bool bookmarked,
    String collectionName = 'Saved',
    String? note,
  }) async {
    await (_db.update(_db.radarDiscoveries)..where((d) => d.id.equals(discoveryId))).write(
      RadarDiscoveriesCompanion(
        isBookmarked: Value(bookmarked),
        bookmarkCollection: Value(bookmarked ? collectionName : null),
        bookmarkNote: note != null ? Value(note) : const Value.absent(),
      ),
    );
  }

  Future<void> markRead(String discoveryId, {bool explored = false}) async {
    await (_db.update(_db.radarDiscoveries)..where((d) => d.id.equals(discoveryId))).write(
      RadarDiscoveriesCompanion(
        isRead: const Value(true),
        isExplored: explored ? const Value(true) : const Value.absent(),
      ),
    );
  }

  Future<void> recordFeedback({
    required String discoveryId,
    required String action, // relevant, not_relevant, more_like_this, hide, explored
    required String categoryCode,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.radarFeedbackLogs).insert(
            RadarFeedbackLogsCompanion(
              id: Value(_uuid.v4()),
              discoveryId: Value(discoveryId),
              action: Value(action),
              categoryCode: Value(categoryCode),
              createdAt: Value(DateTime.now()),
            ),
          );

      if (action == 'hide') {
        await (_db.update(_db.radarDiscoveries)..where((d) => d.id.equals(discoveryId)))
            .write(const RadarDiscoveriesCompanion(isHidden: Value(true)));
      } else if (action == 'explored') {
        await (_db.update(_db.radarDiscoveries)..where((d) => d.id.equals(discoveryId))).write(
          const RadarDiscoveriesCompanion(isRead: Value(true), isExplored: Value(true)),
        );
      }

      // Gradual, reversible affinity shift
      final delta = (action == 'relevant' || action == 'more_like_this' || action == 'explored')
          ? 0.05
          : (action == 'not_relevant' || action == 'hide')
              ? -0.06
              : 0.0;
      if (delta != 0.0) {
        final pref = await (_db.select(_db.radarTopicPrefs)
              ..where((t) => t.categoryCode.equals(categoryCode)))
            .getSingleOrNull();
        if (pref != null) {
          final clamped = (pref.affinityAdjustment + delta).clamp(-0.35, 0.45);
          await (_db.update(_db.radarTopicPrefs)..where((t) => t.categoryCode.equals(categoryCode)))
              .write(
            RadarTopicPrefsCompanion(
              affinityAdjustment: Value(clamped),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }
    });
  }

  Stream<List<RadarFollowEntry>> watchFollows() {
    return (_db.select(_db.radarFollows)
          ..orderBy([(f) => OrderingTerm(expression: f.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<bool> toggleFollow({
    required String followType,
    required String targetKey,
    required String displayName,
  }) async {
    final existing = await (_db.select(_db.radarFollows)
          ..where((f) => f.followType.equals(followType) & f.targetKey.equals(targetKey)))
        .getSingleOrNull();
    if (existing != null) {
      await (_db.delete(_db.radarFollows)..where((f) => f.id.equals(existing.id))).go();
      return false;
    }
    await _db.into(_db.radarFollows).insert(
          RadarFollowsCompanion(
            id: Value(_uuid.v4()),
            followType: Value(followType),
            targetKey: Value(targetKey),
            displayName: Value(displayName),
            createdAt: Value(DateTime.now()),
          ),
        );
    return true;
  }

  Future<void> saveBriefing(RadarBriefing briefing) async {
    final sectionsRaw = jsonEncode(
      briefing.sections
          .map((s) => {
                'key': s.key,
                'title': s.title,
                'items': s.items,
                'empty_note': s.emptyNote,
              })
          .toList(),
    );
    await _db.into(_db.radarBriefings).insertOnConflictUpdate(
          RadarBriefingsCompanion(
            id: Value(briefing.id),
            briefingType: Value(briefing.briefingType),
            briefingDate: Value(briefing.briefingDate),
            headline: Value(briefing.headline),
            sectionsJson: Value(sectionsRaw),
            generatedBy: Value(briefing.generatedBy),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  Stream<RadarBriefing?> watchLatestBriefing(String briefingType) {
    return (_db.select(_db.radarBriefings)
          ..where((b) => b.briefingType.equals(briefingType))
          ..orderBy([(b) => OrderingTerm(expression: b.briefingDate, mode: OrderingMode.desc)])
          ..limit(1))
        .watchSingleOrNull()
        .map((row) {
      if (row == null) return null;
      final decoded = (jsonDecode(row.sectionsJson) as List)
          .whereType<Map<String, dynamic>>()
          .map(RadarBriefingSection.fromJson)
          .toList();
      return RadarBriefing(
        id: row.id,
        briefingType: row.briefingType,
        briefingDate: row.briefingDate,
        headline: row.headline,
        sections: decoded,
        generatedBy: row.generatedBy,
      );
    });
  }

  List<String> _decodeList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((x) => x.toString()).toList();
    } catch (_) {}
    return const [];
  }
}

final radarRepositoryProvider = Provider<RadarRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return RadarRepository(db);
});

