import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/reward_celebration_sheet.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/widget_sync_service.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_tile.dart';

enum TaskFilterView {
  today,
  upcoming,
  all,
  completed,
  overdue,
}

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskFilterView _activeView = TaskFilterView.today;
  String _searchQuery = '';
  String? _selectedPriority;
  String? _selectedProjectId;
  String _sortBy = 'dueDate';
  bool _isSearchExpanded = false;
  bool _isBoardView = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TaskWithSubtasks> _filterAndSortTasks(List<TaskWithSubtasks> tasks) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    var filtered = tasks.where((item) {
      final t = item.task;
      switch (_activeView) {
        case TaskFilterView.today:
          if (t.isCompleted) return false;
          if (t.dueDate == null) return false;
          return !t.dueDate!.isBefore(todayStart) && t.dueDate!.isBefore(todayEnd);
        case TaskFilterView.upcoming:
          if (t.isCompleted) return false;
          if (t.dueDate == null) return true;
          return !t.dueDate!.isBefore(todayEnd);
        case TaskFilterView.overdue:
          return item.isOverdue;
        case TaskFilterView.completed:
          return t.isCompleted;
        case TaskFilterView.all:
          return !t.isCompleted;
      }
    }).toList();

    if (_selectedPriority != null) {
      filtered = filtered.where((t) => t.task.priority == _selectedPriority).toList();
    }

    if (_selectedProjectId != null) {
      filtered = filtered.where((t) => t.task.projectId == _selectedProjectId).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        final title = t.task.title.toLowerCase();
        final desc = (t.task.description ?? '').toLowerCase();
        final tags = t.task.tags.toLowerCase();
        return title.contains(q) || desc.contains(q) || tags.contains(q);
      }).toList();
    }

    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'priority':
          const pMap = {'urgent': 4, 'high': 3, 'medium': 2, 'low': 1};
          return (pMap[b.task.priority] ?? 0).compareTo(pMap[a.task.priority] ?? 0);
        case 'title':
          return a.task.title.toLowerCase().compareTo(b.task.title.toLowerCase());
        case 'createdAt':
          return b.task.createdAt.compareTo(a.task.createdAt);
        case 'dueDate':
        default:
          if (a.task.dueDate == null && b.task.dueDate == null) return 0;
          if (a.task.dueDate == null) return 1;
          if (b.task.dueDate == null) return -1;
          return a.task.dueDate!.compareTo(b.task.dueDate!);
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final taskRepo = ref.watch(taskRepositoryProvider);
    final notifService = ref.read(notificationServiceProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);
    final feedback = ref.read(feedbackServiceProvider);

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
      body: Column(
        children: [
          PageTitle(
            title: 'Tasks',
            actions: [
              AppIconButton(
                icon: _isBoardView ? Icons.view_agenda_outlined : Icons.view_kanban_outlined,
                tooltip: _isBoardView ? 'Switch to List View' : 'Switch to Kanban Board',
                onPressed: () {
                  feedback.selectionClick();
                  setState(() => _isBoardView = !_isBoardView);
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              AppIconButton(
                icon: _isSearchExpanded ? AppIcons.close : AppIcons.search,
                tooltip: 'Search tasks',
                onPressed: () {
                  feedback.buttonTap();
                  setState(() {
                    if (_isSearchExpanded) {
                      _searchController.clear();
                      _searchQuery = '';
                    }
                    _isSearchExpanded = !_isSearchExpanded;
                  });
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              PopupMenuButton<String>(
                tooltip: 'Sort tasks',
                onSelected: (val) {
                  feedback.selectionClick();
                  setState(() => _sortBy = val);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'dueDate', child: Text('Sort by Due date')),
                  PopupMenuItem(value: 'priority', child: Text('Sort by Priority')),
                  PopupMenuItem(value: 'title', child: Text('Sort by Title')),
                  PopupMenuItem(value: 'createdAt', child: Text('Sort by Newest')),
                ],
                child: Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    AppIcons.sort,
                    size: 20.0,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          if (_isSearchExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                0,
                AppSpacing.pageHorizontal,
                AppSpacing.md,
              ),
              child: SearchField(
                controller: _searchController,
                hintText: 'Search by title, note, or tag...',
                autofocus: true,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),

          if (!_isBoardView) ...[
            // Segmented View Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
              child: Row(
                children: [
                  AppFilterChip(
                    label: 'Today',
                    selected: _activeView == TaskFilterView.today,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _activeView = TaskFilterView.today);
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppFilterChip(
                    label: 'Upcoming',
                    selected: _activeView == TaskFilterView.upcoming,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _activeView = TaskFilterView.upcoming);
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppFilterChip(
                    label: 'All',
                    selected: _activeView == TaskFilterView.all,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _activeView = TaskFilterView.all);
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppFilterChip(
                    label: 'Overdue',
                    selected: _activeView == TaskFilterView.overdue,
                    accentColor: AppColors.error,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _activeView = TaskFilterView.overdue);
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppFilterChip(
                    label: 'Completed',
                    selected: _activeView == TaskFilterView.completed,
                    accentColor: AppColors.success,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _activeView = TaskFilterView.completed);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Priority & Project Filter Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
                vertical: 4.0,
              ),
              child: Row(
                children: [
                  _MiniFacetChip(
                    label: 'All priorities',
                    selected: _selectedPriority == null,
                    onTap: () => setState(() => _selectedPriority = null),
                  ),
                  const SizedBox(width: 6.0),
                  _MiniFacetChip(
                    label: 'Urgent',
                    color: AppColors.priorityUrgent,
                    selected: _selectedPriority == 'urgent',
                    onTap: () => setState(() => _selectedPriority = 'urgent'),
                  ),
                  const SizedBox(width: 6.0),
                  _MiniFacetChip(
                    label: 'High',
                    color: AppColors.priorityHigh,
                    selected: _selectedPriority == 'high',
                    onTap: () => setState(() => _selectedPriority = 'high'),
                  ),
                  const SizedBox(width: 6.0),
                  _MiniFacetChip(
                    label: 'Medium',
                    color: AppColors.priorityMedium,
                    selected: _selectedPriority == 'medium',
                    onTap: () => setState(() => _selectedPriority = 'medium'),
                  ),
                  ...projectsAsync.maybeWhen(
                    data: (projects) => projects.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: _MiniFacetChip(
                          label: p.project.name,
                          color: AppColors.projectAccent,
                          selected: _selectedProjectId == p.project.id,
                          onTap: () => setState(
                            () => _selectedProjectId =
                                _selectedProjectId == p.project.id ? null : p.project.id,
                          ),
                        ),
                      ),
                    ),
                    orElse: () => const <Widget>[],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Content Area (List or Kanban Board)
          Expanded(
            child: tasksAsync.when(
              loading: () => const TasksSkeleton(),
              error: (err, _) => ErrorStateView(
                message: err.toString(),
                onRetry: () => ref.invalidate(allTasksStreamProvider),
              ),
              data: (tasks) {
                if (_isBoardView) {
                  return _buildBoardView(tasks, taskRepo, notifService, widgetSync, feedback);
                }

                final hasFilter = _searchQuery.isNotEmpty ||
                    _selectedPriority != null ||
                    _selectedProjectId != null;
                final visible = _filterAndSortTasks(tasks);
                if (visible.isEmpty) {
                  if (hasFilter) {
                    return EmptyStateView(
                      icon: AppIcons.search,
                      illustrationAsset: 'assets/images/empty/empty_search.png',
                      title: 'No matching tasks.',
                      description: 'Try adjusting your search query or filters.',
                      actionLabel: 'Clear filters',
                      onAction: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                          _selectedPriority = null;
                          _selectedProjectId = null;
                        });
                      },
                    );
                  }
                  return EmptyStateView(
                    icon: _activeView == TaskFilterView.completed
                        ? AppIcons.tasksActive
                        : AppIcons.tasks,
                    illustrationAsset: 'assets/images/empty/empty_tasks.png',
                    title: _activeView == TaskFilterView.completed
                        ? 'No completed tasks yet.'
                        : 'Nothing on your list yet.',
                    description: _activeView == TaskFilterView.completed
                        ? 'Completed tasks stay neatly organized right here.'
                        : 'Add a task to give your day a little direction.',
                    actionLabel: _activeView == TaskFilterView.completed
                        ? null
                        : 'Create a task',
                    onAction: _activeView == TaskFilterView.completed
                        ? null
                        : () => TaskFormSheet.show(context),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.xs,
                    AppSpacing.pageHorizontal,
                    96.0,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final item = visible[index];
                    return TaskTile(
                      taskWithSubtasks: item,
                      onToggleComplete: (isCompleted) async {
                        await _handleTaskToggle(
                          item: item,
                          isCompleted: isCompleted,
                          taskRepo: taskRepo,
                          notifService: notifService,
                          widgetSync: widgetSync,
                          feedback: feedback,
                        );
                      },
                      onTap: () => TaskDetailSheet.show(context, item),
                      onDelete: () async {
                        await feedback.destructiveAction();
                        await notifService.cancelTaskReminder(item.task.id);
                        await taskRepo.deleteTask(item.task.id);
                        await widgetSync.syncAllWidgets();
                        if (context.mounted) {
                          AppToast.show(context, 'Task deleted.');
                        }
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

  Future<void> _handleTaskToggle({
    required TaskWithSubtasks item,
    required bool isCompleted,
    required TaskRepository taskRepo,
    required NotificationService notifService,
    required WidgetSyncService widgetSync,
    required FeedbackService feedback,
  }) async {
    await feedback.taskCompleted(completed: isCompleted);
    await taskRepo.toggleTaskCompletion(item.task.id, isCompleted);
    if (isCompleted) {
      await notifService.cancelTaskReminder(item.task.id);
    }
    await widgetSync.syncAllWidgets();
    if (!mounted) return;

    if (isCompleted) {
      final rewardsRepo = ref.read(rewardsRepositoryProvider);
      final reward = await rewardsRepo.recordActivityAndEvaluate(
        sourceKey: 'task:${item.task.id}',
        sourceType: 'task',
        amount: RewardsRepository.xpTaskCompleted,
        summary: 'Completed ${item.task.title}',
      );
      if (!mounted) return;
      final xpNote = reward.xpAdded > 0 ? ' (+${reward.xpAdded} XP)' : '';
      AppToast.showWithUndo(
        context,
        'Task completed.$xpNote',
        onUndo: () async {
          await taskRepo.toggleTaskCompletion(item.task.id, false);
          await widgetSync.syncAllWidgets();
        },
      );
      if (reward.newlyUnlocked.isNotEmpty) {
        await feedback.achievementUnlocked();
        if (mounted) {
          await RewardCelebrationDialog.show(
            context,
            achievement: reward.newlyUnlocked.first,
            xpEarned: reward.xpAdded,
          );
        }
      }
    } else {
      AppToast.show(context, 'Task reopened.');
    }
  }

  Widget _buildBoardView(
    List<TaskWithSubtasks> allTasks,
    TaskRepository taskRepo,
    NotificationService notifService,
    WidgetSyncService widgetSync,
    FeedbackService feedback,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todoList = allTasks
        .where((t) =>
            !t.task.isCompleted &&
            t.subtasks.every((s) => !s.isCompleted) &&
            t.task.actualMinutes == 0)
        .toList();
    final inProgressList = allTasks
        .where((t) =>
            !t.task.isCompleted &&
            (t.subtasks.any((s) => s.isCompleted) || t.task.actualMinutes > 0))
        .toList();
    final completedList = allTasks.where((t) => t.task.isCompleted).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
        AppSpacing.pageHorizontal,
        96.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBoardColumn(
            'To Do',
            todoList,
            isDark ? AppColors.darkProjectSurface : AppColors.projectSurface,
            taskRepo,
            notifService,
            widgetSync,
            feedback,
          ),
          const SizedBox(width: AppSpacing.lg),
          _buildBoardColumn(
            'In Progress',
            inProgressList,
            isDark ? AppColors.darkTaskSurface : AppColors.taskSurface,
            taskRepo,
            notifService,
            widgetSync,
            feedback,
          ),
          const SizedBox(width: AppSpacing.lg),
          _buildBoardColumn(
            'Completed',
            completedList,
            isDark ? AppColors.darkHabitSurface : AppColors.habitSurface,
            taskRepo,
            notifService,
            widgetSync,
            feedback,
          ),
        ],
      ),
    );
  }

  Widget _buildBoardColumn(
    String title,
    List<TaskWithSubtasks> tasks,
    Color headerColor,
    TaskRepository taskRepo,
    NotificationService notifService,
    WidgetSyncService widgetSync,
    FeedbackService feedback,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 288.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: AppRadii.roundedFull,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.secondary.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  tasks.length.toString(),
                  style: AppTypography.metadata.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      'No tasks in $title',
                      style: AppTypography.secondary.copyWith(
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final item = tasks[index];
                      return TaskTile(
                        taskWithSubtasks: item,
                        compact: true,
                        onToggleComplete: (isCompleted) => _handleTaskToggle(
                          item: item,
                          isCompleted: isCompleted,
                          taskRepo: taskRepo,
                          notifService: notifService,
                          widgetSync: widgetSync,
                          feedback: feedback,
                        ),
                        onTap: () => TaskDetailSheet.show(context, item),
                        onDelete: () async {
                          await feedback.destructiveAction();
                          await notifService.cancelTaskReminder(item.task.id);
                          await taskRepo.deleteTask(item.task.id);
                          await widgetSync.syncAllWidgets();
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

class _MiniFacetChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  const _MiniFacetChip({
    required this.label,
    this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = color ?? (isDark ? AppColors.primaryDark : AppColors.primary);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.roundedXs,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: selected
              ? activeColor.withOpacity(0.14)
              : (isDark ? AppColors.darkSurface : AppColors.surface),
          borderRadius: AppRadii.roundedXs,
          border: Border.all(
            color: selected
                ? activeColor
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.metadata.copyWith(
            color: selected
                ? activeColor
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
