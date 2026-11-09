import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_stat_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final activitiesAsync = ref.watch(recentActivitiesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Growth'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
        children: [
          // Top KPI Metric Row
          tasksAsync.when(
            data: (tasks) {
              final completed = tasks.where((t) => t.task.isCompleted).length;
              final total = tasks.length;
              final rate = total > 0 ? ((completed / total) * 100).toInt() : 0;

              return Row(
                children: [
                  Expanded(
                    child: AppStatCard(
                      title: 'Task Velocity',
                      value: '$completed / $total',
                      subtitle: '$rate% completion rate',
                      icon: Icons.check_circle_rounded,
                      accentColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  skillsAsync.when(
                    data: (skills) {
                      int totalLearningMins = 0;
                      for (final s in skills) {
                        totalLearningMins += s.skill.learningMinutes;
                      }
                      return Expanded(
                        child: AppStatCard(
                          title: 'Skill Investment',
                          value: DateFormatters.formatMinutes(totalLearningMins),
                          subtitle: '${skills.length} technical domains',
                          icon: Icons.school_rounded,
                          accentColor: AppColors.primary,
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => ErrorStateView(message: err.toString()),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Weekly Completion Throughput Bar Chart
          SectionHeader(
            title: 'Weekly Task Velocity',
            subtitle: 'Tasks completed over the last 7 days',
          ),
          tasksAsync.when(
            data: (tasks) {
              final now = DateTime.now();
              final dayCounts = List.generate(7, (i) {
                final targetDay = now.subtract(Duration(days: 6 - i));
                final count = tasks.where((t) {
                  if (!t.task.isCompleted || t.task.completedAt == null) return false;
                  final c = t.task.completedAt!;
                  return c.year == targetDay.year &&
                      c.month == targetDay.month &&
                      c.day == targetDay.day;
                }).length;
                return count.toDouble();
              });

              final maxVal = dayCounts.reduce((a, b) => a > b ? a : b);
              final maxY = (maxVal < 5 ? 5.0 : maxVal + 2);

              return AppCard(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 180.0,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => isDark ? AppColors.darkSurfaceElevated : Colors.white,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toInt()} tasks',
                              AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            interval: 2,
                            getTitlesWidget: (val, meta) => Text(
                              val.toInt().toString(),
                              style: AppTypography.caption.copyWith(
                                fontSize: 9.0,
                                color: AppColors.darkTextMuted,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              final idx = val.toInt();
                              if (idx >= 0 && idx < 7) {
                                final d = now.subtract(Duration(days: 6 - idx));
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    DateFormat('E').format(d).substring(0, 3),
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 10.0,
                                      color: AppColors.darkTextMuted,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (val) => FlLine(
                          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                          strokeWidth: 1.0,
                        ),
                      ),
                      barGroups: List.generate(7, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: dayCounts[i],
                              color: dayCounts[i] > 0 ? AppColors.primary : AppColors.darkBorder,
                              width: 16.0,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Technology Time Distribution (Pie Chart)
          SectionHeader(
            title: 'Learning Allocation by Skill',
            subtitle: 'Hours spent across programming languages and frameworks',
          ),
          skillsAsync.when(
            data: (skills) {
              final activeSkills = skills.where((s) => s.skill.learningMinutes > 0).toList();
              if (activeSkills.isEmpty) {
                return AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Log learning sessions to view time breakdown.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                      ),
                    ),
                  ),
                );
              }

              final colors = [
                AppColors.techLanguage,
                AppColors.techFramework,
                AppColors.techAI,
                AppColors.techSystems,
                AppColors.techDatabase,
                AppColors.techCloud,
              ];

              return AppCard(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140.0,
                      height: 140.0,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2.0,
                          centerSpaceRadius: 32.0,
                          sections: activeSkills.asMap().entries.map((e) {
                            final idx = e.key;
                            final s = e.value;
                            return PieChartSectionData(
                              value: s.skill.learningMinutes.toDouble(),
                              color: colors[idx % colors.length],
                              radius: 36.0,
                              showTitle: false,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: activeSkills.take(5).toList().asMap().entries.map((e) {
                          final idx = e.key;
                          final s = e.value;
                          final color = colors[idx % colors.length];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Row(
                              children: [
                                Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    s.skill.name,
                                    style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  DateFormatters.formatMinutes(s.skill.learningMinutes),
                                  style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Project Progress Status
          SectionHeader(
            title: 'Project Engineering Status',
            subtitle: 'Milestone progress across active builds',
          ),
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return AppCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No projects yet to calculate engineering progress.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: projects.take(4).map((p) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
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
                        LinearProgressIndicator(
                          value: p.progressPercentage,
                          backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 6.0,
                          borderRadius: AppRadii.roundedFull,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Growth & Achievement Timeline
          SectionHeader(
            title: 'Engineering Activity Timeline',
            subtitle: 'Chronological record of your accomplishments and progress',
          ),
          activitiesAsync.when(
            data: (activities) {
              if (activities.isEmpty) {
                return Text(
                  'Your technical timeline will log completed tasks, projects, milestones, and learning hours here.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                );
              }

              return Column(
                children: activities.take(15).map((a) {
                  IconData icon;
                  Color iconColor;

                  switch (a.entityType) {
                    case 'task':
                      icon = Icons.check_circle_outline_rounded;
                      iconColor = AppColors.success;
                      break;
                    case 'project':
                      icon = Icons.rocket_launch_rounded;
                      iconColor = AppColors.info;
                      break;
                    case 'skill':
                      icon = Icons.school_rounded;
                      iconColor = AppColors.primary;
                      break;
                    case 'focus':
                      icon = Icons.timer_outlined;
                      iconColor = AppColors.warning;
                      break;
                    case 'milestone':
                      icon = Icons.flag_rounded;
                      iconColor = AppColors.statusPlanning;
                      break;
                    default:
                      icon = Icons.radio_button_checked;
                      iconColor = AppColors.darkTextMuted;
                  }

                  return Container(
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
                            color: iconColor.withOpacity(0.12),
                            borderRadius: AppRadii.roundedSm,
                          ),
                          child: Icon(icon, size: 16.0, color: iconColor),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.summary,
                                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                DateFormatters.dateTimeShort(a.createdAt),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.darkTextMuted,
                                  fontSize: 10.0,
                                ),
                              ),
                            ],
                          ),
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
