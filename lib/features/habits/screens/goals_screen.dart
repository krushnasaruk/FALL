import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/reward_celebration_sheet.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/widget_sync_service.dart';
import '../widgets/goal_card.dart';

/// Screen 5 — Dedicated Goals & Outcomes screen, clearly distinct from actionable Tasks.
class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  String _selectedType = 'all';

  final _types = const [
    {'value': 'all', 'label': 'All'},
    {'value': 'daily', 'label': 'Daily'},
    {'value': 'weekly', 'label': 'Weekly'},
    {'value': 'monthly', 'label': 'Monthly'},
    {'value': 'long_term', 'label': 'Long Term'},
  ];

  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController(text: '10');
    final unitController = TextEditingController(text: 'hrs');
    String type = 'weekly';
    DateTime? deadline;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Measurable Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Outcome Title',
                  hintText: 'e.g. Build 10 hrs of startup features',
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
                  hintText: 'hrs, modules, commits',
                  controller: unitController,
                ),
                const SizedBox(height: AppSpacing.md),
                SelectionField(
                  label: 'Deadline (Optional)',
                  valueText: deadline == null
                      ? 'No deadline set'
                      : '${deadline!.year}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.day.toString().padLeft(2, '0')}',
                  icon: AppIcons.calendar,
                  isPlaceholder: deadline == null,
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: deadline ?? now.add(const Duration(days: 7)),
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 365 * 5)),
                    );
                    if (picked != null) setDialogState(() => deadline = picked);
                  },
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
              label: 'Create Goal',
              size: AppButtonSize.small,
              onPressed: () async {
                final targetVal = double.tryParse(targetController.text.trim()) ?? 10.0;
                if (titleController.text.trim().isNotEmpty && targetVal > 0) {
                  await ref.read(habitRepositoryProvider).createGoal(
                        title: titleController.text.trim(),
                        type: type,
                        targetValue: targetVal,
                        unit: unitController.text.trim().isEmpty
                            ? 'units'
                            : unitController.text.trim(),
                        deadline: deadline,
                      );
                  await ref.read(feedbackServiceProvider).buttonTap();
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

  void _showLogGoalProgressDialog(Goal goal) {
    final controller = TextEditingController(text: goal.currentValue.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Goal Progress', style: AppTypography.titleMedium),
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
          PrimaryButton(
            label: 'Save',
            size: AppButtonSize.small,
            onPressed: () async {
              final val = double.tryParse(controller.text.trim());
              if (val != null) {
                final diff = val - goal.currentValue;
                final wasAchieved = goal.isAchieved;
                await ref.read(habitRepositoryProvider).updateGoalProgress(goal.id, diff);
                if (!wasAchieved && val >= goal.targetValue) {
                  await ref.read(feedbackServiceProvider).goalAchieved();
                  await ref.read(rewardsRepositoryProvider).recordActivityAndEvaluate(
                        sourceKey: 'goal:${goal.id}',
                        sourceType: 'goal',
                        amount: RewardsRepository.xpGoalAchieved,
                        summary: 'Achieved goal: ${goal.title}',
                      );
                } else {
                  await ref.read(feedbackServiceProvider).buttonTap();
                }
                await ref.read(widgetSyncServiceProvider).syncAllWidgets();
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goalsAsync = ref.watch(allGoalsStreamProvider);
    final repo = ref.watch(habitRepositoryProvider);
    final feedback = ref.read(feedbackServiceProvider);
    final widgetSync = ref.read(widgetSyncServiceProvider);

    return AppScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalDialog,
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(AppIcons.add),
        label: const Text('New Goal', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          PageTitle(
            title: 'Goals',
            subtitle: 'Measurable outcomes and milestone targets',
            showBackButton: true,
            actions: [
              AppIconButton(
                icon: AppIcons.add,
                tooltip: 'Add Goal',
                onPressed: _showAddGoalDialog,
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: Row(
              children: _types.map((t) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: AppFilterChip(
                    label: t['label']!,
                    selected: _selectedType == t['value'],
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _selectedType = t['value']!);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: goalsAsync.when(
              loading: () => const TasksSkeleton(),
              error: (err, _) => ErrorStateView(message: err.toString()),
              data: (goals) {
                final filtered = _selectedType == 'all'
                    ? goals
                    : goals.where((g) => g.type == _selectedType).toList();

                if (filtered.isEmpty) {
                  return EmptyStateView(
                    icon: AppIcons.goals,
                    illustrationAsset: 'assets/images/empty/empty_goals.png',
                    title: 'Give your effort a direction.',
                    description:
                        'Goals measure outcomes over time (separate from daily action tasks).',
                    actionLabel: 'Create a goal',
                    onAction: _showAddGoalDialog,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.xs,
                    AppSpacing.pageHorizontal,
                    96.0,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final g = filtered[index];
                    return GoalCard(
                      goal: g,
                      onIncrement: () async {
                        final wasDone = g.isAchieved;
                        await repo.updateGoalProgress(g.id, 1.0);
                        if (!wasDone && g.currentValue + 1.0 >= g.targetValue) {
                          await feedback.goalAchieved();
                          final reward = await ref
                              .read(rewardsRepositoryProvider)
                              .recordActivityAndEvaluate(
                                sourceKey: 'goal:${g.id}',
                                sourceType: 'goal',
                                amount: RewardsRepository.xpGoalAchieved,
                                summary: 'Achieved goal: ${g.title}',
                              );
                          if (context.mounted) {
                            final xpNote = reward.xpAdded > 0 ? ' (+${reward.xpAdded} XP)' : '';
                            AppToast.show(context, 'All done. Nice work.$xpNote', isSuccess: true);
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
                          }
                        } else {
                          await feedback.buttonTap();
                        }
                        await widgetSync.syncAllWidgets();
                      },
                      onLogValue: () => _showLogGoalProgressDialog(g),
                      onDelete: () async {
                        await feedback.destructiveAction();
                        await repo.deleteGoal(g.id);
                        await widgetSync.syncAllWidgets();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
