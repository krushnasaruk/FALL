import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_stat_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/widget_sync_service.dart';
import '../../learning/widgets/skill_card.dart';
import '../../projects/screens/project_detail_screen.dart';
import '../../projects/widgets/project_card.dart';
import '../../projects/widgets/project_form_sheet.dart';
import '../../tasks/widgets/task_card.dart';
import '../../tasks/widgets/task_detail_sheet.dart';
import '../../tasks/widgets/task_form_sheet.dart';

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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: tasksAsync.when(
          data: (allTasks) {
            // Task metrics
            final todayTasks = allTasks.where((t) {
              if (t.task.dueDate == null) return false;
              return t.task.dueDate!.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
                  t.task.dueDate!.isBefore(todayEnd);
            }).toList();

            final completedToday = todayTasks.where((t) => t.task.isCompleted).length;
            final dailyCompletionRate = todayTasks.isNotEmpty ? (completedToday / todayTasks.length) : 0.0;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 100.0),
              children: [
                // 1. Top Header: User Profile + Action Buttons (Matching Screen 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User Avatar + "Hello, Robertson"
                    Row(
                      children: [
                        Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF6ED4F8),
                            border: Border.all(color: Colors.white, width: 2.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 24.0,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: AppTypography.cardSub.copyWith(
                                color: const Color(0xFF64748B),
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              'Robertson',
                              style: AppTypography.titleLarge.copyWith(
                                color: isDark ? Colors.white : const Color(0xFF19213D),
                                fontWeight: FontWeight.w800,
                                fontSize: 18.0,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Top-right Icon Buttons: Notification & Calendar & Settings
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HeaderSquareButton(
                          icon: Icons.notifications_none_rounded,
                          tooltip: 'Notifications',
                          hasBadge: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All local notifications scheduled and running.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 10.0),
                        _HeaderSquareButton(
                          icon: Icons.calendar_month_outlined,
                          tooltip: 'Agenda & Habits',
                          onTap: () => context.push('/habits'),
                        ),
                        const SizedBox(width: 10.0),
                        _HeaderSquareButton(
                          icon: Icons.settings_outlined,
                          tooltip: 'Settings',
                          onTap: () => context.push('/settings'),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),

                // 2. Search Projects Pill (Matching Screen 1)
                GestureDetector(
                  onTap: () => context.go('/projects'),
                  child: Container(
                    height: 48.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                          blurRadius: 10.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          size: 20.0,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          'Search Projects...',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24.0),

                // 3. "Your Project" Section (Hero Banner Horizontal Carousel)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Project',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: isDark ? Colors.white : const Color(0xFF19213D),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/projects'),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                projectsAsync.when(
                  data: (projects) {
                    if (projects.isEmpty) {
                      return GestureDetector(
                        onTap: () => ProjectFormSheet.show(context),
                        child: Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            gradient: AppColors.projectHeroGradient,
                            borderRadius: BorderRadius.circular(AppRadii.cardLg),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Start Your First Project',
                                    style: AppTypography.cardHeader.copyWith(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Track tech experiments, apps, robotics, or design work.',
                                style: TextStyle(color: Colors.white70, fontSize: 13.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Horizontal carousel featuring the Hero pink card
                    return SizedBox(
                      height: 195.0,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: projects.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14.0),
                        itemBuilder: (context, index) {
                          final p = projects[index];
                          final isFirst = index == 0;

                          return SizedBox(
                            width: 310.0,
                            child: ProjectCard(
                              projectWithDetails: p,
                              variant: isFirst
                                  ? ProjectCardVariant.heroBanner
                                  : ProjectCardVariant.standard,
                              colorIndex: index,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProjectDetailScreen(projectId: p.project.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 195.0,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 28.0),

                // 4. "On Going Projects" 2-Column Grid Section (Folder Cards)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'On Going Projects',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: isDark ? Colors.white : const Color(0xFF19213D),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/projects'),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14.0),

                projectsAsync.when(
                  data: (projects) {
                    final displayProjects = projects.take(4).toList();
                    if (displayProjects.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.0,
                        mainAxisSpacing: 14.0,
                        childAspectRatio: 1.15,
                      ),
                      itemCount: displayProjects.length,
                      itemBuilder: (context, index) {
                        final p = displayProjects[index];
                        return ProjectCard(
                          projectWithDetails: p,
                          variant: ProjectCardVariant.folderGrid,
                          colorIndex: (index + 2) % 6, // Mint, Sky Blue, Purple, Yellow
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProjectDetailScreen(projectId: p.project.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 28.0),

                // 5. Productivity Stats Cards
                habitsAsync.when(
                  data: (habits) {
                    int maxStreak = 0;
                    for (final h in habits) {
                      if (h.currentStreak > maxStreak) maxStreak = h.currentStreak;
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: AppStatCard(
                            title: 'Active Streak',
                            value: '$maxStreak d',
                            subtitle: 'Consistency is key',
                            icon: Icons.local_fire_department_rounded,
                            accentColor: const Color(0xFFEA580C),
                            gradient: AppColors.habitPastelGradient,
                            onTap: () => context.push('/habits'),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: AppStatCard(
                            title: 'Today Done',
                            value: '${(dailyCompletionRate * 100).toInt()}%',
                            subtitle: '$completedToday of ${todayTasks.length} tasks',
                            icon: Icons.task_alt_rounded,
                            accentColor: const Color(0xFF0284C7),
                            gradient: AppColors.taskPastelGradient,
                            onTap: () => context.go('/tasks'),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 28.0),

                // 6. Today's Tasks Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Priorities",
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: isDark ? Colors.white : const Color(0xFF19213D),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/tasks'),
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                if (todayTasks.isEmpty) ...[
                  GestureDetector(
                    onTap: () => TaskFormSheet.show(context),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE0F2FE),
                            ),
                            child: const Icon(Icons.add_task_rounded, color: Color(0xFF0284C7), size: 18),
                          ),
                          const SizedBox(width: 14.0),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'All caught up for today!',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0),
                                ),
                                SizedBox(height: 2.0),
                                Text(
                                  'Tap here to add a new task scheduled for today.',
                                  style: TextStyle(fontSize: 12.0, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  ...todayTasks.take(3).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TaskCard(
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
                        ),
                      )),
                ],

                const SizedBox(height: 28.0),

                // 7. Learning Roadmaps Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Learning & Skills',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: isDark ? Colors.white : const Color(0xFF19213D),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/learning'),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                skillsAsync.when(
                  data: (skills) {
                    final displaySkills = skills.take(2).toList();
                    if (displaySkills.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: displaySkills.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: LearningCard(
                          skillWithRoadmap: s,
                          onTap: () => context.go('/learning'),
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
      ),
    );
  }
}

class _HeaderSquareButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool hasBadge;

  const _HeaderSquareButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 6.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 20.0,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B),
              ),
              if (hasBadge)
                Positioned(
                  top: 9.0,
                  right: 9.0,
                  child: Container(
                    width: 7.0,
                    height: 7.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
