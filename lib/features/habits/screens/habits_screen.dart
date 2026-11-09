import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../services/widget_sync_service.dart';

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

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(ctx).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedLg),
          title: Text('New Technical Habit', style: AppTypography.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Habit Title',
                hintText: 'e.g. Solve 1 LeetCode problem, Read 20 mins docs',
                controller: titleController,
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Description (Optional)',
                hintText: 'e.g. Build strong algorithmic problem-solving habits',
                controller: descController,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Target Days / Week', style: AppTypography.titleSmall),
                  DropdownButton<int>(
                    value: targetDays,
                    items: [3, 4, 5, 6, 7]
                        .map((d) => DropdownMenuItem(value: d, child: Text('$d days')))
                        .toList(),
                    onChanged: (val) => setDialogState(() => targetDays = val ?? 7),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            AppButton(
              label: 'Add Habit',
              size: AppButtonSize.small,
              onPressed: () async {
                if (titleController.text.trim().isNotEmpty) {
                  await ref.read(habitRepositoryProvider).createHabit(
                        title: titleController.text.trim(),
                        description: descController.text.trim().isEmpty ? null : descController.text.trim(),
                        targetDaysPerWeek: targetDays,
                      );
                  await ref.read(widgetSyncServiceProvider).syncAllWidgets();
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController(text: '10');
    final unitController = TextEditingController(text: 'hours');
    String type = 'weekly';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(ctx).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedLg),
          title: Text('New Performance Goal', style: AppTypography.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Goal Title',
                hintText: 'e.g. Spend 10 hours on Startup, Finish 5 modules',
                controller: titleController,
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: type,
                      decoration: const InputDecoration(labelText: 'Cadence'),
                      items: const [
                        DropdownMenuItem(value: 'daily', child: Text('Daily')),
                        DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                        DropdownMenuItem(value: 'long_term', child: Text('Long Term')),
                      ],
                      onChanged: (val) => setDialogState(() => type = val ?? 'weekly'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      label: 'Target Value',
                      hintText: '10',
                      controller: targetController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Unit',
                hintText: 'e.g. hours, problems, commits',
                controller: unitController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            AppButton(
              label: 'Create Goal',
              size: AppButtonSize.small,
              onPressed: () async {
                final targetVal = double.tryParse(targetController.text.trim()) ?? 10.0;
                if (titleController.text.trim().isNotEmpty) {
                  await ref.read(habitRepositoryProvider).createGoal(
                        title: titleController.text.trim(),
                        type: type,
                        targetValue: targetVal,
                        unit: unitController.text.trim(),
                      );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
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
    final goalsAsync = ref.watch(allGoalsStreamProvider);
    final habitRepo = ref.watch(habitRepositoryProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);

    final now = DateTime.now();
    final weekDayLabels = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DateFormat('E').format(d).substring(0, 1);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits & Goals'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onSelected: (val) {
              if (val == 'habit') _showAddHabitDialog();
              if (val == 'goal') _showAddGoalDialog();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'habit', child: Text('Add Habit')),
              const PopupMenuItem(value: 'goal', child: Text('Add Goal')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Habits Section Header
          SectionHeader(
            title: 'Technical Habits & Streaks',
            subtitle: 'Consistency is key to engineering excellence',
            actionLabel: '+ Add Habit',
            onAction: _showAddHabitDialog,
          ),
          const SizedBox(height: 8.0),

          // Habits List
          habitsAsync.when(
            data: (habits) {
              if (habits.isEmpty) {
                return AppCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.bolt_outlined, size: 28, color: AppColors.darkTextMuted),
                          const SizedBox(height: 8),
                          Text('No habits tracked yet', style: AppTypography.titleSmall),
                          const SizedBox(height: 4),
                          Text(
                            'Track daily coding, technical reading, or exercise.',
                            style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            label: 'Create First Habit',
                            size: AppButtonSize.small,
                            variant: AppButtonVariant.secondary,
                            onPressed: _showAddHabitDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: habits.map((hWithE) {
                  final habit = hWithE.habit;
                  final isCheckedToday = hWithE.isCompletedToday;
                  final streak = hWithE.currentStreak;
                  final activity = hWithE.last7DaysActivity;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await habitRepo.toggleHabitCheckIn(habit.id, DateTime.now());
                                      await widgetSync.syncAllWidgets();
                                    },
                                    child: Container(
                                      width: 24.0,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCheckedToday ? AppColors.success : Colors.transparent,
                                        border: Border.all(
                                          color: isCheckedToday ? AppColors.success : AppColors.darkTextMuted,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: isCheckedToday
                                          ? const Icon(Icons.check_rounded, size: 16.0, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          habit.title,
                                          style: AppTypography.titleSmall.copyWith(
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                        if (habit.description != null)
                                          Text(
                                            habit.description!,
                                            style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Streak badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: streak > 0 ? AppColors.warningSoft : AppColors.darkSurfaceElevated,
                                borderRadius: AppRadii.roundedSm,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department_rounded,
                                    size: 16.0,
                                    color: streak > 0 ? AppColors.warning : AppColors.darkTextMuted,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '$streak d',
                                    style: AppTypography.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: streak > 0 ? AppColors.warning : AppColors.darkTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18),
                              onPressed: () => habitRepo.deleteHabit(habit.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),

                        // Past 7 Days Activity Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (idx) {
                            final done = activity[idx];
                            return Column(
                              children: [
                                Text(
                                  weekDayLabels[idx],
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 10.0,
                                    color: AppColors.darkTextMuted,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Container(
                                  width: 18.0,
                                  height: 18.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: done
                                        ? AppColors.primary
                                        : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated),
                                  ),
                                  child: done
                                      ? const Icon(Icons.check, size: 12, color: Color(0xFF0F172A))
                                      : null,
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => ErrorStateView(message: err.toString()),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Goals Section Header
          SectionHeader(
            title: 'Growth Goals',
            subtitle: 'Measurable targets to push your limits',
            actionLabel: '+ Add Goal',
            onAction: _showAddGoalDialog,
          ),
          const SizedBox(height: 8.0),

          // Goals List
          goalsAsync.when(
            data: (goals) {
              if (goals.isEmpty) {
                return AppCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.flag_outlined, size: 28, color: AppColors.darkTextMuted),
                          const SizedBox(height: 8),
                          Text('No goals set', style: AppTypography.titleSmall),
                          const SizedBox(height: 4),
                          Text(
                            'Define quantifiable targets like coding 10 hours a week.',
                            style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            label: 'Add a Goal',
                            size: AppButtonSize.small,
                            variant: AppButtonVariant.secondary,
                            onPressed: _showAddGoalDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: goals.map((g) {
                  final progress = (g.targetValue > 0) ? (g.currentValue / g.targetValue).clamp(0.0, 1.0) : 0.0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(
                        color: g.isAchieved
                            ? AppColors.success.withOpacity(0.5)
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: AppColors.infoSoft,
                                borderRadius: AppRadii.roundedXs,
                              ),
                              child: Text(
                                g.type.toUpperCase(),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.info,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                if (g.isAchieved)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.successSoft,
                                      borderRadius: AppRadii.roundedXs,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
                                        const SizedBox(width: 4),
                                        Text(
                                          'ACHIEVED',
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                  onPressed: () => habitRepo.deleteGoal(g.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6.0),
                        Text(g.title, style: AppTypography.titleSmall),
                        const SizedBox(height: 8.0),

                        AppProgressBar(
                          progress: progress,
                          progressColor: g.isAchieved ? AppColors.success : AppColors.primary,
                          label: '${g.currentValue.toStringAsFixed(1)} / ${g.targetValue.toStringAsFixed(1)} ${g.unit}',
                          showPercentage: true,
                        ),
                        const SizedBox(height: 8.0),

                        // Increment buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => habitRepo.updateGoalProgress(g.id, 1.0),
                              icon: const Icon(Icons.add, size: 14),
                              label: Text('+1 ${g.unit}', style: AppTypography.caption),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => ErrorStateView(message: err.toString()),
          ),
        ],
      ),
    );
  }
}
