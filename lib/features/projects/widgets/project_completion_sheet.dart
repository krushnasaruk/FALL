import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/companion_avatar.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/widget_sync_service.dart';

class ProjectCompletionSheet extends ConsumerStatefulWidget {
  final ProjectWithDetails project;

  const ProjectCompletionSheet({super.key, required this.project});

  static Future<bool?> show(BuildContext context, {required ProjectWithDetails project}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProjectCompletionSheet(project: project),
    );
  }

  @override
  ConsumerState<ProjectCompletionSheet> createState() => _ProjectCompletionSheetState();
}

class _ProjectCompletionSheetState extends ConsumerState<ProjectCompletionSheet> {
  final _noteController = TextEditingController();
  final DateTime _completedAt = DateTime.now();
  bool _isCompleting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _confirmCompletion() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);

    try {
      final repo = ref.read(projectRepositoryProvider);
      final widgetSync = ref.read(widgetSyncServiceProvider);
      final feedback = ref.read(feedbackServiceProvider);

      await repo.completeProject(
        widget.project.project.id,
        completionNote: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        completedAt: _completedAt,
      );

      // Award XP
      final rewardsRepo = ref.read(rewardsRepositoryProvider);
      await rewardsRepo.recordActivityAndEvaluate(
        sourceKey: 'project_completed:${widget.project.project.id}',
        sourceType: 'project',
        amount: RewardsRepository.xpProjectCompleted,
        summary: 'Completed project "${widget.project.project.name}"',
      );

      await feedback.achievementUnlocked();
      await widgetSync.syncAllWidgets();

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = widget.project;

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
            const Center(
              child: CompanionAvatar(
                expression: CompanionExpression.celebrating,
                size: 72,
                animate: true,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Complete "${p.project.name}"?',
              style: AppTypography.cardTitle.copyWith(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Acknowledge your milestones, review deliverables, and preserve your journey.',
              style: AppTypography.secondary.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Summary Stats Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.background,
                borderRadius: AppRadii.roundedCard,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Progress', style: AppTypography.caption),
                      const SizedBox(height: 4),
                      Text(
                        '${(p.progressPercentage * 100).toStringAsFixed(0)}%',
                        style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Milestones', style: AppTypography.caption),
                      const SizedBox(height: 4),
                      Text(
                        '${p.completedMilestonesCount} / ${p.totalMilestonesCount}',
                        style: AppTypography.titleLarge,
                      ),
                    ],
                  ),
                  if (p.totalDeliverablesCount > 0)
                    Column(
                      children: [
                        const Text('Deliverables', style: AppTypography.caption),
                        const SizedBox(height: 4),
                        Text(
                          '${p.completedDeliverablesCount} / ${p.totalDeliverablesCount}',
                          style: AppTypography.titleLarge,
                        ),
                      ],
                    ),
                  Column(
                    children: [
                      const Text('Time Invested', style: AppTypography.caption),
                      const SizedBox(height: 4),
                      Text(
                        '${(p.project.timeSpentMinutes / 60).toStringAsFixed(1)}h',
                        style: AppTypography.titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Reflection Notes
            const Text('Final Reflection Note (Optional)', style: AppTypography.titleSmall),
            const SizedBox(height: 6),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What did you achieve? Key learnings, outcomes, or links...',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Actions
            AppButton(
              label: _isCompleting ? 'Finalizing...' : 'Confirm & Complete Project',
              icon: AppIcons.completion,
              onPressed: _isCompleting ? null : _confirmCompletion,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
