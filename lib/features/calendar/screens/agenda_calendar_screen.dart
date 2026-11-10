import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/focus_repository.dart';
import '../../../data/repositories/habit_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/widget_sync_service.dart';
import '../../projects/screens/project_detail_screen.dart';
import '../../tasks/widgets/task_card.dart';
import '../../tasks/widgets/task_detail_sheet.dart';
import '../../tasks/widgets/task_form_sheet.dart';

/// Screen 8 — Calendar with Month & Week views displaying real Tasks, Deadlines,
/// Project Milestones, Habit check-ins, and Focus sessions.
class AgendaCalendarScreen extends ConsumerStatefulWidget {
  const AgendaCalendarScreen({super.key});

  @override
  ConsumerState<AgendaCalendarScreen> createState() => _AgendaCalendarScreenState();
}

class _AgendaCalendarScreenState extends ConsumerState<AgendaCalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _displayMonth;
  bool _isMonthExpanded = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _displayMonth = DateTime(now.year, now.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 1);
    });
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final habitsAsync = ref.watch(allHabitsStreamProvider);
    final focusAsync = ref.watch(recentFocusSessionsProvider);

    final taskRepo = ref.watch(taskRepositoryProvider);
    final feedback = ref.read(feedbackServiceProvider);
    final widgetSync = ref.read(widgetSyncServiceProvider);

    final monthTitle = DateFormat('MMM yyyy').format(_displayMonth);
    final startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final weekDays = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    final allTasks = tasksAsync.valueOrNull ?? const [];
    final allProjects = projectsAsync.valueOrNull ?? const [];
    final allHabits = habitsAsync.valueOrNull ?? const [];
    final allFocus = focusAsync.valueOrNull ?? const [];

    bool hasEventsOn(DateTime day) {
      final hasTask = allTasks.any(
        (t) => t.task.dueDate != null && _sameDay(t.task.dueDate!, day),
      );
      final hasProj = allProjects.any(
        (p) => p.project.targetDate != null && _sameDay(p.project.targetDate!, day),
      );
      final dayIso = DateFormat('yyyy-MM-dd').format(day);
      final hasHabit = allHabits.any(
        (h) => h.entries.any((e) => e.dateStr == dayIso && e.isCompleted),
      );
      final hasFocus = allFocus.any((f) => _sameDay(f.session.completedAt, day));
      return hasTask || hasProj || hasHabit || hasFocus;
    }

    return AppScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          feedback.buttonTap();
          TaskFormSheet.show(context);
        },
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        tooltip: 'Add Scheduled Task',
        child: const Icon(AppIcons.add, size: 26.0),
      ),
      body: Column(
        children: [
          // Header: Zero overflow with FittedBox/Expanded
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.md,
              AppSpacing.pageHorizontal,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                AppIconButton(
                  icon: AppIcons.back,
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded),
                        visualDensity: VisualDensity.compact,
                        onPressed: _previousMonth,
                      ),
                      Flexible(
                        child: Text(
                          monthTitle,
                          style: AppTypography.titleLarge.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        visualDensity: VisualDensity.compact,
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                ),
                AppFilterChip(
                  label: _isMonthExpanded ? 'Week' : 'Month',
                  selected: _isMonthExpanded,
                  onSelected: () {
                    feedback.selectionClick();
                    setState(() => _isMonthExpanded = !_isMonthExpanded);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
                AppSpacing.pageHorizontal,
                96.0,
              ),
              children: [
                // Calendar Grid or Week Strip
                AppCard(
                  padding: const EdgeInsets.all(12.0),
                  child: _isMonthExpanded
                      ? _buildMonthGrid(hasEventsOn, isDark, feedback)
                      : _buildWeekStrip(weekDays, hasEventsOn, isDark, feedback),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Day Agenda Header
                Text(
                  DateFormatters.dayOfWeekMonthDay(_selectedDate),
                  style: AppTypography.sectionTitle.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Real Day Events: Tasks, Project Deadlines, Habits Completed, Focus Sessions
                ..._buildDayAgenda(
                  isDark: isDark,
                  tasks: allTasks,
                  projects: allProjects,
                  habits: allHabits,
                  focusSessions: allFocus,
                  taskRepo: taskRepo,
                  widgetSync: widgetSync,
                  feedback: feedback,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStrip(
    List<DateTime> weekDays,
    bool Function(DateTime) hasEventsOn,
    bool isDark,
    FeedbackService feedback,
  ) {
    final primaryCol = isDark ? AppColors.primaryDark : AppColors.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((d) {
        final isSelected = _sameDay(d, _selectedDate);
        final hasMarker = hasEventsOn(d);
        return Expanded(
          child: Semantics(
            button: true,
            selected: isSelected,
            label: DateFormatters.monthDay(d),
            child: InkWell(
              onTap: () {
                feedback.selectionClick();
                setState(() {
                  _selectedDate = d;
                  _displayMonth = DateTime(d.year, d.month, 1);
                });
              },
              borderRadius: AppRadii.roundedMd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: isSelected ? primaryCol : Colors.transparent,
                  borderRadius: AppRadii.roundedMd,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('E').format(d).substring(0, 2),
                      style: AppTypography.metadata.copyWith(
                        fontSize: 10.5,
                        color: isSelected
                            ? Colors.white.withOpacity(0.85)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      d.day.toString(),
                      style: AppTypography.cardTitle.copyWith(
                        fontSize: 15.0,
                        fontFeatures: AppTypography.tabularFigures,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      width: 5.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasMarker
                            ? (isSelected ? Colors.white : primaryCol)
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthGrid(
    bool Function(DateTime) hasEventsOn,
    bool isDark,
    FeedbackService feedback,
  ) {
    final daysInMonth = DateUtils.getDaysInMonth(_displayMonth.year, _displayMonth.month);
    final firstWeekday = _displayMonth.weekday; // 1 = Mon .. 7 = Sun
    final leadingBlanks = firstWeekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final primaryCol = isDark ? AppColors.primaryDark : AppColors.primary;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: AppTypography.metadata.copyWith(color: AppColors.textTertiary),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCells,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, idx) {
            if (idx < leadingBlanks) return const SizedBox.shrink();
            final dayNum = idx - leadingBlanks + 1;
            final date = DateTime(_displayMonth.year, _displayMonth.month, dayNum);
            final isSelected = _sameDay(date, _selectedDate);
            final hasMarker = hasEventsOn(date);

            return InkWell(
              onTap: () {
                feedback.selectionClick();
                setState(() => _selectedDate = date);
              },
              borderRadius: AppRadii.roundedSm,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? primaryCol : Colors.transparent,
                  borderRadius: AppRadii.roundedSm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayNum',
                      style: AppTypography.secondary.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontFeatures: AppTypography.tabularFigures,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      ),
                    ),
                    if (hasMarker)
                      Container(
                        width: 4.0,
                        height: 4.0,
                        margin: const EdgeInsets.only(top: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.white : primaryCol,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildDayAgenda({
    required bool isDark,
    required List<TaskWithSubtasks> tasks,
    required List<ProjectWithDetails> projects,
    required List<HabitWithEntries> habits,
    required List<FocusSessionWithDetails> focusSessions,
    required TaskRepository taskRepo,
    required WidgetSyncService widgetSync,
    required FeedbackService feedback,
  }) {
    final dayTasks = tasks
        .where((t) => t.task.dueDate != null && _sameDay(t.task.dueDate!, _selectedDate))
        .toList();

    final dayProjects = projects
        .where((p) =>
            p.project.targetDate != null && _sameDay(p.project.targetDate!, _selectedDate))
        .toList();

    final dayIso = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final completedHabits = habits
        .where((h) => h.entries.any((e) => e.dateStr == dayIso && e.isCompleted))
        .toList();

    final dayFocus = focusSessions
        .where((f) => _sameDay(f.session.completedAt, _selectedDate))
        .toList();

    if (dayTasks.isEmpty &&
        dayProjects.isEmpty &&
        completedHabits.isEmpty &&
        dayFocus.isEmpty) {
      return [
        const EmptyStateView(
          icon: AppIcons.calendar,
          title: 'No events scheduled',
          description: 'Nothing due or logged on this date. Tap + to schedule a task.',
        ),
      ];
    }

    final items = <Widget>[];

    if (dayProjects.isNotEmpty) {
      items.add(
        const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text('Project Deadlines', style: AppTypography.titleSmall),
        ),
      );
      for (final p in dayProjects) {
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProjectDetailScreen(projectId: p.project.id),
                ),
              ),
              child: Row(
                children: [
                  const Icon(AppIcons.projectsActive, color: AppColors.projectAccent),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(p.project.name, style: AppTypography.cardTitle),
                  ),
                  AppStatusBadge(status: p.project.status),
                ],
              ),
            ),
          ),
        );
      }
      items.add(const SizedBox(height: AppSpacing.md));
    }

    if (dayTasks.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text('Scheduled Tasks (${dayTasks.length})', style: AppTypography.titleSmall),
        ),
      );
      for (final item in dayTasks) {
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: TaskCard(
              taskWithSubtasks: item,
              onToggleComplete: (val) async {
                await feedback.taskCompleted(completed: val);
                await taskRepo.toggleTaskCompletion(item.task.id, val);
                await widgetSync.syncAllWidgets();
              },
              onTap: () => TaskDetailSheet.show(context, item),
            ),
          ),
        );
      }
      items.add(const SizedBox(height: AppSpacing.md));
    }

    if (dayFocus.isNotEmpty) {
      final totalMins = dayFocus.fold<int>(0, (sum, f) => sum + f.session.durationMinutes);
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: AppCard(
            child: Row(
              children: [
                const Icon(AppIcons.focusActive, color: AppColors.focusAccent),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Focus Sessions (${dayFocus.length})',
                    style: AppTypography.titleSmall,
                  ),
                ),
                Text(
                  DateFormatters.formatMinutes(totalMins),
                  style: AppTypography.statMedium.copyWith(
                    fontSize: 16.0,
                    color: AppColors.focusAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (completedHabits.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Habits Completed', style: AppTypography.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: completedHabits
                      .map(
                        (h) => AppBadge(
                          label: h.habit.title,
                          color: AppColors.habitAccent,
                          icon: AppIcons.completion,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return items;
  }
}
