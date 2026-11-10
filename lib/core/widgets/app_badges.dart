import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool isOutlined;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.5),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withOpacity(0.12),
        borderRadius: AppRadii.roundedXs,
        border: Border.all(
          color: isOutlined ? color.withOpacity(0.45) : color.withOpacity(0.22),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.0, color: color),
            const SizedBox(width: 4.0),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.metadata.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Consistent FilterChip across all screens (40dp comfortable pill height).
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? accentColor;
  final IconData? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.accentColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryCol = accentColor ?? (isDark ? AppColors.primaryDark : AppColors.primary);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onSelected,
        borderRadius: AppRadii.roundedFull,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 36.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
          decoration: BoxDecoration(
            color: selected
                ? primaryCol
                : (isDark ? AppColors.darkSurface : AppColors.surface),
            borderRadius: AppRadii.roundedFull,
            border: Border.all(
              color: selected
                  ? primaryCol
                  : (isDark ? AppColors.darkBorder : AppColors.border),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14.0,
                  color: selected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
                const SizedBox(width: 5.0),
              ],
              Text(
                label,
                style: AppTypography.secondary.copyWith(
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Priority indicator: NEVER color alone (always icon + readable text label).
class AppPriorityBadge extends StatelessWidget {
  final String priority;

  const AppPriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final lower = priority.toLowerCase();
    Color color;
    IconData icon;
    String text;

    switch (lower) {
      case 'urgent':
        color = AppColors.priorityUrgent;
        icon = Icons.priority_high_rounded;
        text = 'Urgent';
        break;
      case 'high':
        color = AppColors.priorityHigh;
        icon = Icons.flag_rounded;
        text = 'High';
        break;
      case 'medium':
        color = AppColors.priorityMedium;
        icon = Icons.flag_outlined;
        text = 'Medium';
        break;
      case 'low':
      default:
        color = AppColors.priorityLow;
        icon = Icons.low_priority_rounded;
        text = 'Low';
        break;
    }

    return AppBadge(label: text, color: color, icon: icon);
  }
}

typedef PriorityIndicator = AppPriorityBadge;

class AppStatusBadge extends StatelessWidget {
  final String status;

  const AppStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    Color color;
    IconData icon;
    String text;

    switch (lower) {
      case 'active':
        color = AppColors.statusActive;
        icon = Icons.play_circle_outline_rounded;
        text = 'Active';
        break;
      case 'planning':
        color = AppColors.statusPlanning;
        icon = Icons.edit_calendar_outlined;
        text = 'Planning';
        break;
      case 'on_hold':
      case 'on hold':
        color = AppColors.statusOnHold;
        icon = Icons.pause_circle_outline_rounded;
        text = 'On Hold';
        break;
      case 'completed':
        color = AppColors.statusCompleted;
        icon = Icons.check_circle_outline_rounded;
        text = 'Completed';
        break;
      case 'archived':
      default:
        color = AppColors.statusArchived;
        icon = Icons.inventory_2_outlined;
        text = 'Archived';
        break;
    }

    return AppBadge(label: text, color: color, icon: icon);
  }
}

typedef StatusBadge = AppStatusBadge;
typedef StatusChip = AppStatusBadge;
