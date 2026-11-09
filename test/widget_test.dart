import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/theme/app_colors.dart';
import 'package:progress_os/core/theme/app_theme.dart';
import 'package:progress_os/core/widgets/app_badges.dart';
import 'package:progress_os/core/widgets/app_button.dart';
import 'package:progress_os/core/widgets/app_progress_bar.dart';
import 'package:progress_os/core/widgets/app_stat_card.dart';
import 'package:progress_os/core/widgets/avatar_stack.dart';
import 'package:progress_os/core/widgets/pastel_card.dart';
import 'package:progress_os/core/widgets/progress_card.dart';

void main() {
  group('Design System Widget Tests', () {
    testWidgets('AppButton renders label and responds to tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: AppButton(
              label: 'Execute Command',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Execute Command'), findsOneWidget);
      await tester.tap(find.text('Execute Command'));
      expect(tapped, isTrue);
    });

    testWidgets('AppStatCard renders title, value, and subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AppStatCard(
              title: 'Streak',
              value: '14 days',
              subtitle: 'Active consistency',
              icon: Icons.local_fire_department,
            ),
          ),
        ),
      );

      expect(find.text('STREAK'), findsOneWidget);
      expect(find.text('14 days'), findsOneWidget);
      expect(find.text('Active consistency'), findsOneWidget);
    });

    testWidgets('AppPriorityBadge displays correct styling and text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AppPriorityBadge(priority: 'urgent'),
          ),
        ),
      );

      expect(find.text('Urgent'), findsOneWidget);
    });

    testWidgets('AppProgressBar calculates percentage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: AppProgressBar(
              progress: 0.75,
              showPercentage: true,
              label: 'Progress Test',
            ),
          ),
        ),
      );

      expect(find.text('Progress Test'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('PastelCard renders child with gradient and wave decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PastelCard(
              gradient: AppColors.projectHeroGradient,
              child: Text('Hero Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Hero Card Content'), findsOneWidget);
    });

    testWidgets('ProgressCard renders title, percentage, and date pill', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressCard(
              title: 'Customer Journey Map',
              progress: 0.55,
              date: '06 Dec, 2026',
            ),
          ),
        ),
      );

      expect(find.text('Customer Journey Map'), findsOneWidget);
      expect(find.text('55%'), findsOneWidget);
      expect(find.text('06 Dec, 2026'), findsOneWidget);
    });

    testWidgets('AvatarStack renders overlapping circles', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarStack(maxAvatars: 3),
          ),
        ),
      );

      expect(find.byType(AvatarStack), findsOneWidget);
    });
  });
}
