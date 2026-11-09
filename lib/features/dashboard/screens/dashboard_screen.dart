import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_stat_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/widget_sync_service.dart';
import '../../learning/widgets/log_session_dialog.dart';
import '../../projects/screens/project_detail_screen.dart';
import '../../tasks/widgets/task_detail_sheet.dart';
import '../../tasks/widgets/task_form_sheet.dart';
import '../../tasks/widgets/task_tile.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final habitsAsync = ref.watch(allHabitsStreamProvider);

    final taskRepo = ref.watch(taskRepositoryProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);

    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: const Icon(Icons.terminal_rounded, size: 16.0, color: Color(0xFF0F172A)),
            ),
            const SizedBox(width: 8.0),
            Text(
              'ProgressOS',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            tooltip: 'Focus Timer',
            onPressed: () => context.push('/focus'),
          ),
          IconButton(
            icon: const Icon(Icons.bolt_rounded),
            tooltip: 'Habits & Goals',
            onPressed: () => context.push('/habits'),
          ),
          IconButton(
            icon: const Icon(Icons.folder_copy_outlined),
            tooltip: 'Knowledge Vault',
            onPressed: () => context.push('/vault'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (allTasks) {
          // Calculations
          final todayTasks = allTasks.where((t) {
            if (t.task.dueDate == null) return false;
            return t.task.dueDate!.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
                t.task.dueDate!.isBefore(todayEnd);
          }).toList();

          final completedToday = todayTasks.where((t) => t.task.isCompleted).length;
          final remainingToday = todayTasks.length - completedToday;
          final overdueTasks = allTasks.where((t) => t.isOverdue).toList();
          final dailyCompletionRate = todayTasks.isNotEmpty ? (completedToday / todayTasks.length) : 0.0;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
            children: [
              // Greeting & Today's Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormatters.getGreeting(),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        DateFormatters.dayOfWeekMonthDay(now),
                        style: AppTypography.displayMedium.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, size: 16.0, color: AppColors.success),
                        const SizedBox(width: 6.0),
                        Text(
                          '$completedToday / ${todayTasks.length} Done',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Daily Progress Command Bar
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Completion Rate',
                          style: AppTypography.titleSmall.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          '${(dailyCompletionRate * 100).toInt()}%',
                          style: AppTypography.monoMedium.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppProgressBar(
                      progress: dailyCompletionRate,
                      height: 10.0,
                      progressColor: dailyCompletionRate >= 1.0 ? AppColors.success : AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$remainingToday remaining for today',
                          style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                        ),
                        if (overdueTasks.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: AppColors.errorSoft,
                              borderRadius: AppRadii.roundedXs,
                            ),
                            child: Text(
                              '${overdueTasks.length} Overdue',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Quick Action Bar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => TaskFormSheet.show(context),
                      icon: const Icon(Icons.add_task_rounded, size: 16),
                      label: const Text('Add Task', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/focus'),
                      icon: const Icon(Icons.timer_outlined, size: 16),
                      label: const Text('Start Focus', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/vault'),
                      icon: const Icon(Icons.note_add_outlined, size: 16),
                      label: const Text('Add Note', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Productivity Statistics Grid
              habitsAsync.when(
                data: (habits) {
                  int maxStreak = 0;
                  for (final h in habits) {
                    if (h.currentStreak > maxStreak) maxStreak = h.currentStreak;
                  }

                  return projectsAsync.when(
                    data: (projects) {
                      final activeProjects = projects.where((p) => p.project.status == 'active').length;

                      return Row(
                        children: [
                          Expanded(
                            child: AppStatCard(
                              title: 'Learning Streak',
                              value: '$maxStreak days',
                              subtitle: 'Active consistency',
                              icon: Icons.local_fire_department_rounded,
                              accentColor: AppColors.warning,
                              onTap: () => context.push('/habits'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppStatCard(
                              title: 'Active Projects',
                              value: activeProjects.toString(),
                              subtitle: '${projects.length} repositories',
                              icon: Icons.rocket_launch_rounded,
                              accentColor: AppColors.info,
                              onTap: () => context.go('/projects'),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Today's Tasks Card Section
              SectionHeader(
                title: "Today's Priorities",
                subtitle: 'Target deliverables for today',
                actionLabel: 'View All',
                onAction: () => context.go('/tasks'),
              ),
              if (todayTasks.isEmpty) ...[
                AppCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.done_all_rounded, size: 28, color: AppColors.success),
                          const SizedBox(height: 8),
                          Text('No tasks due today', style: AppTypography.titleSmall),
                          const SizedBox(height: 4),
                          Text(
                            'Add a task scheduled for today to start executing.',
                            style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            label: 'Add Today\'s Task',
                            size: AppButtonSize.small,
                            onPressed: () => TaskFormSheet.show(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                ...todayTasks.take(4).map((item) => TaskTile(
                      taskWithSubtasks: item,
                      onToggleComplete: (val) async {
                        await taskRepo.toggleTaskCompletion(item.task.id, val);
                        await widgetSync.syncAllWidgets();
                      },
                      onTap: () => TaskDetailSheet.show(context, item),
                      onDelete: () async {
                        await taskRepo.deleteTask(item.task.id);
                        await widgetSync.syncAllWidgets();
                      },
                    )),
              ],
              const SizedBox(height: AppSpacing.xl),

              // Active Projects Snapshot
              SectionHeader(
                title: 'Active Engineering Builds',
                actionLabel: 'Projects',
                onAction: () => context.go('/projects'),
              ),
              projectsAsync.when(
                data: (projects) {
                  final active = projects.where((p) => p.project.status == 'active').take(2).toList();
                  if (active.isEmpty) {
                    return Text(
                      'No active projects right now. Jump into Projects to start building!',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                    );
                  }

                  return Column(
                    children: active.map((p) => Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: AppRadii.roundedMd,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: 1.0,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProjectDetailScreen(projectId: p.project.id),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(p.project.name, style: AppTypography.titleSmall),
                                    Text(
                                      '${(p.progressPercentage * 100).toInt()}%',
                                      style: AppTypography.monoSmall.copyWith(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                AppProgressBar(progress: p.progressPercentage),
                              ],
                            ),
                          ),
                        )).toList(),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Learning Progress Card
              SectionHeader(
                title: 'Technical Mastery Roadmap',
                actionLabel: 'Explore Roadmaps',
                onAction: () => context.go('/learning'),
              ),
              skillsAsync.when(
                data: (skills) {
                  if (skills.isEmpty) {
                    return Text(
                      'No skills tracked yet. Define roadmaps for Flutter, Python, ML, or Systems.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                    );
                  }

                  return Column(
                    children: skills.take(3).map((s) => Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: AppRadii.roundedMd,
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: AppRadii.roundedSm,
                                ),
                                child: const Icon(Icons.school_rounded, size: 16.0, color: AppColors.primary),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.skill.name, style: AppTypography.titleSmall),
                                    Text(
                                      '${s.completedTopics}/${s.totalTopics} topics • ${DateFormatters.formatMinutes(s.skill.learningMinutes)} logged',
                                      style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.history_toggle_off_rounded, color: AppColors.primary, size: 20),
                                tooltip: 'Log Time',
                                onPressed: () {
                                  LogSessionDialog.show(
                                    context,
                                    skillId: s.skill.id,
                                    skillName: s.skill.name,
                                  );
                                },
                              ),
                            ],
                          ),
                        )).toList(),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateView(
          message: err.toString(),
          onRetry: () => ref.refresh(allTasksStreamProvider),
        ),
      ),
    );
  }
}
