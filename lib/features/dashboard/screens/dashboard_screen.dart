import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_interaction.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/companion_avatar.dart';
import '../../../core/widgets/fall_logo.dart';
import '../../../core/widgets/quick_stat_mini_card.dart';
import '../../../core/widgets/reward_celebration_sheet.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/focus_repository.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/widget_sync_service.dart';
import '../../learning/screens/skill_detail_screen.dart';
import '../../projects/screens/project_detail_screen.dart';
import '../../tasks/widgets/task_detail_sheet.dart';
import '../../tasks/widgets/task_form_sheet.dart';
import '../widgets/dashboard_customization_sheet.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/today_progress_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greetingForHour(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _showNotificationsSheet(BuildContext context, List<TaskWithSubtasks> allTasks) {
    final upcomingReminders = allTasks
        .where((t) => !t.task.isCompleted && (t.task.reminderAt != null || t.task.dueDate != null))
        .take(5)
        .toList();

    AppBottomSheet.show(
      context,
      title: 'Upcoming Reminders',
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (upcomingReminders.isEmpty)
            const EmptyStateView(
              icon: AppIcons.notifications,
              title: 'No upcoming reminders',
              description: 'Set due times or reminders on tasks to stay alerted.',
            )
          else
            ...upcomingReminders.map((t) {
              final dt = t.task.reminderAt ?? t.task.dueDate!;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(AppIcons.reminder, color: AppColors.primary, size: 20.0),
                title: Text(t.task.title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  DateFormatters.dateTimeShort(dt),
                  style: AppTypography.metadata,
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  TaskDetailSheet.show(context, t);
                },
              );
            }),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Notification Settings',
            icon: AppIcons.settings,
            isFullWidth: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/settings');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final focusAsync = ref.watch(recentFocusSessionsProvider);
    final goalsAsync = ref.watch(allGoalsStreamProvider);
    final totalXp = ref.watch(totalXpStreamProvider).valueOrNull ?? 0;
    final prefsState = ref.watch(userPreferencesProvider);

    final taskRepo = ref.watch(taskRepositoryProvider);
    final rewardsRepo = ref.read(rewardsRepositoryProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);
    final feedback = ref.read(feedbackServiceProvider);

    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    final greeting = _greetingForHour(now.hour);

    return AppScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          feedback.buttonTap();
          TaskFormSheet.show(context);
        },
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        tooltip: 'New Task',
        child: const Icon(AppIcons.add, size: 26.0),
      ),
      body: tasksAsync.when(
        loading: () => const DashboardSkeleton(),
        error: (err, _) => ErrorStateView(
          message: 'Unable to load dashboard: $err',
          onRetry: () => ref.invalidate(allTasksStreamProvider),
        ),
        data: (allTasks) {
          final todayTasks = allTasks.where((t) {
            final d = t.task.dueDate;
            if (d == null) return false;
            return !d.isBefore(todayStart) && d.isBefore(todayEnd);
          }).toList();

          final completedToday = todayTasks.where((t) => t.task.isCompleted).length;
          final totalToday = todayTasks.length;
          final rate = totalToday > 0 ? (completedToday / totalToday).clamp(0.0, 1.0) : 0.0;

          // Real 7-day completed task counts
          final dailyCounts = List.generate(7, (idx) {
            final target = todayStart.subtract(Duration(days: 6 - idx));
            final next = target.add(const Duration(days: 1));
            return allTasks.where((t) {
              final c = t.task.completedAt;
              if (!t.task.isCompleted || c == null) return false;
              return !c.isBefore(target) && c.isBefore(next);
            }).length;
          });

          final upcomingTasks = allTasks.where((t) => !t.task.isCompleted).toList()
            ..sort((a, b) {
              final da = a.task.dueDate;
              final db = b.task.dueDate;
              if (da == null && db == null) return 0;
              if (da == null) return 1;
              if (db == null) return -1;
              return da.compareTo(db);
            });
          final visibleUpcoming = upcomingTasks.take(5).toList();

          final displayName = prefsState.displayName.trim().isEmpty
              ? 'Developer'
              : prefsState.displayName.trim();

          Widget buildSectionWidget(String sectionId) {
            switch (sectionId) {
              case 'hero_projects':
                return TodayProgressCard(
                  percentage: rate,
                  completedTasks: completedToday,
                  totalTasks: totalToday,
                  dailyCompletedCounts: dailyCounts,
                  onTap: () => context.go('/tasks'),
                );

              case 'quick_actions':
                return const QuickActionsBar();

              case 'productivity_stats':
                final openTaskCount = allTasks.where((t) => !t.task.isCompleted).length;
                final totalLearningMins = skillsAsync.valueOrNull?.fold<int>(
                      0,
                      (sum, s) => sum + s.skill.learningMinutes,
                    ) ??
                    0;
                final skillCount = skillsAsync.valueOrNull?.length ?? 0;

                final totalFocusMins = focusAsync.valueOrNull?.fold<int>(
                      0,
                      (sum, s) => sum + s.session.durationMinutes,
                    ) ??
                    0;
                final sessionCount = focusAsync.valueOrNull?.length ?? 0;

                final goalsList = goalsAsync.valueOrNull ?? const [];
                final achievedGoals = goalsList.where((g) => g.isAchieved).length;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: QuickStatMiniCard(
                            variant: QuickStatVariant.tasks,
                            title: 'Open Tasks',
                            value: '$openTaskCount',
                            badgeText: totalToday > 0 ? '$totalToday today' : null,
                            onTap: () => context.go('/tasks'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: QuickStatMiniCard(
                            variant: QuickStatVariant.focus,
                            title: 'Focus',
                            value: DateFormatters.formatMinutes(totalFocusMins),
                            badgeText: '$sessionCount logs',
                            onTap: () => context.push('/focus'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: QuickStatMiniCard(
                            variant: QuickStatVariant.learning,
                            title: 'Learning',
                            value: DateFormatters.formatMinutes(totalLearningMins),
                            badgeText: '$skillCount skills',
                            onTap: () => context.go('/learning'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: QuickStatMiniCard(
                            variant: QuickStatVariant.goals,
                            title: 'Goals',
                            value: '${goalsList.length}',
                            badgeText: goalsList.isNotEmpty
                                ? '$achievedGoals done'
                                : null,
                            onTap: () => context.push('/goals'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );

              case 'todays_priorities':
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Upcoming Tasks',
                      actionLabel: 'See all',
                      onAction: () => context.go('/tasks'),
                    ),
                    if (visibleUpcoming.isEmpty)
                      AppCard(
                        onTap: () => TaskFormSheet.show(context),
                        child: Row(
                          children: [
                            CompanionAvatar(
                              expression: allTasks.isEmpty
                                  ? CompanionExpression.idle
                                  : CompanionExpression.happy,
                              size: 52.0,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allTasks.isEmpty
                                        ? 'Nothing on your list yet.'
                                        : 'All done. Nice work.',
                                    style: AppTypography.cardTitle.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    allTasks.isEmpty
                                        ? 'Add a task to give your day a little direction.'
                                        : 'Tap + anytime to schedule your next step.',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...visibleUpcoming.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _DashboardTaskRow(
                              item: item,
                              onToggle: () async {
                                final nextState = !item.task.isCompleted;
                                await feedback.taskCompleted(completed: nextState);
                                await taskRepo.toggleTaskCompletion(item.task.id, nextState);
                                await widgetSync.syncAllWidgets();
                                if (!context.mounted) return;
                                if (nextState) {
                                  final reward = await rewardsRepo.recordActivityAndEvaluate(
                                    sourceKey: 'task:${item.task.id}',
                                    sourceType: 'task',
                                    amount: RewardsRepository.xpTaskCompleted,
                                    summary: 'Completed ${item.task.title}',
                                  );
                                  if (!context.mounted) return;
                                  final xpNote = reward.xpAdded > 0 ? ' (+${reward.xpAdded} XP)' : '';
                                  AppToast.showWithUndo(
                                    context,
                                    'Task done.$xpNote',
                                    onUndo: () async {
                                      await taskRepo.toggleTaskCompletion(item.task.id, false);
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
                                }
                              },
                              onTap: () => TaskDetailSheet.show(context, item),
                            ),
                          )),
                  ],
                );

              case 'ongoing_projects':
                final projects = projectsAsync.valueOrNull ?? const [];
                final activeProjects = projects
                    .where((p) => p.project.status == 'active' || p.project.status == 'planning')
                    .take(2)
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Active Projects',
                      actionLabel: 'See all',
                      onAction: () => context.go('/projects'),
                    ),
                    if (activeProjects.isEmpty)
                      AppCard(
                        onTap: () => context.go('/projects'),
                        child: Text(
                          'No active projects yet. Open Projects to start tracking milestones.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      ...activeProjects.map((p) {
                        final pct = (p.progressPercentage * 100).round();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProjectDetailScreen(projectId: p.project.id),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p.project.name,
                                        style: AppTypography.cardTitle.copyWith(
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      '$pct%',
                                      style: AppTypography.cardPercent.copyWith(
                                        color: isDark
                                            ? AppColors.primaryDark
                                            : AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                AppProgressBar(
                                  progress: p.progressPercentage,
                                  progressColor: AppColors.primary,
                                  backgroundColor: isDark
                                      ? AppColors.darkSurfaceElevated
                                      : AppColors.surfaceElevated,
                                  height: 6.0,
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppStatusBadge(status: p.project.status),
                                    Text(
                                      '${p.completedMilestonesCount}/${p.totalMilestonesCount} milestones',
                                      style: AppTypography.metadata.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                        fontFeatures: AppTypography.tabularFigures,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                );

              case 'learning_roadmaps':
                final skills = skillsAsync.valueOrNull ?? const [];
                final topSkill = skills.isNotEmpty ? skills.first : null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Learning Summary',
                      actionLabel: 'See all',
                      onAction: () => context.go('/learning'),
                    ),
                    if (topSkill == null)
                      AppCard(
                        onTap: () => context.go('/learning'),
                        child: Text(
                          'Add a skill roadmap to track study time and topic mastery.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      AppCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SkillDetailScreen(skillId: topSkill.skill.id),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkLearningSurface
                                    : AppColors.learningSurface,
                                borderRadius: AppRadii.roundedMd,
                              ),
                              child: const Icon(
                                AppIcons.learningActive,
                                color: AppColors.learningAccent,
                                size: 22.0,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topSkill.skill.name,
                                    style: AppTypography.cardTitle.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    '${topSkill.completedTopics} of ${topSkill.totalTopics} topics • ${DateFormatters.formatMinutes(topSkill.skill.learningMinutes)}',
                                    style: AppTypography.secondary.copyWith(
                                      fontSize: 12.5,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                      fontFeatures: AppTypography.tabularFigures,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${(topSkill.progressPercentage * 100).round()}%',
                              style: AppTypography.statMedium.copyWith(
                                fontSize: 18.0,
                                color: AppColors.learningAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );

              default:
                return const SizedBox.shrink();
            }
          }

          final orderedVisible = prefsState.dashboardSections
              .where((s) => s.isVisible)
              .map((s) => s.id)
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.lg,
              AppSpacing.pageHorizontal,
              96.0,
            ),
            children: [
              // 1. Compact Header with Time-Aware Greeting, Date, Level Badge, Reminders & Customize
              AppHeader(
                leading: GestureDetector(
                  onTap: () => context.push('/settings'),
                  child: const FallLogo(size: 40.0, isCircle: false),
                ),
                eyebrow: DateFormatters.dayOfWeekMonthDay(now),
                title: '$greeting, $displayName',
                actions: [
                  AppIconButton(
                    icon: AppIcons.notifications,
                    tooltip: 'Upcoming reminders',
                    onPressed: () {
                      feedback.buttonTap();
                      _showNotificationsSheet(context, allTasks);
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppIconButton(
                    icon: AppIcons.filter,
                    tooltip: 'Customize dashboard',
                    onPressed: () {
                      feedback.buttonTap();
                      DashboardCustomizationSheet.show(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Compact Level / XP Progress Strip linking to Insights & Achievements
              Align(
                alignment: Alignment.centerLeft,
                child: Semantics(
                  button: true,
                  label: 'Level ${RewardsRepository.levelForXp(totalXp)}, $totalXp XP. View achievements.',
                  child: InkWell(
                    onTap: () {
                      feedback.buttonTap();
                      context.push('/insights');
                    },
                    borderRadius: AppRadii.roundedFull,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkProjectSurface : AppColors.primarySoft,
                        borderRadius: AppRadii.roundedFull,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.primary.withOpacity(0.18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 14.0,
                            color: isDark ? AppColors.primaryDark : AppColors.primary,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'Lv.${RewardsRepository.levelForXp(totalXp)} • $totalXp XP',
                            style: AppTypography.metadata.copyWith(
                              color: isDark ? AppColors.primaryDark : AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (!prefsState.isTipDismissed('dashboard_reorder'))
                DismissibleTipBanner(
                  icon: AppIcons.filter,
                  title: 'Personalize your command center',
                  message:
                      'Tap the filter icon at the top right anytime to reorder or hide dashboard sections.',
                  onDismiss: () {
                    feedback.selectionClick();
                    ref.read(userPreferencesProvider.notifier).dismissTip('dashboard_reorder');
                  },
                ),

              const SizedBox(height: AppSpacing.xs),

              // 2. Ordered User-Customizable Sections
              for (int i = 0; i < orderedVisible.length; i++) ...[
                buildSectionWidget(orderedVisible[i]),
                if (i < orderedVisible.length - 1)
                  const SizedBox(height: AppSpacing.xxl),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _DashboardTaskRow extends StatelessWidget {
  final TaskWithSubtasks item;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const _DashboardTaskRow({
    required this.item,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = item.task;

    String meta = 'No due date';
    if (t.dueDate != null) {
      final rel = DateFormatters.relativeDate(t.dueDate!);
      meta = t.hasDueTime
          ? '$rel • ${DateFormatters.timeOnly(t.dueDate!)}'
          : rel;
    }

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: t.isCompleted ? 'Mark ${t.title} incomplete' : 'Complete ${t.title}',
            child: InkWell(
              onTap: onToggle,
              borderRadius: AppRadii.roundedFull,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 22.0,
                  height: 22.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.isCompleted ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: t.isCompleted
                          ? AppColors.success
                          : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
                      width: 2.0,
                    ),
                  ),
                  child: t.isCompleted
                      ? const Icon(AppIcons.completion, size: 14.0, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 15.0,
                    decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                    color: t.isCompleted
                        ? (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)
                        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  meta,
                  style: AppTypography.metadata.copyWith(
                    color: item.isOverdue
                        ? AppColors.error
                        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppPriorityBadge(priority: t.priority),
        ],
      ),
    );
  }
}
