import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../services/widget_sync_service.dart';
import '../widgets/goal_card.dart';
import '../widgets/habit_card.dart';

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

  void _showLogGoalProgressDialog(Goal goal) {
    final controller = TextEditingController(text: goal.currentValue.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Progress: ${goal.title}', style: AppTypography.titleMedium),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Current Value (${goal.unit})',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final val = double.tryParse(controller.text.trim());
              if (val != null) {
                final diff = val - goal.currentValue;
                await ref.read(habitRepositoryProvider).updateGoalProgress(goal.id, diff);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: HabitCard(
                      habitWithEntries: hWithE,
                      weekDayLabels: weekDayLabels,
                      onToggleToday: () async {
                        await habitRepo.toggleHabitCheckIn(hWithE.habit.id, DateTime.now());
                        await widgetSync.syncAllWidgets();
                      },
                      onDelete: () => habitRepo.deleteHabit(hWithE.habit.id),
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GoalCard(
                      goal: g,
                      onIncrement: () => habitRepo.updateGoalProgress(g.id, 1.0),
                      onLogValue: () => _showLogGoalProgressDialog(g),
                      onDelete: () => habitRepo.deleteGoal(g.id),
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
