import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/reward_celebration_sheet.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/widget_sync_service.dart';
import '../../tasks/widgets/task_form_sheet.dart';
import '../widgets/project_form_sheet.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  final _newMilestoneController = TextEditingController();

  @override
  void dispose() {
    _newMilestoneController.dispose();
    super.dispose();
  }

  Future<void> _addMilestone() async {
    final title = _newMilestoneController.text.trim();
    if (title.isEmpty) return;

    final repo = ref.read(projectRepositoryProvider);
    await repo.addMilestone(projectId: widget.projectId, title: title);
    _newMilestoneController.clear();
    await ref.read(feedbackServiceProvider).buttonTap();
    await ref.read(widgetSyncServiceProvider).syncAllWidgets();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final activitiesAsync = ref.watch(recentActivitiesStreamProvider);
    final projectRepo = ref.watch(projectRepositoryProvider);
    final taskRepo = ref.watch(taskRepositoryProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);
    final feedback = ref.read(feedbackServiceProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.edit),
            tooltip: 'Edit project',
            onPressed: () {
              final list = projectsAsync.value;
              if (list == null) return;
              final match = list.where((p) => p.project.id == widget.projectId).firstOrNull;
              if (match != null) ProjectFormSheet.show(context, projectToEdit: match);
            },
          ),
          IconButton(
            icon: const Icon(AppIcons.delete, color: AppColors.error),
            tooltip: 'Delete project',
            onPressed: () async {
              final list = projectsAsync.value;
              final p = list?.where((x) => x.project.id == widget.projectId).firstOrNull;
              final confirmed = await ConfirmationDialog.show(
                context,
                title: 'Delete project?',
                message:
                    'Delete "${p?.project.name ?? 'this project'}"? Linked milestones will also be deleted.',
              );
              if (!confirmed) return;
              await feedback.destructiveAction();
              await projectRepo.deleteProject(widget.projectId);
              await widgetSync.syncAllWidgets();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          feedback.buttonTap();
          TaskFormSheet.show(context, preselectedProjectId: widget.projectId);
        },
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(AppIcons.add),
        label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: projectsAsync.when(
        loading: () => const LoadingSkeleton(itemCount: 3, itemHeight: 120.0),
        error: (err, _) => ErrorStateView(message: err.toString()),
        data: (projects) {
          final pWithD = projects.where((p) => p.project.id == widget.projectId).firstOrNull;
          if (pWithD == null) {
            return const EmptyStateView(
              icon: AppIcons.projects,
              title: 'Project not found',
              description: 'This project may have been deleted.',
            );
          }

          final project = pWithD.project;
          final milestones = pWithD.milestones;
          final tasks = pWithD.tasks;
          final techTags = project.techStack
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();

          final relatedIds = <String>{
            project.id,
            ...milestones.map((m) => m.id),
            ...tasks.map((t) => t.id),
          };
          final timeline = (activitiesAsync.valueOrNull ?? const [])
              .where((a) => a.entityId != null && relatedIds.contains(a.entityId))
              .take(8)
              .toList();

          return DefaultTabController(
            length: 4,
            child: Column(
              children: [
                // Project Summary Header Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.sm,
                    AppSpacing.pageHorizontal,
                    AppSpacing.md,
                  ),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AppStatusBadge(status: project.status),
                                const SizedBox(width: AppSpacing.sm),
                                AppBadge(label: project.category, color: AppColors.primary),
                              ],
                            ),
                            AppPriorityBadge(priority: project.priority),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          project.name,
                          style: AppTypography.displayMedium.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppProgressBar(
                          progress: pWithD.progressPercentage,
                          progressColor: AppColors.primary,
                          label: 'Progress',
                          showPercentage: true,
                          height: 8.0,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Started ${DateFormatters.monthDayYear(project.startDate)}',
                              style: AppTypography.metadata.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            if (project.targetDate != null)
                              Text(
                                'Due ${DateFormatters.monthDayYear(project.targetDate!)}',
                                style: AppTypography.metadata.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: isDark ? AppColors.primaryDark : AppColors.primary,
                  unselectedLabelColor:
                      isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  indicatorColor: isDark ? AppColors.primaryDark : AppColors.primary,
                  tabs: [
                    const Tab(text: 'Overview'),
                    Tab(text: 'Milestones (${milestones.length})'),
                    Tab(text: 'Tasks (${tasks.length})'),
                    const Tab(text: 'Timeline'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      // 1. Overview & Notes & Tech Stack
                      ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageHorizontal,
                          AppSpacing.lg,
                          AppSpacing.pageHorizontal,
                          96.0,
                        ),
                        children: [
                          if (project.description != null && project.description!.isNotEmpty) ...[
                            AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Summary', style: AppTypography.titleSmall),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(project.description!, style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          if (techTags.isNotEmpty) ...[
                            AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tech Stack', style: AppTypography.titleSmall),
                                  const SizedBox(height: AppSpacing.sm),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: techTags
                                        .map((t) => AppBadge(label: t, color: AppColors.primary))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          if (project.repositoryUrl != null &&
                              project.repositoryUrl!.isNotEmpty) ...[
                            AppCard(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: project.repositoryUrl!));
                                AppToast.show(context, 'Repository URL copied');
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.link_rounded, color: AppColors.primary, size: 18.0),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      project.repositoryUrl!,
                                      style: AppTypography.secondary.copyWith(color: AppColors.primary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          if (project.notes != null && project.notes!.isNotEmpty)
                            AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Blueprint Notes', style: AppTypography.titleSmall),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(project.notes!, style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                        ],
                      ),

                      // 2. Milestones
                      ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageHorizontal,
                          AppSpacing.lg,
                          AppSpacing.pageHorizontal,
                          96.0,
                        ),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _newMilestoneController,
                                  style: AppTypography.bodySmall,
                                  decoration: const InputDecoration(
                                    hintText: 'Add project milestone...',
                                    isDense: true,
                                  ),
                                  onSubmitted: (_) => _addMilestone(),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              SecondaryButton(
                                label: 'Add',
                                size: AppButtonSize.small,
                                onPressed: _addMilestone,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (milestones.isEmpty)
                            const EmptyStateView(
                              icon: AppIcons.goals,
                              title: 'No milestones yet',
                              description: 'Break the project into measurable checkpoints.',
                            )
                          else
                            ...milestones.map(
                              (m) => Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: AppCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 6.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: m.isCompleted,
                                        onChanged: (val) async {
                                          final completed = val ?? false;
                                          if (completed) {
                                            await feedback.milestoneAchieved();
                                          } else {
                                            await feedback.selectionClick();
                                          }
                                          await projectRepo.toggleMilestoneCompletion(m.id, completed);
                                          await widgetSync.syncAllWidgets();
                                          if (completed && context.mounted) {
                                            final reward = await ref
                                                .read(rewardsRepositoryProvider)
                                                .recordActivityAndEvaluate(
                                                  sourceKey: 'milestone:${m.id}',
                                                  sourceType: 'milestone',
                                                  amount: RewardsRepository.xpMilestoneCompleted,
                                                  summary: 'Milestone: ${m.title}',
                                                );
                                            if (!context.mounted) return;
                                            final xpNote = reward.xpAdded > 0
                                                ? ' (+${reward.xpAdded} XP)'
                                                : '';
                                            AppToast.show(
                                              context,
                                              'Milestone completed.$xpNote',
                                              isSuccess: true,
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
                                      ),
                                      Expanded(
                                        child: Text(
                                          m.title,
                                          style: AppTypography.bodyMedium.copyWith(
                                            decoration: m.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: m.isCompleted
                                                ? (isDark
                                                    ? AppColors.darkTextTertiary
                                                    : AppColors.textTertiary)
                                                : null,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(AppIcons.close, size: 16.0),
                                        onPressed: () async {
                                          await projectRepo.deleteMilestone(m.id);
                                          await widgetSync.syncAllWidgets();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // 3. Linked Tasks
                      ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageHorizontal,
                          AppSpacing.lg,
                          AppSpacing.pageHorizontal,
                          96.0,
                        ),
                        children: tasks.isEmpty
                            ? [
                                const EmptyStateView(
                                  icon: AppIcons.tasks,
                                  title: 'No linked tasks',
                                  description: 'Tap Add Task to assign deliverables to this project.',
                                ),
                              ]
                            : tasks.map((t) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                  child: AppCard(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 6.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: t.isCompleted,
                                          onChanged: (val) async {
                                            final next = val ?? false;
                                            await feedback.taskCompleted(completed: next);
                                            await taskRepo.toggleTaskCompletion(t.id, next);
                                            await widgetSync.syncAllWidgets();
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            t.title,
                                            style: AppTypography.bodyMedium.copyWith(
                                              decoration: t.isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        AppPriorityBadge(priority: t.priority),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),

                      // 4. Activity Timeline
                      ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageHorizontal,
                          AppSpacing.lg,
                          AppSpacing.pageHorizontal,
                          96.0,
                        ),
                        children: timeline.isEmpty
                            ? [
                                const EmptyStateView(
                                  icon: AppIcons.analytics,
                                  title: 'No project activity yet',
                                  description: 'Actions on milestones and linked tasks appear here.',
                                ),
                              ]
                            : timeline.map(
                                (a) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                  child: AppCard(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          size: 8.0,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(a.summary, style: AppTypography.bodySmall),
                                              Text(
                                                DateFormatters.dateTimeShort(a.createdAt),
                                                style: AppTypography.metadata.copyWith(
                                                  color: isDark
                                                      ? AppColors.darkTextTertiary
                                                      : AppColors.textTertiary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
