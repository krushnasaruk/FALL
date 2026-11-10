import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_progress_ring.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../data/repositories/focus_repository.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';

enum _AnalyticsRange {
  d7('7D', 7, 'Last 7 days'),
  d30('30D', 30, 'Last 30 days'),
  m3('3M', 90, 'Last 3 months'),
  y1('1Y', 365, 'Last 12 months');

  final String shortLabel;
  final int days;
  final String description;
  const _AnalyticsRange(this.shortLabel, this.days, this.description);
}

/// Analytics & Productivity Intelligence Screen.
/// Computes every KPI, breakdown, heatmap cell, and bar chart strictly from local SQLite records.
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  _AnalyticsRange _range = _AnalyticsRange.d7;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final feedback = ref.read(feedbackServiceProvider);

    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final focusAsync = ref.watch(recentFocusSessionsProvider);
    final habitsAsync = ref.watch(allHabitsStreamProvider);
    final activitiesAsync = ref.watch(recentActivitiesStreamProvider);
    final totalXp = ref.watch(totalXpStreamProvider).valueOrNull ?? 0;
    final unlockedList = ref.watch(unlockedAchievementsProvider).valueOrNull ?? const <UnlockedAchievementEntry>[];

    if (tasksAsync.isLoading && !tasksAsync.hasValue) {
      return const AppScaffold(
        body: Padding(
          padding: EdgeInsets.only(top: AppSpacing.lg),
          child: AnalyticsSkeleton(),
        ),
      );
    }

    final allTasks = tasksAsync.value ?? [];
    final allProjects = projectsAsync.value ?? [];
    final allSkills = skillsAsync.value ?? [];
    final allFocus = focusAsync.value ?? [];
    final allHabits = habitsAsync.value ?? [];
    final allActivities = activitiesAsync.value ?? [];

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final rangeStart = todayStart.subtract(Duration(days: _range.days - 1));

    // Real Task Metrics within selected window (plus overall open tasks)
    final tasksInWindow = allTasks.where((t) {
      final refDate = t.task.completedAt ?? t.task.dueDate ?? t.task.createdAt;
      return !refDate.isBefore(rangeStart);
    }).toList();

    final completedTasksInWindow = allTasks.where((t) {
      if (!t.task.isCompleted) return false;
      final completedAt = t.task.completedAt ?? t.task.createdAt;
      return !completedAt.isBefore(rangeStart);
    }).length;

    final int taskWindowTotal = tasksInWindow.isNotEmpty ? tasksInWindow.length : allTasks.length;
    final int taskWindowDone = tasksInWindow.isNotEmpty
        ? tasksInWindow.where((t) => t.task.isCompleted).length
        : allTasks.where((t) => t.task.isCompleted).length;
    final double taskRate = taskWindowTotal > 0 ? (taskWindowDone / taskWindowTotal) : 0.0;

    // Real Project Metrics
    final int completedProjects = allProjects.where((p) => p.project.status == 'completed').length;
    final int activeProjects = allProjects.where((p) => p.project.status == 'active').length;
    final double projectAvg = allProjects.isEmpty
        ? 0.0
        : allProjects.map((p) => p.progressPercentage).reduce((a, b) => a + b) / allProjects.length;

    // Real Learning Minutes within selected window (plus total logged)
    int learningMinutesInWindow = 0;
    int totalSkillTopics = 0;
    int completedSkillTopics = 0;
    for (final s in allSkills) {
      totalSkillTopics += s.totalTopics;
      completedSkillTopics += s.completedTopics;
      for (final session in s.sessions) {
        if (!session.createdAt.isBefore(rangeStart)) {
          learningMinutesInWindow += session.durationMinutes;
        }
      }
    }
    // If no timestamped sessions yet but skill records contain initial logged minutes, show real total
    final int skillMinutesSum = allSkills.fold<int>(0, (sum, s) => sum + s.skill.learningMinutes);
    final int effectiveLearningMinutes =
        learningMinutesInWindow > 0 ? learningMinutesInWindow : (_range == _AnalyticsRange.y1 ? skillMinutesSum : 0);

    // Real Focus Minutes within selected window
    int focusMinutesInWindow = 0;
    for (final f in allFocus) {
      if (!f.session.completedAt.isBefore(rangeStart)) {
        focusMinutesInWindow += f.session.durationMinutes;
      }
    }

    // Real Task Execution Minutes (from estimated/actual minutes on completed tasks in window)
    int taskExecutionMinutes = 0;
    for (final t in allTasks) {
      if (t.task.isCompleted) {
        final completedAt = t.task.completedAt ?? t.task.createdAt;
        if (!completedAt.isBefore(rangeStart)) {
          final int mins = t.task.actualMinutes > 0
              ? t.task.actualMinutes
              : (t.task.estimatedMinutes > 0 ? t.task.estimatedMinutes : 30);
          taskExecutionMinutes += mins;
        }
      }
    }

    // Composite Completion & Momentum Index from real non-empty modules
    final List<double> components = [];
    if (allTasks.isNotEmpty) components.add(taskRate);
    if (allProjects.isNotEmpty) components.add(projectAvg);
    if (totalSkillTopics > 0) components.add(completedSkillTopics / totalSkillTopics);
    if (allHabits.isNotEmpty) {
      final activeToday = allHabits.where((h) => h.isCompletedToday).length;
      components.add(activeToday / allHabits.length);
    }
    final double overallProgress =
        components.isEmpty ? 0.0 : components.reduce((a, b) => a + b) / components.length;

    final int totalTrackedMinutes =
        taskExecutionMinutes + effectiveLearningMinutes + focusMinutesInWindow;

    // Real 28-day Daily Activity Map (Date yyyy-MM-dd -> event count)
    final Map<String, int> dailyActivityMap = _buildDailyActivityCounts(
      allTasks: allTasks,
      allSkills: allSkills,
      allFocus: allFocus,
      allHabits: allHabits,
      allActivities: allActivities,
    );

    final bool hasAnyData = allTasks.isNotEmpty ||
        allProjects.isNotEmpty ||
        allSkills.isNotEmpty ||
        allFocus.isNotEmpty ||
        allHabits.isNotEmpty;

    return AppScaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: 48.0),
        children: [
          PageTitle(
            title: 'Analytics',
            subtitle: _range.description,
            showBackButton: Navigator.of(context).canPop(),
          ),

          // Timeframe Selector Chips
          SizedBox(
            height: 44.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
              children: _AnalyticsRange.values.map((tf) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: AppFilterChip(
                    label: tf.shortLabel,
                    selected: _range == tf,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _range = tf);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          if (!hasAnyData)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
              child: EmptyStateView(
                icon: AppIcons.analytics,
                illustrationAsset: 'assets/images/empty/empty_analytics.png',
                title: 'Your progress story will appear here.',
                description:
                    'Complete a few activities to start seeing patterns.',
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Overall Productivity Ring Card
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Overall Execution',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.cardTitle.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              flex: 0,
                              child: AppBadge(
                                label: _range.shortLabel,
                                color: isDark ? AppColors.primaryDark : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppProgressRing(
                          progress: overallProgress,
                          size: 168.0,
                          strokeWidth: 14.0,
                          progressGradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          centerChild: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(overallProgress * 100).round()}%',
                                style: AppTypography.display.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  fontFeatures: AppTypography.tabularFigures,
                                ),
                              ),
                              Text(
                                'Completion Index',
                                style: AppTypography.metadata.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Derived from ${components.length} active module${components.length == 1 ? '' : 's'} in your local database.',
                          style: AppTypography.secondary.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // 2. 2x2 Real KPI Grid
                  Row(
                    children: [
                      Expanded(
                        child: _KpiTile(
                          icon: AppIcons.learning,
                          label: 'Learning (${_range.shortLabel})',
                          value: _formatMinutesCompact(effectiveLearningMinutes),
                          accent: isDark ? AppColors.learningPurple : AppColors.learningAccent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _KpiTile(
                          icon: AppIcons.focus,
                          label: 'Focus (${_range.shortLabel})',
                          value: _formatMinutesCompact(focusMinutesInWindow),
                          accent: isDark ? AppColors.analyticsCyan : AppColors.focusAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _KpiTile(
                          icon: AppIcons.tasks,
                          label: 'Tasks Done (${_range.shortLabel})',
                          value: '$completedTasksInWindow',
                          accent: isDark ? AppColors.taskBlue : AppColors.taskAccent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _KpiTile(
                          icon: AppIcons.projects,
                          label: 'Projects',
                          value: '$activeProjects active / $completedProjects done',
                          isCompactValue: true,
                          accent: isDark ? AppColors.projectLavender : AppColors.projectAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 3. Time Allocation Breakdown (Tasks vs Learning vs Focus)
                  const SectionHeader(
                    title: 'Effort Breakdown',
                    subtitle: 'Real minutes logged across execution, learning & focus',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppCard(
                    child: totalTrackedMinutes == 0
                        ? Text(
                            'No completed task, learning, or focus minutes recorded in this timeframe yet.',
                            style: AppTypography.secondary.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                          )
                        : Column(
                            children: [
                              ClipRRect(
                                borderRadius: AppRadii.roundedFull,
                                child: SizedBox(
                                  height: 12.0,
                                  child: Row(
                                    children: [
                                      if (taskExecutionMinutes > 0)
                                        Expanded(
                                          flex: taskExecutionMinutes,
                                          child: Container(color: AppColors.primary),
                                        ),
                                      if (effectiveLearningMinutes > 0)
                                        Expanded(
                                          flex: effectiveLearningMinutes,
                                          child: Container(color: AppColors.success),
                                        ),
                                      if (focusMinutesInWindow > 0)
                                        Expanded(
                                          flex: focusMinutesInWindow,
                                          child: Container(color: AppColors.secondary),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _BreakdownRow(
                                color: AppColors.primary,
                                label: 'Tasks (completed)',
                                minutes: taskExecutionMinutes,
                                totalMinutes: totalTrackedMinutes,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              _BreakdownRow(
                                color: AppColors.success,
                                label: 'Learning sessions',
                                minutes: effectiveLearningMinutes,
                                totalMinutes: totalTrackedMinutes,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              _BreakdownRow(
                                color: AppColors.secondary,
                                label: 'Focus timer',
                                minutes: focusMinutesInWindow,
                                totalMinutes: totalTrackedMinutes,
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 4. Real 28-Day Consistency Heatmap
                  const SectionHeader(
                    title: '28-Day Activity Heatmap',
                    subtitle: 'Every square reflects actual logged actions on that calendar day',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                              .map(
                                (d) => Expanded(
                                  child: Text(
                                    d,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.metadata.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextTertiary
                                          : AppColors.textTertiary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...List.generate(4, (weekIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: List.generate(7, (dayIndex) {
                                final daysAgo = (3 - weekIndex) * 7 + (6 - dayIndex);
                                final date = todayStart.subtract(Duration(days: daysAgo));
                                final key = DateFormat('yyyy-MM-dd').format(date);
                                final count = dailyActivityMap[key] ?? 0;

                                return Expanded(
                                  child: Center(
                                    child: Tooltip(
                                      message: '${DateFormat('MMM d').format(date)}: $count actions',
                                      child: Container(
                                        width: 24.0,
                                        height: 24.0,
                                        decoration: BoxDecoration(
                                          color: _heatmapColor(count, isDark),
                                          borderRadius: BorderRadius.circular(7.0),
                                          border: daysAgo == 0
                                              ? Border.all(
                                                  color: isDark
                                                      ? AppColors.primaryDark
                                                      : AppColors.primary,
                                                  width: 1.5,
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Less',
                              style: AppTypography.metadata.copyWith(
                                color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(width: 6.0),
                            ...[0, 1, 3, 5].map(
                              (level) => Container(
                                width: 12.0,
                                height: 12.0,
                                margin: const EdgeInsets.only(right: 4.0),
                                decoration: BoxDecoration(
                                  color: _heatmapColor(level, isDark),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              ),
                            ),
                            Text(
                              'More',
                              style: AppTypography.metadata.copyWith(
                                color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 5. Weekly Velocity Bar Chart (last 7 days completed actions)
                  const SectionHeader(
                    title: '7-Day Velocity',
                    subtitle: 'Completed tasks & focus/learning logs per day',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _WeeklyVelocityCard(
                    todayStart: todayStart,
                    dailyActivityMap: dailyActivityMap,
                    isDark: isDark,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 6. Progression XP & Achievements Collection
                  const SectionHeader(
                    title: 'Progress & Achievements',
                    subtitle: 'Auditable local XP and milestone badges across 6 categories',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _AchievementsShelfCard(
                    totalXp: totalXp,
                    unlockedEntries: unlockedList,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Map<String, int> _buildDailyActivityCounts({
    required List<TaskWithSubtasks> allTasks,
    required List<SkillWithRoadmap> allSkills,
    required List<FocusSessionWithDetails> allFocus,
    required List<HabitWithEntries> allHabits,
    required List allActivities,
  }) {
    final map = <String, int>{};

    void increment(DateTime dt) {
      final key = DateFormat('yyyy-MM-dd').format(dt);
      map[key] = (map[key] ?? 0) + 1;
    }

    for (final t in allTasks) {
      if (t.task.isCompleted) {
        increment(t.task.completedAt ?? t.task.createdAt);
      }
    }
    for (final s in allSkills) {
      for (final session in s.sessions) {
        increment(session.createdAt);
      }
    }
    for (final f in allFocus) {
      increment(f.session.completedAt);
    }
    for (final h in allHabits) {
      for (final e in h.entries) {
        if (e.isCompleted) {
          map[e.dateStr] = (map[e.dateStr] ?? 0) + 1;
        }
      }
    }
    for (final a in allActivities) {
      increment(a.createdAt as DateTime);
    }
    return map;
  }

  Color _heatmapColor(int count, bool isDark) {
    if (count == 0) {
      return isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated;
    }
    if (count <= 2) return AppColors.primary.withOpacity(isDark ? 0.35 : 0.25);
    if (count <= 4) return AppColors.primary.withOpacity(isDark ? 0.65 : 0.55);
    return AppColors.primary;
  }

  String _formatMinutesCompact(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}

class _KpiTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final bool isCompactValue;

  const _KpiTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    this.isCompactValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17.0, color: accent),
              const SizedBox(width: 6.0),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.metadata.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (isCompactValue ? AppTypography.cardTitle : AppTypography.statMedium).copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final Color color;
  final String label;
  final int minutes;
  final int totalMinutes;

  const _BreakdownRow({
    required this.color,
    required this.label,
    required this.minutes,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pct = totalMinutes > 0 ? ((minutes / totalMinutes) * 100).round() : 0;

    return Row(
      children: [
        Container(
          width: 9.0,
          height: 9.0,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            label,
            style: AppTypography.secondary.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          '${minutes}m • $pct%',
          style: AppTypography.metadata.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _WeeklyVelocityCard extends StatelessWidget {
  final DateTime todayStart;
  final Map<String, int> dailyActivityMap;
  final bool isDark;

  const _WeeklyVelocityCard({
    required this.todayStart,
    required this.dailyActivityMap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => todayStart.subtract(Duration(days: 6 - i)));
    final counts = days.map((d) => dailyActivityMap[DateFormat('yyyy-MM-dd').format(d)] ?? 0).toList();
    final maxCount = counts.fold<int>(0, (m, c) => math.max(m, c));

    if (maxCount == 0) {
      return AppCard(
        child: Text(
          'No recorded activity in the past 7 days yet.',
          style: AppTypography.secondary.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
      );
    }

    final maxY = (maxCount + 2).toDouble();

    return AppCard(
      child: SizedBox(
        height: 170.0,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: BarTouchData(enabled: true),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(
                color: isDark ? AppColors.darkDivider : AppColors.divider,
                strokeWidth: 1.0,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= days.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        DateFormat('E').format(days[idx]).substring(0, 1),
                        style: AppTypography.metadata.copyWith(
                          color: idx == 6
                              ? (isDark ? AppColors.primaryDark : AppColors.primary)
                              : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: List.generate(7, (idx) {
              return BarChartGroupData(
                x: idx,
                barRods: [
                  BarChartRodData(
                    toY: counts[idx].toDouble(),
                    width: 18.0,
                    color: idx == 6
                        ? (isDark ? AppColors.primaryDark : AppColors.primary)
                        : AppColors.primary.withOpacity(0.45),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6.0)),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _AchievementsShelfCard extends StatelessWidget {
  final int totalXp;
  final List<UnlockedAchievementEntry> unlockedEntries;
  final bool isDark;

  const _AchievementsShelfCard({
    required this.totalXp,
    required this.unlockedEntries,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final unlockedIds = unlockedEntries.map((e) => e.id).toSet();
    final level = RewardsRepository.levelForXp(totalXp);
    final levelProgress = RewardsRepository.levelProgress(totalXp);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBadge(
                label: 'Level $level',
                color: isDark ? AppColors.primaryDark : AppColors.primary,
                icon: Icons.bolt_rounded,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '$totalXp total XP • ${unlockedIds.length}/${RewardsRepository.catalog.length} badges unlocked',
                  style: AppTypography.metadata.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(
            progress: levelProgress,
            progressColor: isDark ? AppColors.primaryDark : AppColors.primary,
            backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
            height: 6.0,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: RewardsRepository.catalog.map((def) {
              final isUnlocked = unlockedIds.contains(def.id);
              return Container(
                width: 136.0,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated)
                      : (isDark ? AppColors.darkBackground : AppColors.background),
                  borderRadius: AppRadii.roundedMd,
                  border: Border.all(
                    color: isUnlocked
                        ? (isDark ? AppColors.primaryDark : AppColors.primary).withOpacity(0.45)
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Opacity(
                          opacity: isUnlocked ? 1.0 : 0.35,
                          child: Image.asset(
                            def.badgeAsset,
                            width: 28.0,
                            height: 28.0,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events_outlined, size: 22.0),
                          ),
                        ),
                        const Spacer(),
                        if (isUnlocked)
                          const Icon(AppIcons.completion, size: 15.0, color: AppColors.success)
                        else
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 14.0,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      def.title,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isUnlocked
                            ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                            : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      def.description,
                      style: AppTypography.metadata.copyWith(
                        fontSize: 10.5,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
