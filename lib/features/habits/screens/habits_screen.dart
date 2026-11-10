import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/reward_celebration_sheet.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/widget_sync_service.dart';
import '../widgets/habit_card.dart';

/// Screen 6 — Dedicated Daily Habits & Consistency Tracking.
class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  void _showAddHabitDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    int targetDays = 7;
    TimeOfDay? reminderTime;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Habit Title',
                  hintText: 'e.g. Read 20m documentation, Daily deep work',
                  controller: titleController,
                  autofocus: true,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Notes (Optional)',
                  hintText: 'Why does this habit matter?',
                  controller: descController,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Target Days / Week'),
                    DropdownButton<int>(
                      value: targetDays,
                      items: [3, 4, 5, 6, 7]
                          .map((d) => DropdownMenuItem(value: d, child: Text('$d days')))
                          .toList(),
                      onChanged: (val) => setDialogState(() => targetDays = val ?? 7),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SelectionField(
                  label: 'Daily reminder',
                  valueText: reminderTime == null
                      ? 'Optional reminder time'
                      : reminderTime!.format(ctx),
                  icon: AppIcons.reminder,
                  isPlaceholder: reminderTime == null,
                  onTap: () async {
                    final notif = ref.read(notificationServiceProvider);
                    await notif.requestPermissionsWithExplanation(ctx);
                    if (!ctx.mounted) return;
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: const TimeOfDay(hour: 20, minute: 0),
                    );
                    if (picked != null) {
                      setDialogState(() => reminderTime = picked);
                    }
                  },
                  onClear: reminderTime == null
                      ? null
                      : () => setDialogState(() => reminderTime = null),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              label: 'Create Habit',
              size: AppButtonSize.small,
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) return;

                final timeStr = reminderTime == null
                    ? null
                    : '${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}';

                await ref.read(habitRepositoryProvider).createHabit(
                      title: title,
                      description: descController.text.trim().isEmpty
                          ? null
                          : descController.text.trim(),
                      targetDaysPerWeek: targetDays,
                      reminderTime: timeStr,
                    );

                if (reminderTime != null) {
                  await ref.read(notificationServiceProvider).scheduleHabitReminder(
                        habitId: title,
                        title: title,
                        hour: reminderTime!.hour,
                        minute: reminderTime!.minute,
                      );
                }

                await ref.read(feedbackServiceProvider).buttonTap();
                await ref.read(widgetSyncServiceProvider).syncAllWidgets();
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final habitsAsync = ref.watch(allHabitsStreamProvider);
    final habitRepo = ref.watch(habitRepositoryProvider);
    final notifService = ref.read(notificationServiceProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);
    final feedback = ref.read(feedbackServiceProvider);

    final now = DateTime.now();
    final weekDayLabels = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DateFormat('E').format(d).substring(0, 1);
    });

    return AppScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddHabitDialog,
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(AppIcons.add),
        label: const Text('New Habit', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          PageTitle(
            title: 'Habits',
            subtitle: 'Calm daily rituals & calculated streaks',
            showBackButton: true,
            actions: [
              SecondaryButton(
                label: 'Goals',
                icon: AppIcons.goals,
                size: AppButtonSize.small,
                onPressed: () => context.push('/goals'),
              ),
            ],
          ),
          Expanded(
            child: habitsAsync.when(
              loading: () => const TasksSkeleton(),
              error: (err, _) => ErrorStateView(message: err.toString()),
              data: (habits) {
                if (habits.isEmpty) {
                  return EmptyStateView(
                    icon: AppIcons.habits,
                    illustrationAsset: 'assets/images/empty/empty_habits.png',
                    title: 'Small actions make meaningful progress.',
                    description: 'Build calm consistency by checking in on daily practices.',
                    actionLabel: 'Create a habit',
                    onAction: _showAddHabitDialog,
                  );
                }

                final completedTodayCount =
                    habits.where((h) => h.isCompletedToday).length;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.xs,
                    AppSpacing.pageHorizontal,
                    96.0,
                  ),
                  children: [
                    SectionHeader(
                      title: 'Today ($completedTodayCount of ${habits.length} done)',
                      actionLabel: '+ Add',
                      onAction: _showAddHabitDialog,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ...habits.map(
                      (hWithE) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: HabitCard(
                          habitWithEntries: hWithE,
                          weekDayLabels: weekDayLabels,
                          onToggleToday: () async {
                            final wasDone = hWithE.isCompletedToday;
                            final today = DateTime.now();
                            final dateIso = DateFormat('yyyy-MM-dd').format(today);
                            await feedback.habitCheckedIn();
                            await habitRepo.toggleHabitCheckIn(hWithE.habit.id, today);
                            await widgetSync.syncAllWidgets();
                            if (!context.mounted) return;
                            if (!wasDone) {
                              final reward = await ref
                                  .read(rewardsRepositoryProvider)
                                  .recordActivityAndEvaluate(
                                    sourceKey: 'habit:${hWithE.habit.id}:$dateIso',
                                    sourceType: 'habit',
                                    amount: RewardsRepository.xpHabitCheckIn,
                                    summary: 'Checked in: ${hWithE.habit.title}',
                                  );
                              if (!context.mounted) return;
                              final xpNote =
                                  reward.xpAdded > 0 ? ' (+${reward.xpAdded} XP)' : '';
                              AppToast.showWithUndo(
                                context,
                                'Checked in.$xpNote',
                                onUndo: () async {
                                  await habitRepo.toggleHabitCheckIn(hWithE.habit.id, today);
                                  await widgetSync.syncAllWidgets();
                                },
                              );
                              if (reward.newlyUnlocked.isNotEmpty) {
                                await feedback.achievementUnlocked();
                                if (context.mounted) {
                                  await RewardCelebrationDialog.show(
                                    context,
                                    achievement: reward.newlyUnlocked.first,
                                    xpEarned: reward.xpAdded,
                                  );
                                }
                              }
                            } else {
                              AppToast.show(context, 'Check-in removed for today.');
                            }
                          },
                          onDelete: () async {
                            await feedback.destructiveAction();
                            await notifService.cancelHabitReminder(hWithE.habit.title);
                            await habitRepo.deleteHabit(hWithE.habit.id);
                            await widgetSync.syncAllWidgets();
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
