import 'dart:convert';
import '../../data/database/app_database.dart';

enum RadarFeedView {
  forYou('For You'),
  explore('Explore'),
  github('GitHub Radar'),
  creators('Creators'),
  aiModels('AI & Models'),
  trending('Trending'),
  research('Research'),
  opportunities('Build & Opps'),
  saved('Saved');

  final String label;
  const RadarFeedView(this.label);
}

class RadarSourceLink {
  final String connector;
  final String sourceName;
  final String sourceUrl;
  final double? reportedScore;
  final double? reportedComments;

  const RadarSourceLink({
    required this.connector,
    required this.sourceName,
    required this.sourceUrl,
    this.reportedScore,
    this.reportedComments,
  });

  factory RadarSourceLink.fromJson(Map<String, dynamic> json) {
    return RadarSourceLink(
      connector: (json['connector'] ?? '').toString(),
      sourceName: (json['source_name'] ?? 'Public Source').toString(),
      sourceUrl: (json['source_url'] ?? '').toString(),
      reportedScore: (json['reported_score'] as num?)?.toDouble(),
      reportedComments: (json['reported_comments'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'connector': connector,
        'source_name': sourceName,
        'source_url': sourceUrl,
        'reported_score': reportedScore,
        'reported_comments': reportedComments,
      };
}

class RadarDiscoveryItem {
  final String id;
  final String canonicalUrl;
  final String title;
  final String discoveryType;
  final String primaryCategory;
  final List<String> categories;
  final List<String> tags;
  final String priorityTier;
  final String sourceName;
  final String sourceDomain;
  final String? authorOrOrg;
  final String? publishedAtIso;
  final DateTime discoveredAt;
  final String rawSummary;
  final String? plainEnglishSummary;
  final String? whyItMatters;
  final String? whoItIsFor;
  final String? howItCompares;
  final String? practicalTakeaway;
  final String? tryItSuggestion;
  final String? beginnerNote;
  final String analysisSource; // gemini, deterministic, source_reported
  final String? primaryMetricLabel;
  final double? primaryMetricValue;
  final String? secondaryMetricLabel;
  final double? secondaryMetricValue;
  final String? metricDeltaLabel;
  final double? metricDeltaValue;
  final List<RadarSourceLink> sources;
  final double rankScore;
  final bool isExploratory;
  final bool isBookmarked;
  final String? bookmarkCollection;
  final String? bookmarkNote;
  final bool isRead;
  final bool isExplored;

  const RadarDiscoveryItem({
    required this.id,
    required this.canonicalUrl,
    required this.title,
    required this.discoveryType,
    required this.primaryCategory,
    required this.categories,
    required this.tags,
    required this.priorityTier,
    required this.sourceName,
    required this.sourceDomain,
    this.authorOrOrg,
    this.publishedAtIso,
    required this.discoveredAt,
    required this.rawSummary,
    this.plainEnglishSummary,
    this.whyItMatters,
    this.whoItIsFor,
    this.howItCompares,
    this.practicalTakeaway,
    this.tryItSuggestion,
    this.beginnerNote,
    required this.analysisSource,
    this.primaryMetricLabel,
    this.primaryMetricValue,
    this.secondaryMetricLabel,
    this.secondaryMetricValue,
    this.metricDeltaLabel,
    this.metricDeltaValue,
    required this.sources,
    required this.rankScore,
    required this.isExploratory,
    required this.isBookmarked,
    this.bookmarkCollection,
    this.bookmarkNote,
    required this.isRead,
    required this.isExplored,
  });

  String get displaySummary =>
      (plainEnglishSummary != null && plainEnglishSummary!.trim().isNotEmpty)
          ? plainEnglishSummary!
          : rawSummary;

  String get provenanceLabel {
    switch (analysisSource) {
      case 'gemini':
        return 'AI Explanation · Grounded in Source';
      case 'deterministic':
        return 'Deterministic Summary';
      default:
        return 'Source-Reported Excerpt';
    }
  }

  factory RadarDiscoveryItem.fromDb(RadarDiscoveryEntry e) {
    List<String> decodeStrList(String raw) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) return decoded.map((x) => x.toString()).toList();
      } catch (_) {}
      return const [];
    }

    List<RadarSourceLink> decodeSources(String raw) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .whereType<Map<String, dynamic>>()
              .map(RadarSourceLink.fromJson)
              .toList();
        }
      } catch (_) {}
      return const [];
    }

    return RadarDiscoveryItem(
      id: e.id,
      canonicalUrl: e.canonicalUrl,
      title: e.title,
      discoveryType: e.discoveryType,
      primaryCategory: e.primaryCategory,
      categories: decodeStrList(e.categoriesJson),
      tags: decodeStrList(e.tagsJson),
      priorityTier: e.priorityTier,
      sourceName: e.sourceName,
      sourceDomain: e.sourceDomain,
      authorOrOrg: e.authorOrOrg,
      publishedAtIso: e.publishedAtIso,
      discoveredAt: e.discoveredAt,
      rawSummary: e.rawSummary,
      plainEnglishSummary: e.plainEnglishSummary,
      whyItMatters: e.whyItMatters,
      whoItIsFor: e.whoItIsFor,
      howItCompares: e.howItCompares,
      practicalTakeaway: e.practicalTakeaway,
      tryItSuggestion: e.tryItSuggestion,
      beginnerNote: e.beginnerNote,
      analysisSource: e.analysisSource,
      primaryMetricLabel: e.primaryMetricLabel,
      primaryMetricValue: e.primaryMetricValue,
      secondaryMetricLabel: e.secondaryMetricLabel,
      secondaryMetricValue: e.secondaryMetricValue,
      metricDeltaLabel: e.metricDeltaLabel,
      metricDeltaValue: e.metricDeltaValue,
      sources: decodeSources(e.sourcesJson),
      rankScore: e.rankScore,
      isExploratory: e.isExploratory,
      isBookmarked: e.isBookmarked,
      bookmarkCollection: e.bookmarkCollection,
      bookmarkNote: e.bookmarkNote,
      isRead: e.isRead,
      isExplored: e.isExplored,
    );
  }
}

