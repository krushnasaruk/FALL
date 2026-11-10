import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../data/database/app_database.dart';
import 'radar_models.dart';
import 'radar_repository.dart';

class RadarSyncState {
  static const String cloudDefaultUrl =
      'https://raw.githubusercontent.com/krushnasaruk/FALL/radar-data';
  static const String localDefaultUrl = 'http://10.0.2.2:8787';

  final String backendUrl;
  final double exploreRatio;
  final bool allowDirectPublicFallback;
  final bool isSyncing;
  final bool backendReachable;
  final DateTime? lastSyncAt;
  final String? lastStatusMessage;
  final List<RadarTrendCandidate> trends;
  final Map<String, dynamic> backendHealth;

  const RadarSyncState({
    this.backendUrl = cloudDefaultUrl,
    this.exploreRatio = 0.30,
    this.allowDirectPublicFallback = true,
    this.isSyncing = false,
    this.backendReachable = false,
    this.lastSyncAt,
    this.lastStatusMessage,
    this.trends = const [],
    this.backendHealth = const {},
  });

  RadarSyncState copyWith({
    String? backendUrl,
    double? exploreRatio,
    bool? allowDirectPublicFallback,
    bool? isSyncing,
    bool? backendReachable,
    DateTime? Function()? lastSyncAt,
    String? Function()? lastStatusMessage,
    List<RadarTrendCandidate>? trends,
    Map<String, dynamic>? backendHealth,
  }) {
    return RadarSyncState(
      backendUrl: backendUrl ?? this.backendUrl,
      exploreRatio: exploreRatio ?? this.exploreRatio,
      allowDirectPublicFallback: allowDirectPublicFallback ?? this.allowDirectPublicFallback,
      isSyncing: isSyncing ?? this.isSyncing,
      backendReachable: backendReachable ?? this.backendReachable,
      lastSyncAt: lastSyncAt != null ? lastSyncAt() : this.lastSyncAt,
      lastStatusMessage: lastStatusMessage != null ? lastStatusMessage() : this.lastStatusMessage,
      trends: trends ?? this.trends,
      backendHealth: backendHealth ?? this.backendHealth,
    );
  }
}

/// Manages Radar sync with local/LAN ProgressOS Radar Server plus optional secret-free
/// direct public API sync (HN, GitHub public search, Hugging Face, DEV.to) when mobile is offline from PC.
class RadarSyncNotifier extends StateNotifier<RadarSyncState> {
  static const _keyBackendUrl = 'radar_backend_url';
  static const _keyExploreRatio = 'radar_explore_ratio';
  static const _keyPublicFallback = 'radar_allow_public_fallback';

  final RadarRepository _repo;
  final _uuid = const Uuid();

