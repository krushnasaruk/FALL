import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/focus_timer_controller.dart';

class FocusCompletionSheet extends ConsumerStatefulWidget {
  final int focusedMinutes;
  final int breakMinutes;
  final String? initialProjectId;
  final String? initialSkillId;
  final String? initialTaskId;
  final String? initialNotes;

  const FocusCompletionSheet({
    super.key,
    required this.focusedMinutes,
    this.breakMinutes = 0,
    this.initialProjectId,
    this.initialSkillId,
    this.initialTaskId,
    this.initialNotes,
  });

  static Future<bool?> show(
    BuildContext context, {
    required int focusedMinutes,
    int breakMinutes = 0,
    String? initialProjectId,
    String? initialSkillId,
    String? initialTaskId,
    String? initialNotes,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FocusCompletionSheet(
        focusedMinutes: focusedMinutes,
        breakMinutes: breakMinutes,
        initialProjectId: initialProjectId,
        initialSkillId: initialSkillId,
        initialTaskId: initialTaskId,
        initialNotes: initialNotes,
      ),
    );
  }

  @override
  ConsumerState<FocusCompletionSheet> createState() => _FocusCompletionSheetState();
}

class _FocusCompletionSheetState extends ConsumerState<FocusCompletionSheet> {
  late final TextEditingController _notesController;
  String? _selectedProjectId;
  String? _selectedSkillId;
  String? _selectedTaskId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _selectedProjectId = widget.initialProjectId;
    _selectedSkillId = widget.initialSkillId;
    _selectedTaskId = widget.initialTaskId;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    final timerCtrl = ref.read(focusTimerProvider.notifier);
    await timerCtrl.completeSession(
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      projectId: _selectedProjectId,
      skillId: _selectedSkillId,
      taskId: _selectedTaskId,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _discard() async {
    final timerCtrl = ref.read(focusTimerProvider.notifier);
    await timerCtrl.reset();
    await ref.read(feedbackServiceProvider).selectionClick();
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalElapsed = widget.focusedMinutes + widget.breakMinutes;
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final tasksAsync = ref.watch(allTasksStreamProvider);

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(AppIcons.focus, color: AppColors.primary, size: 28),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Session Summary', style: AppTypography.cardTitle),
                      Text(
                        'Review and attribute your focused work',
                        style: AppTypography.secondary.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Time breakdown cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.08),
                      borderRadius: AppRadii.roundedCard,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Focused Time',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.focusedMinutes}m',
                          style: AppTypography.statNumerical.copyWith(
                            fontSize: 26.0,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.background,
                      borderRadius: AppRadii.roundedCard,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Break Time',
                          style: AppTypography.caption.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.breakMinutes}m',
                          style: AppTypography.cardTitle.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.background,
                      borderRadius: AppRadii.roundedCard,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Elapsed',
                          style: AppTypography.caption.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${totalElapsed}m',
                          style: AppTypography.cardTitle.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Linked Project
            const Text('Associate Project', style: AppTypography.titleSmall),
            const SizedBox(height: 6),
            projectsAsync.when(
              data: (projects) => DropdownButtonFormField<String?>(
                value: _selectedProjectId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(AppIcons.projects, size: 20),
                  hintText: 'None (General focus)',
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None (General focus)')),
                  ...projects.map((p) => DropdownMenuItem(
                        value: p.project.id,
                        child: Text(p.project.name, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (val) => setState(() => _selectedProjectId = val),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Linked Skill / Learning Track
            const Text('Associate Learning Track', style: AppTypography.titleSmall),
            const SizedBox(height: 6),
            skillsAsync.when(
              data: (skills) => DropdownButtonFormField<String?>(
                value: _selectedSkillId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(AppIcons.learning, size: 20),
                  hintText: 'None',
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...skills.map((s) => DropdownMenuItem(
                        value: s.skill.id,
                        child: Text(s.skill.name, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (val) => setState(() => _selectedSkillId = val),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Linked Task (Optional)
            const Text('Associate Task (Optional)', style: AppTypography.titleSmall),
            const SizedBox(height: 6),
            tasksAsync.when(
              data: (tasks) {
                final openTasks = tasks.where((t) => !t.task.isCompleted).toList();
                return DropdownButtonFormField<String?>(
                  value: _selectedTaskId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(AppIcons.tasks, size: 20),
                    hintText: 'None',
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...openTasks.map((t) => DropdownMenuItem(
                          value: t.task.id,
                          child: Text(t.task.title, overflow: TextOverflow.ellipsis),
                        )),
                  ],
                  onChanged: (val) => setState(() => _selectedTaskId = val),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.md),

            // Reflection notes
            const Text('Session Notes / What Did You Accomplish?', style: AppTypography.titleSmall),
            const SizedBox(height: 6),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g., Finished authentication flow and wrote unit tests...',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Actions
            AppButton(
              label: _isSaving ? 'Saving...' : 'Save Focus Session',
              icon: AppIcons.completion,
              onPressed: _isSaving ? null : _save,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: _isSaving ? null : _discard,
              child: Text(
                'Discard Session',
                style: AppTypography.titleSmall.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