class RadarTrendEvidence {
  final String sourceName;
  final String evidenceSummary;
  final double? metricDelta;

  const RadarTrendEvidence({
    required this.sourceName,
    required this.evidenceSummary,
    this.metricDelta,
  });

  factory RadarTrendEvidence.fromJson(Map<String, dynamic> json) => RadarTrendEvidence(
        sourceName: (json['source_name'] ?? '').toString(),
        evidenceSummary: (json['evidence_summary'] ?? '').toString(),
        metricDelta: (json['metric_delta'] as num?)?.toDouble(),
      );
}

class RadarTrendCandidate {
  final String id;
  final String topicKey;
  final String label;
  final String primaryCategory;
  final String status; // emerging, growing, established, cooling, insufficient_evidence
  final double trendScore;
  final int sourceDiversityCount;
  final int mentionCount;
  final String explanation;
  final List<RadarTrendEvidence> evidence;

  const RadarTrendCandidate({
    required this.id,
    required this.topicKey,
    required this.label,
    required this.primaryCategory,
    required this.status,
    required this.trendScore,
    required this.sourceDiversityCount,
    required this.mentionCount,
    required this.explanation,
    required this.evidence,
  });

  factory RadarTrendCandidate.fromJson(Map<String, dynamic> json) {
    final evList = (json['evidence'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(RadarTrendEvidence.fromJson)
        .toList();
    return RadarTrendCandidate(
      id: (json['id'] ?? '').toString(),
      topicKey: (json['topic_key'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      primaryCategory: (json['primary_category'] ?? 'B').toString(),
      status: (json['status'] ?? 'insufficient_evidence').toString(),
      trendScore: (json['trend_score'] as num?)?.toDouble() ?? 0.0,
      sourceDiversityCount: (json['source_diversity_count'] as num?)?.toInt() ?? 0,
      mentionCount: (json['mention_count'] as num?)?.toInt() ?? 0,
      explanation: (json['explanation'] ?? '').toString(),
      evidence: evList,
    );
  }
}

class RadarBriefingSection {
  final String key;
  final String title;
  final List<Map<String, dynamic>> items;
  final String? emptyNote;

  const RadarBriefingSection({
    required this.key,
    required this.title,
    required this.items,
    this.emptyNote,
  });

  factory RadarBriefingSection.fromJson(Map<String, dynamic> json) => RadarBriefingSection(
        key: (json['key'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        items: (json['items'] as List? ?? []).whereType<Map<String, dynamic>>().toList(),
        emptyNote: json['empty_note']?.toString(),
      );
}

class RadarBriefing {
  final String id;
  final String briefingType;
  final String briefingDate;
  final String headline;
  final List<RadarBriefingSection> sections;
  final String generatedBy;

  const RadarBriefing({
    required this.id,
    required this.briefingType,
    required this.briefingDate,
    required this.headline,
    required this.sections,
    required this.generatedBy,
  });
}

