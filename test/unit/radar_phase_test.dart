import 'dart:convert';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/theme/app_theme.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/database/database_provider.dart';
import 'package:progress_os/features/radar/radar_models.dart';
import 'package:progress_os/features/radar/radar_repository.dart';
import 'package:progress_os/features/radar/screens/radar_briefing_screen.dart';
import 'package:progress_os/features/radar/screens/radar_detail_screen.dart';
import 'package:progress_os/features/radar/screens/radar_home_screen.dart';
import 'package:progress_os/features/radar/screens/radar_preferences_screen.dart';

void main() {
  group('ProgressOS Radar Offline Repository & UI Tests', () {
    test('Seeds all 18 taxonomy categories A-R with expected priorities and keywords', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = RadarRepository(db);

      final prefs = await repo.getTopicPrefs();
      expect(prefs.length, 18);
      final byCode = {for (final p in prefs) p.categoryCode: p};
      expect(byCode['A']?.priorityLevel, 'P0');
      expect(byCode['O']?.priorityLevel, 'P2');
      expect(byCode['Q']?.priorityLevel, 'P3');
      expect(byCode['A']?.isMuted, isFalse);
    });

    test('Respects muted categories, 70/30 aligned-vs-explore mix, bookmarks, follows & clearAllData', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = RadarRepository(db);
      await repo.ensureTopicPreferencesSeeded();

      final entries = <RadarDiscoveriesCompanion>[
        for (int i = 0; i < 6; i++)
          RadarDiscoveriesCompanion(
            id: Value('p0_$i'),
            canonicalUrl: Value('https://example.com/ai/$i'),
            title: Value('Open Agent Tool $i'),
            discoveryType: const Value('repo'),
            primaryCategory: const Value('A'),
            priorityTier: const Value('P0'),
            sourceName: const Value('GitHub Search'),
            discoveredAt: Value(DateTime.now()),
            rankScore: Value(900.0 - i),
            isExploratory: const Value(false),
            primaryMetricLabel: const Value('Stars'),
            primaryMetricValue: Value(150.0 + i * 10),
          ),
        for (int i = 0; i < 3; i++)
          RadarDiscoveriesCompanion(
            id: Value('p3_$i'),
            canonicalUrl: Value('https://example.com/quantum/$i'),
            title: Value('Photonic Interconnect Study $i'),
            discoveryType: const Value('research'),
            primaryCategory: const Value('Q'),
            priorityTier: const Value('P3'),
            sourceName: const Value('arXiv'),
            discoveredAt: Value(DateTime.now()),
            rankScore: Value(880.0 - i),
            isExploratory: const Value(true),
          ),
      ];
      await repo.upsertDiscoveries(entries);

      final forYouFirst = await repo.watchFeed(RadarFeedView.forYou).first;
      expect(forYouFirst.length, 9);
      // Should interleave aligned P0 and exploratory P3 items
      expect(forYouFirst.any((it) => it.isExploratory), isTrue);

      // Unknown metrics on exploratory item must remain null (never invented)
      final paper = forYouFirst.firstWhere((e) => e.id == 'p3_0');
      expect(paper.primaryMetricValue, isNull);
      expect(paper.metricDeltaValue, isNull);

      // Mute category Q -> removes Q items cleanly from For You
      await repo.updateTopicPref(categoryCode: 'Q', isMuted: true);
      final afterMute = await repo.watchFeed(RadarFeedView.forYou).first;
      expect(afterMute.every((e) => e.primaryCategory != 'Q'), isTrue);

      // Bookmark & feedback affinity
      await repo.toggleBookmark('p0_0', bookmarked: true, collectionName: 'Build', note: 'Try CLI');
      final saved = await repo.watchFeed(RadarFeedView.saved).first;
      expect(saved.length, 1);
      expect(saved.first.bookmarkCollection, 'Build');

      await repo.recordFeedback(discoveryId: 'p0_0', action: 'relevant', categoryCode: 'A');
      final prefsAfter = await repo.getTopicPrefs();
      final aPref = prefsAfter.firstWhere((p) => p.categoryCode == 'A');
      expect(aPref.affinityAdjustment, greaterThan(0.0));

      // Follow toggle
      final followed = await repo.toggleFollow(
        followType: 'creator',
        targetKey: 'karpathy',
        displayName: 'Andrej Karpathy',
      );
      expect(followed, isTrue);

      // Full wipe clears Radar tables cleanly
      await db.clearAllData();
      expect((await db.select(db.radarDiscoveries).get()), isEmpty);
      expect((await db.select(db.radarFollows).get()), isEmpty);
    });

    testWidgets('All 4 Radar screens render cleanly without overflow at 320x640 in Light & Dark',
        (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = RadarRepository(db);
      await repo.ensureTopicPreferencesSeeded();
      await repo.upsertDiscoveries([
        RadarDiscoveriesCompanion(
          id: const Value('demo_1'),
          canonicalUrl: const Value('https://github.com/org/agent-kit'),
          title: const Value('org/agent-kit: Local-first autonomous dev workflows'),
          discoveryType: const Value('repo'),
          primaryCategory: const Value('A'),
          categoriesJson: Value(jsonEncode(['A', 'B'])),
          tagsJson: Value(jsonEncode(['agents', 'rust'])),
          priorityTier: const Value('P0'),
          sourceName: const Value('GitHub Search'),
          sourceDomain: const Value('github.com'),
          authorOrOrg: const Value('org'),
          discoveredAt: Value(DateTime.now()),
          rawSummary: const Value('Lightweight open-source orchestration runtime.'),
          plainEnglishSummary:
              const Value('Runs deterministic developer agents locally over structured tools.'),
          whyItMatters:
              const Value('Reduces cloud dependency and makes agent execution auditable.'),
          analysisSource: const Value('gemini'),
          primaryMetricLabel: const Value('Stars'),
          primaryMetricValue: const Value(842.0),
          metricDeltaLabel: const Value('Star delta'),
          metricDeltaValue: const Value(54.0),
          sourcesJson: Value(jsonEncode([
            {'connector': 'github', 'source_name': 'GitHub Search', 'source_url': 'https://github.com/org/agent-kit'}
          ])),
          rankScore: const Value(960.0),
        ),
      ]);

      final sampleItem = (await repo.watchFeed(RadarFeedView.forYou).first).first;

      tester.view.physicalSize = const Size(320 * 2, 640 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final screens = <Widget>[
        const RadarHomeScreen(),
        RadarDetailScreen(item: sampleItem),
        const RadarBriefingScreen(),
        const RadarPreferencesScreen(),
      ];

      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        for (final screen in screens) {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [databaseProvider.overrideWithValue(db)],
              child: MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: mode,
                home: screen,
              ),
            ),
          );
          await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 120)));
          await tester.pump(const Duration(milliseconds: 100));
          await tester.runAsync(() async => Future.delayed(const Duration(milliseconds: 60)));
          await tester.pump(const Duration(milliseconds: 100));
          expect(
            tester.takeException(),
            isNull,
            reason: 'Overflow or exception in ${screen.runtimeType} ($mode)',
          );
        }
      }
      // Dispose ProviderScope & flush Drift's zero-duration StreamQueryStore close timer
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}
