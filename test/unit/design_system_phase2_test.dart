import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/widgets/app_progress_ring.dart';
import 'package:progress_os/core/widgets/quick_stat_mini_card.dart';
import 'package:progress_os/features/dashboard/widgets/today_progress_card.dart';

void main() {
  group('Design System Phase 2 & Overhaul Widget Tests', () {
    testWidgets('TodayProgressCard renders percentage, task counts, and bars', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodayProgressCard(
              percentage: 0.75,
              completedTasks: 6,
              totalTasks: 8,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text("Today's Progress"), findsOneWidget);
      expect(find.text("75%"), findsOneWidget);
      expect(find.text("6 of 8 tasks"), findsOneWidget);

      await tester.tap(find.byType(TodayProgressCard));
      expect(tapped, isTrue);
    });

    testWidgets('QuickStatMiniCard renders title, value, and badge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuickStatMiniCard(
              variant: QuickStatVariant.projects,
              title: 'Projects',
              value: '3',
              badgeText: 'Active',
            ),
          ),
        ),
      );

      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('AppProgressRing renders custom painter and center child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppProgressRing(
              progress: 0.68,
              size: 160.0,
              centerChild: Text('68% Overall'),
            ),
          ),
        ),
      );

      expect(find.text('68% Overall'), findsOneWidget);
      expect(find.byType(AppProgressRing), findsOneWidget);
    });
  });
}
