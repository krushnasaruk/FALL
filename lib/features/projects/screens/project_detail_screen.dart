import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';
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
    await ref.read(widgetSyncServiceProvider).syncAllWidgets();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final projectRepo = ref.watch(projectRepositoryProvider);
    final taskRepo = ref.watch(taskRepositoryProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final p = projectsAsync.value?.firstWhere((p) => p.project.id == widget.projectId);
              if (p != null) ProjectFormSheet.show(context, projectToEdit: p);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () async {
              await projectRepo.deleteProject(widget.projectId);
              await widgetSync.syncAllWidgets();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          TaskFormSheet.show(context, preselectedProjectId: widget.projectId);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: projectsAsync.when(
        data: (projects) {
          final pWithD = projects.firstWhere(
            (p) => p.project.id == widget.projectId,
            orElse: () => throw Exception('Project not found'),
          );

          final project = pWithD.project;
          final milestones = pWithD.milestones;
          final tasks = pWithD.tasks;
          final techTags = project.techStack.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
            children: [
              // Hero Project Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AppStatusBadge(status: project.status),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                                borderRadius: AppRadii.roundedXs,
                              ),
                              child: Text(
                                project.category,
                                style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        AppPriorityBadge(priority: project.priority),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      project.name,
                      style: AppTypography.displayMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (project.description != null && project.description!.isNotEmpty) ...[
                      const SizedBox(height: 6.0),
                      Text(
                        project.description!,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),

                    // Progress Bar
                    AppProgressBar(
                      progress: pWithD.progressPercentage,
                      progressColor: AppColors.primary,
                      label: 'Overall Progress (${(pWithD.progressPercentage * 100).toInt()}%)',
                      showPercentage: true,
                      height: 10.0,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Timeline & Time Spent Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Started ${DateFormatters.monthDayYear(project.startDate)}',
                          style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                        ),
                        if (project.targetDate != null)
                          Text(
                            'Target ${DateFormatters.monthDayYear(project.targetDate!)}',
                            style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                          ),
                        Text(
                          '${DateFormatters.formatMinutes(project.timeSpentMinutes)} logged',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    if (project.repositoryUrl != null && project.repositoryUrl!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: project.repositoryUrl!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Repository URL copied to clipboard')),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.code_rounded, size: 16.0, color: AppColors.primary),
                            const SizedBox(width: 6.0),
                            Expanded(
                              child: Text(
                                project.repositoryUrl!,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (techTags.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: techTags.map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: AppRadii.roundedXs,
                          ),
                          child: Text(
                            t,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Milestones Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Milestones (${pWithD.completedMilestonesCount}/${milestones.length})',
                    style: AppTypography.titleMedium.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              if (milestones.isEmpty)
                Text(
                  'No milestones defined yet. Break down the project into key objectives below.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                )
              else
                ...milestones.map((m) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadii.roundedSm,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: m.isCompleted,
                          onChanged: (val) async {
                            await projectRepo.toggleMilestoneCompletion(m.id, val ?? false);
                            await widgetSync.syncAllWidgets();
                          },
                        ),
                        Expanded(
                          child: Text(
                            m.title,
                            style: AppTypography.bodyMedium.copyWith(
                              decoration: m.isCompleted ? TextDecoration.lineThrough : null,
                              color: m.isCompleted ? AppColors.darkTextMuted : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
                          onPressed: () async {
                            await projectRepo.deleteMilestone(m.id);
                            await widgetSync.syncAllWidgets();
                          },
                        ),
                      ],
                    ),
                  );
                }),

              // Add Milestone Input
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newMilestoneController,
                        style: AppTypography.bodySmall,
                        decoration: const InputDecoration(
                          hintText: 'Add project milestone...',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onSubmitted: (_) => _addMilestone(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      label: 'Add',
                      onPressed: _addMilestone,
                      size: AppButtonSize.small,
                      variant: AppButtonVariant.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Associated Tasks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Associated Tasks (${pWithD.completedTasksCount}/${tasks.length})',
                    style: AppTypography.titleMedium.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Task'),
                    onPressed: () => TaskFormSheet.show(context, preselectedProjectId: widget.projectId),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              if (tasks.isEmpty)
                Text(
                  'No tasks linked to this project yet.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                )
              else
                ...tasks.map((t) => Container(
                      margin: const EdgeInsets.only(bottom: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        borderRadius: AppRadii.roundedSm,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: t.isCompleted,
                            onChanged: (val) async {
                              await taskRepo.toggleTaskCompletion(t.id, val ?? false);
                              await widgetSync.syncAllWidgets();
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.title,
                                  style: AppTypography.bodyMedium.copyWith(
                                    decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                                    color: t.isCompleted ? AppColors.darkTextMuted : null,
                                  ),
                                ),
                                if (t.dueDate != null)
                                  Text(
                                    'Due ${DateFormatters.relativeDate(t.dueDate!)}',
                                    style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                                  ),
                              ],
                            ),
                          ),
                          AppPriorityBadge(priority: t.priority),
                        ],
                      ),
                    )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateView(message: err.toString()),
      ),
    );
  }
}

