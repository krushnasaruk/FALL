import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/feedback_service.dart';
import '../../tasks/widgets/task_form_sheet.dart';

class QuickActionsBar extends ConsumerWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final feedback = ref.read(feedbackServiceProvider);

    final actions = [
      _QuickActionItem(
        label: 'Task',
        icon: AppIcons.add,
        accentColor: AppColors.taskAccent,
        surfaceColor: isDark ? AppColors.darkTaskSurface : AppColors.taskSurface,
        onTap: () {
          feedback.buttonTap();
          TaskFormSheet.show(context);
        },
      ),
      _QuickActionItem(
        label: 'Focus',
        icon: AppIcons.focus,
        accentColor: AppColors.focusAccent,
        surfaceColor: isDark ? AppColors.darkFocusSurface : AppColors.focusSurface,
        onTap: () {
          feedback.buttonTap();
          context.push('/focus');
        },
      ),
      _QuickActionItem(
        label: 'Radar',
        icon: Icons.radar_rounded,
        accentColor: AppColors.primary,
        surfaceColor: isDark ? AppColors.darkProjectSurface : AppColors.primarySoft,
        onTap: () {
          feedback.buttonTap();
          context.push('/radar');
        },
      ),
      _QuickActionItem(
        label: 'Learning',
        icon: AppIcons.learning,
        accentColor: AppColors.learningAccent,
        surfaceColor: isDark ? AppColors.darkLearningSurface : AppColors.learningSurface,
        onTap: () {
          feedback.buttonTap();
          context.go('/learning');
        },
      ),
      _QuickActionItem(
        label: 'Habits',
        icon: AppIcons.habits,
        accentColor: AppColors.habitAccent,
        surfaceColor: isDark ? AppColors.darkHabitSurface : AppColors.habitSurface,
        onTap: () {
          feedback.buttonTap();
          context.push('/habits');
        },
      ),
      _QuickActionItem(
        label: 'Journal',
        icon: AppIcons.journal,
        accentColor: isDark ? AppColors.primaryDark : AppColors.primary,
        surfaceColor: isDark ? AppColors.darkProjectSurface : AppColors.primarySoft,
        onTap: () {
          feedback.buttonTap();
          context.push('/journal');
        },
      ),
      _QuickActionItem(
        label: 'Note',
        icon: AppIcons.notes,
        accentColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        surfaceColor: isDark ? AppColors.darkSurfaceElevated : AppColors.noteSurface,
        onTap: () {
          feedback.buttonTap();
          context.push('/vault');
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 52.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final a = actions[index];
              return Semantics(
                button: true,
                label: 'Quick action ${a.label}',
                child: Material(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.roundedFull,
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: InkWell(
                    onTap: a.onTap,
                    borderRadius: AppRadii.roundedFull,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28.0,
                            height: 28.0,
                            decoration: BoxDecoration(
                              color: a.surfaceColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(a.icon, size: 16.0, color: a.accentColor),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            a.label,
                            style: AppTypography.secondary.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionItem {
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color surfaceColor;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.surfaceColor,
    required this.onTap,
  });
}
