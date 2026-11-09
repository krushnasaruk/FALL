import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/task_repository.dart';
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
  String? _selectedPriority; // null = all
  String? _sortBy = 'dueDate'; // dueDate, priority, title, createdAt
  bool _isSearchExpanded = false;
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

    // 1. Filter by View
    var filtered = tasks.where((item) {
      final t = item.task;
      switch (_activeView) {
        case TaskFilterView.today:
          if (t.isCompleted) return false;
          if (t.dueDate == null) return false;
          return t.dueDate!.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
              t.dueDate!.isBefore(todayEnd);

        case TaskFilterView.upcoming:
          if (t.isCompleted) return false;
          if (t.dueDate == null) return true; // Someday tasks
          return t.dueDate!.isAfter(todayEnd);

        case TaskFilterView.overdue:
          return item.isOverdue;

        case TaskFilterView.completed:
          return t.isCompleted;

        case TaskFilterView.all:
          return !t.isCompleted;
      }
    }).toList();

    // 2. Filter by Priority
    if (_selectedPriority != null) {
      filtered = filtered.where((t) => t.task.priority == _selectedPriority).toList();
    }

    // 3. Search query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        final title = t.task.title.toLowerCase();
        final desc = (t.task.description ?? '').toLowerCase();
        final tags = t.task.tags.toLowerCase();
        return title.contains(q) || desc.contains(q) || tags.contains(q);
      }).toList();
    }

    // 4. Sort
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'priority':
          final pMap = {'urgent': 4, 'high': 3, 'medium': 2, 'low': 1};
          final pA = pMap[a.task.priority] ?? 0;
          final pB = pMap[b.task.priority] ?? 0;
          return pB.compareTo(pA);

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
    final tasksAsync = ref.watch(allTasksStreamProvider);
    final taskRepo = ref.watch(taskRepositoryProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearchExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search tasks by title, tag, or note...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _isSearchExpanded = false;
                      });
                    },
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              )
            : Text(
                'Tasks',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
              ),
        actions: [
          if (!_isSearchExpanded)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => setState(() => _isSearchExpanded = true),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort tasks',
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'dueDate', child: Text('Sort by Due Date')),
              const PopupMenuItem(value: 'priority', child: Text('Sort by Priority')),
              const PopupMenuItem(value: 'title', child: Text('Sort by Title')),
              const PopupMenuItem(value: 'createdAt', child: Text('Sort by Newest')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => TaskFormSheet.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => TaskFormSheet.show(context),
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Task', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // View selector bar (Today, Upcoming, All, Completed, Overdue)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildViewChip(TaskFilterView.today, 'Today'),
                const SizedBox(width: 8),
                _buildViewChip(TaskFilterView.upcoming, 'Upcoming'),
                const SizedBox(width: 8),
                _buildViewChip(TaskFilterView.overdue, 'Overdue'),
                const SizedBox(width: 8),
                _buildViewChip(TaskFilterView.all, 'All Open'),
                const SizedBox(width: 8),
                _buildViewChip(TaskFilterView.completed, 'Completed'),
              ],
            ),
          ),

          // Priority Filter Pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                _buildPriorityFilterChip(null, 'All Priorities'),
                const SizedBox(width: 6),
                _buildPriorityFilterChip('urgent', 'Urgent', AppColors.priorityUrgent),
                const SizedBox(width: 6),
                _buildPriorityFilterChip('high', 'High', AppColors.priorityHigh),
                const SizedBox(width: 6),
                _buildPriorityFilterChip('medium', 'Med', AppColors.priorityMedium),
              ],
            ),
          ),
          const SizedBox(height: 8.0),

          // Task List Body
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                final visibleTasks = _filterAndSortTasks(tasks);

                if (visibleTasks.isEmpty) {
                  return EmptyStateView(
                    icon: _activeView == TaskFilterView.completed
                        ? Icons.check_circle_outline_rounded
                        : Icons.task_alt_rounded,
                    title: _searchQuery.isNotEmpty
                        ? 'No tasks found'
                        : (_activeView == TaskFilterView.today
                            ? 'All clear for today!'
                            : 'No tasks here'),
                    description: _searchQuery.isNotEmpty
                        ? 'Try adjusting your search query or filter.'
                        : 'Plan your next milestone, experiment, or technical target.',
                    actionLabel: 'Create Task',
                    onAction: () => TaskFormSheet.show(context),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 80.0),
                  itemCount: visibleTasks.length,
                  itemBuilder: (context, index) {
                    final item = visibleTasks[index];
                    return TaskTile(
                      taskWithSubtasks: item,
                      onToggleComplete: (isCompleted) async {
                        await taskRepo.toggleTaskCompletion(item.task.id, isCompleted);
                        await widgetSync.syncAllWidgets();
                      },
                      onTap: () => TaskDetailSheet.show(context, item),
                      onDelete: () async {
                        await taskRepo.deleteTask(item.task.id);
                        await widgetSync.syncAllWidgets();
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorStateView(
                message: err.toString(),
                onRetry: () => ref.refresh(allTasksStreamProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewChip(TaskFilterView view, String label) {
    final isSelected = _activeView == view;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _activeView = view),
      labelStyle: AppTypography.caption.copyWith(
        color: isSelected
            ? const Color(0xFF0F172A)
            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.roundedMd,
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildPriorityFilterChip(String? priority, String label, [Color? color]) {
    final isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = priority),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? AppColors.primary).withOpacity(0.18) : Colors.transparent,
          borderRadius: AppRadii.roundedXs,
          border: Border.all(
            color: isSelected ? (color ?? AppColors.primary) : AppColors.darkBorder,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 11.0,
            color: isSelected ? (color ?? AppColors.primary) : AppColors.darkTextMuted,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