  RadarSyncNotifier(this._repo) : super(const RadarSyncState()) {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString(_keyBackendUrl) ?? RadarSyncState.cloudDefaultUrl;
      final ratio = prefs.getDouble(_keyExploreRatio) ?? 0.30;
      final allowDirect = prefs.getBool(_keyPublicFallback) ?? true;
      state = state.copyWith(
        backendUrl: url,
        exploreRatio: ratio.clamp(0.05, 0.75),
        allowDirectPublicFallback: allowDirect,
      );
    } catch (_) {}
  }

  Future<void> setBackendUrl(String url) async {
    final trimmed = url.trim().replaceAll(RegExp(r'/+$'), '');
    if (trimmed.isEmpty) return;
    state = state.copyWith(backendUrl: trimmed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBackendUrl, trimmed);
  }

  Future<void> setExploreRatio(double ratio) async {
    final clamped = ratio.clamp(0.05, 0.70);
    state = state.copyWith(exploreRatio: clamped);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyExploreRatio, clamped);
    await _bestEffortPost('/api/radar/preferences/topics', {'explore_ratio': clamped});
  }

  Future<void> setAllowDirectPublicFallback(bool allow) async {
    state = state.copyWith(allowDirectPublicFallback: allow);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPublicFallback, allow);
  }

  /// Syncs cached discoveries, trends, and latest Daily Briefing from backend; falls back
  /// gracefully to secret-free public endpoints if enabled and backend is unreachable.
  Future<void> syncNow({bool triggerCollectOnBackend = false}) async {
    if (state.isSyncing) return;
    state = state.copyWith(isSyncing: true, lastStatusMessage: () => 'Syncing Radar...');
    await _repo.ensureTopicPreferencesSeeded();

    try {
      final base = state.backendUrl;
      bool isStaticCloud = base.contains('raw.githubusercontent.com') ||
          base.contains('github.io') ||
          base.contains('netlify.app');
      http.Response healthResp = await http
          .get(Uri.parse(isStaticCloud ? '$base/health.json' : '$base/health'))
          .timeout(const Duration(seconds: 6));

      if (!isStaticCloud && healthResp.statusCode != 200) {
        final staticHealth = await http
            .get(Uri.parse('$base/health.json'))
            .timeout(const Duration(seconds: 5));
        if (staticHealth.statusCode == 200) {
          healthResp = staticHealth;
          isStaticCloud = true;
        }
      }

      if (healthResp.statusCode == 200) {
        final health = jsonDecode(healthResp.body) as Map<String, dynamic>;
        isStaticCloud = isStaticCloud || health['mode'] == 'always_on_static';
        state = state.copyWith(backendReachable: true, backendHealth: health);

        if (!isStaticCloud &&
            (triggerCollectOnBackend || (health['total_discoveries'] as num? ?? 0) == 0)) {
          state = state.copyWith(lastStatusMessage: () => 'Collecting live sources...');
          await http
              .post(
                Uri.parse('$base/api/radar/collect'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'enable_gemini': true}),
              )
              .timeout(const Duration(seconds: 90));
        }

        final feedResp = await http
            .get(Uri.parse(
              isStaticCloud
                  ? '$base/api/radar/feed_for_you.json'
                  : '$base/api/radar/feed?view=for_you&limit=80',
            ))
            .timeout(const Duration(seconds: 10));
        final exploreResp = await http
            .get(Uri.parse(
              isStaticCloud
                  ? '$base/api/radar/feed_explore.json'
                  : '$base/api/radar/feed?view=explore&limit=30',
            ))
            .timeout(const Duration(seconds: 10));
        final trendsResp = await http
            .get(Uri.parse(
              isStaticCloud ? '$base/api/radar/trends.json' : '$base/api/radar/trends',
            ))
            .timeout(const Duration(seconds: 8));
        final briefingResp = await http
            .get(Uri.parse(
              isStaticCloud
                  ? '$base/api/radar/briefing_daily.json'
                  : '$base/api/radar/briefings/latest?type=daily',
            ))
            .timeout(const Duration(seconds: 8));

        final companions = <RadarDiscoveriesCompanion>[];
        final seenUrls = <String>{};

        void ingestFeedBody(String body) {
          final parsed = jsonDecode(body) as Map<String, dynamic>;
          final items = (parsed['items'] as List? ?? []).whereType<Map<String, dynamic>>();
          for (final raw in items) {
            final url = (raw['canonical_url'] ?? '').toString();
            if (url.isEmpty || !seenUrls.add(url)) continue;
            companions.add(_companionFromBackendJson(raw));
          }
        }

        if (feedResp.statusCode == 200) ingestFeedBody(feedResp.body);
        if (exploreResp.statusCode == 200) ingestFeedBody(exploreResp.body);
        await _repo.upsertDiscoveries(companions);

        List<RadarTrendCandidate> parsedTrends = const [];
        if (trendsResp.statusCode == 200) {
          final tJson = jsonDecode(trendsResp.body) as Map<String, dynamic>;
          parsedTrends = (tJson['trends'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(RadarTrendCandidate.fromJson)
              .toList();
        }

        if (briefingResp.statusCode == 200) {
          final bJson = jsonDecode(briefingResp.body) as Map<String, dynamic>;
          final sections = (bJson['sections'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(RadarBriefingSection.fromJson)
              .toList();
          await _repo.saveBriefing(
            RadarBriefing(
              id: (bJson['id'] ?? _uuid.v4()).toString(),
              briefingType: (bJson['briefing_type'] ?? 'daily').toString(),
              briefingDate: (bJson['briefing_date'] ?? '').toString(),
              headline: (bJson['headline'] ?? 'Daily Tech Briefing').toString(),
              sections: sections,
              generatedBy: (bJson['generated_by'] ?? 'radar_curator').toString(),
            ),
          );
        }

        state = state.copyWith(
          isSyncing: false,
          backendReachable: true,
          lastSyncAt: () => DateTime.now(),
          trends: parsedTrends,
          lastStatusMessage: () => 'Synced ${companions.length} discoveries from Radar Server',
        );
        return;
      }
    } catch (_) {
      state = state.copyWith(backendReachable: false);
    }

    // Offline fallback: Secret-free direct public API sync (optional toggle)
    if (state.allowDirectPublicFallback) {
      final count = await _syncDirectPublicApis();
      state = state.copyWith(
        isSyncing: false,
        lastSyncAt: () => DateTime.now(),
        lastStatusMessage: () => count > 0
            ? 'Direct Public Sync fetched $count items (backend offline)'
            : 'Offline or unable to reach sources — showing cached discoveries.',
      );
    } else {
      state = state.copyWith(
        isSyncing: false,
        lastStatusMessage: () => 'Backend unreachable and direct public fallback disabled.',
      );
    }
  }

  Future<int> _syncDirectPublicApis() async {
    final collected = <RadarDiscoveriesCompanion>[];
    final seenUrls = <String>{};
    final now = DateTime.now();

    // 1. Public GitHub Search (unauthenticated read-only)
    try {
      final resp = await http
          .get(
            Uri.parse('https://api.github.com/search/repositories?q=stars:>80+pushed:>2026-01-01&sort=updated&per_page=10'),
            headers: {'Accept': 'application/vnd.github+json', 'User-Agent': 'ProgressOS-Radar'},
          )
          .timeout(const Duration(seconds: 8));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        for (final r in (data['items'] as List? ?? []).whereType<Map<String, dynamic>>()) {
          final url = (r['html_url'] ?? '').toString();
          final name = (r['full_name'] ?? '').toString();
          if (url.isEmpty || name.isEmpty || !seenUrls.add(url)) continue;
          final stars = (r['stargazers_count'] as num?)?.toDouble();
          final forks = (r['forks_count'] as num?)?.toDouble();
          final desc = (r['description'] ?? 'Public open-source repository.').toString();
          final lang = (r['language'] ?? '').toString();
          final cat = desc.toLowerCase().contains('ai') || desc.toLowerCase().contains('llm')
              ? 'A'
              : (lang.toLowerCase() == 'dart' ? 'M' : 'B');
          collected.add(
            RadarDiscoveriesCompanion(
              id: Value(_uuid.v4()),
              canonicalUrl: Value(url),
              title: Value(name),
              discoveryType: const Value('repo'),
              primaryCategory: Value(cat),
              categoriesJson: Value(jsonEncode([cat, 'B'])),
              tagsJson: Value(jsonEncode([if (lang.isNotEmpty) lang.toLowerCase(), 'github'])),
              priorityTier: const Value('P0'),
              sourceName: const Value('GitHub Public API'),
              sourceDomain: const Value('github.com'),
              authorOrOrg: Value((r['owner'] as Map?)?['login']?.toString()),
              publishedAtIso: Value(r['pushed_at']?.toString()),
              discoveredAt: Value(now),
              rawSummary: Value(desc),
              plainEnglishSummary: Value(desc),
              whyItMatters: const Value('Active public repository synced directly from GitHub.'),
              analysisSource: const Value('source_reported'),
              primaryMetricLabel: Value(stars != null ? 'Stars' : null),
              primaryMetricValue: Value(stars),
              secondaryMetricLabel: Value(forks != null ? 'Forks' : null),
              secondaryMetricValue: Value(forks),
              sourcesJson: Value(jsonEncode([
                {'connector': 'github_public', 'source_name': 'GitHub Public API', 'source_url': url}
              ])),
              rankScore: Value(720.0 + ((stars ?? 0) > 0 ? 40.0 : 0.0)),
              isExploratory: Value(cat == 'P' || cat == 'Q' || cat == 'O'),
            ),
          );
        }
      }
    } catch (_) {}

    // 2. Public Hacker News Top Stories (Firebase API)
    try {
      final idsResp = await http
          .get(Uri.parse('https://hacker-news.firebaseio.com/v0/topstories.json'))
          .timeout(const Duration(seconds: 6));
      if (idsResp.statusCode == 200) {
        final ids = (jsonDecode(idsResp.body) as List).take(8);
        for (final id in ids) {
          try {
            final itemResp = await http
                .get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json'))
                .timeout(const Duration(seconds: 4));
            if (itemResp.statusCode != 200) continue;
            final item = jsonDecode(itemResp.body) as Map<String, dynamic>;
            final title = (item['title'] ?? '').toString().trim();
            final hnUrl = 'https://news.ycombinator.com/item?id=$id';
            final url = (item['url'] ?? hnUrl).toString().trim();
            if (title.isEmpty || !seenUrls.add(url)) continue;
            final score = (item['score'] as num?)?.toDouble();
            final comments = (item['descendants'] as num?)?.toDouble();
            final lower = title.toLowerCase();
            final cat = (lower.contains('ai') || lower.contains('llm'))
                ? 'A'
                : (lower.startsWith('show hn') ? 'D' : 'F');
            collected.add(
              RadarDiscoveriesCompanion(
                id: Value(_uuid.v4()),
                canonicalUrl: Value(url),
                title: Value(title),
                discoveryType: Value(lower.startsWith('show hn') ? 'product' : 'community'),
                primaryCategory: Value(cat),
                categoriesJson: Value(jsonEncode([cat, 'F'])),
                tagsJson: Value(jsonEncode(['hacker-news', if (lower.startsWith('show hn')) 'show-hn'])),
                priorityTier: const Value('P0'),
                sourceName: const Value('Hacker News'),
                sourceDomain: Value(Uri.tryParse(url)?.host ?? 'news.ycombinator.com'),
                authorOrOrg: Value(item['by']?.toString()),
                discoveredAt: Value(now),
                rawSummary: Value('Active thread on Hacker News ($title).'),
                plainEnglishSummary: const Value('Discussed by developers on Hacker News.'),
                analysisSource: const Value('source_reported'),
                primaryMetricLabel: Value(score != null ? 'HN Points' : null),
                primaryMetricValue: Value(score),
                secondaryMetricLabel: Value(comments != null ? 'Comments' : null),
                secondaryMetricValue: Value(comments),
                sourcesJson: Value(jsonEncode([
                  {'connector': 'hackernews_public', 'source_name': 'Hacker News', 'source_url': hnUrl}
                ])),
                rankScore: Value(700.0 + (score ?? 0) * 0.1),
              ),
            );
          } catch (_) {}
        }
      }
    } catch (_) {}

    // 3. Hugging Face Public Trending Models
    try {
      final resp = await http
          .get(Uri.parse('https://huggingface.co/api/models?sort=trendingScore&direction=-1&limit=8'))
          .timeout(const Duration(seconds: 7));
      if (resp.statusCode == 200) {
        final models = (jsonDecode(resp.body) as List).whereType<Map<String, dynamic>>();
        for (final m in models) {
          final id = (m['id'] ?? '').toString();
          if (id.isEmpty) continue;
          final url = 'https://huggingface.co/$id';
          if (!seenUrls.add(url)) continue;
          final likes = (m['likes'] as num?)?.toDouble();
          final downloads = (m['downloads'] as num?)?.toDouble();
          final pipeline = m['pipeline_tag']?.toString();
          collected.add(
            RadarDiscoveriesCompanion(
              id: Value(_uuid.v4()),
              canonicalUrl: Value(url),
              title: Value(id),
              discoveryType: const Value('model'),
              primaryCategory: const Value('A'),
              categoriesJson: Value(jsonEncode(['A', 'B'])),
              tagsJson: Value(jsonEncode(['huggingface', if (pipeline != null) pipeline])),
              priorityTier: const Value('P0'),
              sourceName: const Value('Hugging Face Hub'),
              sourceDomain: const Value('huggingface.co'),
              authorOrOrg: Value(id.contains('/') ? id.split('/').first : null),
              discoveredAt: Value(now),
              rawSummary: Value(pipeline != null ? 'Open model ($pipeline).' : 'Trending Hugging Face model.'),
              plainEnglishSummary: Value(pipeline != null ? 'Trending $pipeline model on Hugging Face Hub.' : 'Trending model on Hugging Face Hub.'),
              analysisSource: const Value('source_reported'),
              primaryMetricLabel: Value(likes != null ? 'Likes' : null),
              primaryMetricValue: Value(likes),
              secondaryMetricLabel: Value(downloads != null ? 'Downloads' : null),
              secondaryMetricValue: Value(downloads),
              sourcesJson: Value(jsonEncode([
                {'connector': 'huggingface_public', 'source_name': 'Hugging Face Hub', 'source_url': url}
              ])),
              rankScore: const Value(740.0),
            ),
          );
        }
      }
    } catch (_) {}

    await _repo.upsertDiscoveries(collected);
    return collected.length;
  }

  RadarDiscoveriesCompanion _companionFromBackendJson(Map<String, dynamic> raw) {
    final now = DateTime.now();
    return RadarDiscoveriesCompanion(
      id: Value((raw['id'] ?? _uuid.v4()).toString()),
      canonicalUrl: Value((raw['canonical_url'] ?? '').toString()),
      title: Value((raw['title'] ?? '').toString()),
      discoveryType: Value((raw['discovery_type'] ?? 'article').toString()),
      primaryCategory: Value((raw['primary_category'] ?? 'B').toString()),
      categoriesJson: Value(jsonEncode(raw['categories'] ?? [raw['primary_category'] ?? 'B'])),
      tagsJson: Value(jsonEncode(raw['tags'] ?? const [])),
      priorityTier: Value((raw['priority_tier'] ?? 'P1').toString()),
      sourceName: Value((raw['source_name'] ?? 'Radar').toString()),
      sourceDomain: Value((raw['source_domain'] ?? '').toString()),
      authorOrOrg: Value(raw['author_or_org']?.toString()),
      publishedAtIso: Value(raw['published_at']?.toString()),
      discoveredAt: Value(DateTime.tryParse((raw['discovered_at'] ?? '').toString()) ?? now),
      rawSummary: Value((raw['raw_summary'] ?? '').toString()),
      plainEnglishSummary: Value(raw['plain_english_summary']?.toString()),
      whyItMatters: Value(raw['why_it_matters']?.toString()),
      whoItIsFor: Value(raw['who_it_is_for']?.toString()),
      howItCompares: Value(raw['how_it_compares']?.toString()),
      practicalTakeaway: Value(raw['practical_takeaway']?.toString()),
      tryItSuggestion: Value(raw['try_it_suggestion']?.toString()),
      beginnerNote: Value(raw['beginner_note']?.toString()),
      analysisSource: Value((raw['analysis_source'] ?? 'deterministic').toString()),
      primaryMetricLabel: Value(raw['primary_metric_label']?.toString()),
      primaryMetricValue: Value((raw['primary_metric_value'] as num?)?.toDouble()),
      secondaryMetricLabel: Value(raw['secondary_metric_label']?.toString()),
      secondaryMetricValue: Value((raw['secondary_metric_value'] as num?)?.toDouble()),
      metricDeltaLabel: Value(raw['metric_delta_label']?.toString()),
      metricDeltaValue: Value((raw['metric_delta_value'] as num?)?.toDouble()),
      sourcesJson: Value(jsonEncode(raw['sources'] ?? const [])),
      rankScore: Value((raw['final_rank_score'] as num?)?.toDouble() ?? 0.0),
      isExploratory: Value(raw['is_exploratory'] == true),
      isBookmarked: Value(raw['is_bookmarked'] == true),
      bookmarkCollection: Value(raw['bookmark_collection']?.toString()),
      bookmarkNote: Value(raw['bookmark_note']?.toString()),
    );
  }

  Future<void> pushFeedback(RadarDiscoveryItem item, String action) async {
    await _repo.recordFeedback(
      discoveryId: item.id,
      action: action,
      categoryCode: item.primaryCategory,
    );
    await _bestEffortPost('/api/radar/discoveries/${item.id}/feedback', {'action': action});
  }

  Future<void> pushBookmark(
    RadarDiscoveryItem item, {
    required bool saved,
    String collection = 'Saved',
    String? note,
  }) async {
    await _repo.toggleBookmark(
      item.id,
      bookmarked: saved,
      collectionName: collection,
      note: note,
    );
    await _bestEffortPost('/api/radar/discoveries/${item.id}/bookmark', {
      'saved': saved,
      'collection_name': collection,
      if (note != null) 'user_note': note,
    });
  }

  Future<void> pushTopicPref({
    required String categoryCode,
    String? priorityLevel,
    bool? isMuted,
    List<String>? boostKeywords,
    List<String>? mutedKeywords,
  }) async {
    await _repo.updateTopicPref(
      categoryCode: categoryCode,
      priorityLevel: priorityLevel,
      isMuted: isMuted,
      boostKeywords: boostKeywords,
      mutedKeywords: mutedKeywords,
    );
    await _bestEffortPost('/api/radar/preferences/topics', {
      'category_code': categoryCode,
      if (priorityLevel != null) 'priority_level': priorityLevel,
      if (isMuted != null) 'is_muted': isMuted,
      if (boostKeywords != null) 'boost_keywords': boostKeywords,
      if (mutedKeywords != null) 'muted_keywords': mutedKeywords,
    });
  }

  Future<void> _bestEffortPost(String path, Map<String, dynamic> body) async {
    try {
      await http
          .post(
            Uri.parse('${state.backendUrl}$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // Offline-first: local Drift mutation stays intact even if backend is away
    }
  }
}

final radarSyncProvider = StateNotifierProvider<RadarSyncNotifier, RadarSyncState>((ref) {
  final repo = ref.watch(radarRepositoryProvider);
  return RadarSyncNotifier(repo);
});

/// Stream provider for Radar feed slices matching active tab, category filter & search query.
final radarFeedStreamProvider = StreamProvider.family<List<RadarDiscoveryItem>,
    ({RadarFeedView view, String? categoryCode, String searchQuery})>((ref, args) {
  final repo = ref.watch(radarRepositoryProvider);
  final exploreRatio = ref.watch(radarSyncProvider.select((s) => s.exploreRatio));
  return repo.watchFeed(
    args.view,
    categoryCode: args.categoryCode,
    searchQuery: args.searchQuery,
    exploreRatio: exploreRatio,
  );
});

final radarTopicPrefsStreamProvider = StreamProvider<List<RadarTopicPrefEntry>>((ref) {
  return ref.watch(radarRepositoryProvider).watchTopicPrefs();
});

final radarFollowsStreamProvider = StreamProvider<List<RadarFollowEntry>>((ref) {
  return ref.watch(radarRepositoryProvider).watchFollows();
});

final radarDailyBriefingStreamProvider = StreamProvider<RadarBriefing?>((ref) {
  return ref.watch(radarRepositoryProvider).watchLatestBriefing('daily');
});
