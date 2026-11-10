import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/theme/app_motion.dart';
import 'package:progress_os/data/database/app_database.dart';
import 'package:progress_os/data/repositories/rewards_repository.dart';
import 'package:progress_os/data/repositories/task_repository.dart';
import 'package:progress_os/services/focus_timer_controller.dart';
import 'package:progress_os/services/notification_preferences.dart';

void main() {
  group('UX Engineering, Motion & Personality Tests', () {
    test('RewardsRepository blocks duplicate XP farming and unlocks achievement cleanly', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final taskRepo = TaskRepository(db);
      final rewardsRepo = RewardsRepository(db);

      final task = await taskRepo.createTask(title: 'Verify UX motion suite');
      await taskRepo.toggleTaskCompletion(task.id, true);

      final first = await rewardsRepo.recordActivityAndEvaluate(
        sourceKey: 'task:${task.id}',
        sourceType: 'task',
        amount: RewardsRepository.xpTaskCompleted,
        summary: 'Completed Verify UX motion suite',
      );
      expect(first.xpAdded, RewardsRepository.xpTaskCompleted);
      expect(first.newlyUnlocked.any((a) => a.id == 'first_spark'), isTrue);

      // Re-recording same sourceKey must award 0 additional XP & not re-unlock
      final duplicate = await rewardsRepo.recordActivityAndEvaluate(
        sourceKey: 'task:${task.id}',
        sourceType: 'task',
        amount: RewardsRepository.xpTaskCompleted,
        summary: 'Completed Verify UX motion suite',
      );
      expect(duplicate.xpAdded, 0);
      expect(duplicate.newlyUnlocked, isEmpty);

      final xpRows = await (db.select(db.xpEvents)).get();
      expect(xpRows.length, 1);
      expect(xpRows.first.amount, RewardsRepository.xpTaskCompleted);

      final total = await (db.select(db.unlockedAchievements)).get();
      expect(total.where((a) => a.id == 'first_spark').length, 1);
    });

    test('FocusTimerState.effectiveFocusedSeconds accumulates running time without counting paused intervals', () {
      final t0 = DateTime(2026, 11, 10, 10, 0, 0);
      const pausedAfter300 = FocusTimerState(
        targetMinutes: 25,
        remainingSeconds: 20 * 60,
        accumulatedFocusedSeconds: 300,
        segmentStartEpochMs: null,
        isRunning: false,
      );
      // Elapsed 2 hours later while paused -> still 300s!
      expect(
        pausedAfter300.effectiveFocusedSeconds(now: t0.add(const Duration(hours: 2))),
        300,
      );

      final resumed = pausedAfter300.copyWith(
        isRunning: true,
        segmentStartEpochMs: () => t0.millisecondsSinceEpoch,
      );
      expect(
        resumed.effectiveFocusedSeconds(now: t0.add(const Duration(seconds: 95))),
        395,
      );
    });

    test('NotificationPreferences.isWithinQuietHours and adjustForQuietHours handle overnight windows', () {
      const prefs = NotificationPreferences(
        quietHoursEnabled: true,
        quietStartMinutes: 22 * 60,
        quietEndMinutes: 7 * 60 + 30,
      );

      expect(prefs.isWithinQuietHours(DateTime(2026, 11, 10, 23, 15)), isTrue);
      expect(prefs.isWithinQuietHours(DateTime(2026, 11, 11, 6, 45)), isTrue);
      expect(prefs.isWithinQuietHours(DateTime(2026, 11, 11, 8, 0)), isFalse);

      final shiftedNight = prefs.adjustForQuietHours(DateTime(2026, 11, 10, 23, 0));
      expect(shiftedNight, DateTime(2026, 11, 11, 7, 30));

      final shiftedMorning = prefs.adjustForQuietHours(DateTime(2026, 11, 11, 5, 10));
      expect(shiftedMorning, DateTime(2026, 11, 11, 7, 30));

      final untouched = prefs.adjustForQuietHours(DateTime(2026, 11, 11, 14, 0));
      expect(untouched, DateTime(2026, 11, 11, 14, 0));
    });

    testWidgets('AppMotion respects MediaQuery.disableAnimations by collapsing durations to zero', (tester) async {
      Duration? normalResolved;
      Duration? reducedResolved;
      bool? reducedFlagNormal;
      bool? reducedFlagDisabled;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              reducedFlagNormal = AppMotion.isReducedMotion(ctx);
              normalResolved = AppMotion.resolveDuration(ctx, AppMotion.moderate);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(reducedFlagNormal, isFalse);
      expect(normalResolved, AppMotion.moderate);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Builder(
              builder: (ctx) {
                reducedFlagDisabled = AppMotion.isReducedMotion(ctx);
                reducedResolved = AppMotion.resolveDuration(ctx, AppMotion.moderate);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(reducedFlagDisabled, isTrue);
      expect(reducedResolved, Duration.zero);
    });
  });
}
