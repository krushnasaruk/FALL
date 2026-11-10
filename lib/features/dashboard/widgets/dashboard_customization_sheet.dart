import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';

class DashboardCustomizationSheet extends ConsumerWidget {
  const DashboardCustomizationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context,
      builder: (_) => const DashboardCustomizationSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefsState = ref.watch(userPreferencesProvider);
    final notifier = ref.read(userPreferencesProvider.notifier);
    final feedback = ref.read(feedbackServiceProvider);
    final sections = prefsState.dashboardSections;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Customize Dashboard',
                style: AppTypography.sectionTitle.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                feedback.buttonTap();
                notifier.resetDashboardSections();
              },
              child: const Text('Reset order'),
            ),
          ],
        ),
        Text(
          'Toggle visibility or reorder sections to fit your daily focus.',
          style: AppTypography.secondary.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 360.0,
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            itemCount: sections.length,
            onReorder: (oldIndex, newIndex) {
              feedback.reorder();
              notifier.reorderSections(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final sec = sections[index];
              return Container(
                key: ValueKey(sec.id),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
                  borderRadius: AppRadii.roundedMd,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      Icons.drag_indicator_rounded,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                  ),
                  title: Text(
                    sec.label,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  trailing: Switch(
                    value: sec.isVisible,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      feedback.selectionClick();
                      notifier.toggleSectionVisibility(sec.id, val);
                    },
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
