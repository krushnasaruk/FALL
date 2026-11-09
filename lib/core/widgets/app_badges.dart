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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withOpacity(0.12),
        borderRadius: AppRadii.roundedXs,
        border: Border.all(
          color: isOutlined ? color.withOpacity(0.4) : color.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11.0, color: color),
            const SizedBox(width: 4.0),
          ],
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class AppPriorityBadge extends StatelessWidget {
  final String priority; // 'low', 'medium', 'high', 'urgent'

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
        icon = Icons.error_outline_rounded;
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
        text = 'Med';
        break;
      case 'low':
      default:
        color = AppColors.priorityLow;
        icon = Icons.remove_rounded;
        text = 'Low';
        break;
    }

    return AppBadge(label: text, color: color, icon: icon);
  }
}

class AppStatusBadge extends StatelessWidget {
  final String status; // 'planning', 'active', 'on_hold', 'completed', 'archived'

  const AppStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    Color color;
    String text;

    switch (lower) {
      case 'active':
        color = AppColors.statusActive;
        text = 'Active';
        break;
      case 'planning':
        color = AppColors.statusPlanning;
        text = 'Planning';
        break;
      case 'on_hold':
      case 'on hold':
        color = AppColors.statusOnHold;
        text = 'On Hold';
        break;
      case 'completed':
        color = AppColors.statusCompleted;
        text = 'Completed';
        break;
      case 'archived':
      default:
        color = AppColors.statusArchived;
        text = 'Archived';
        break;
    }

    return AppBadge(label: text, color: color);
  }
}

