import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/pastel_card.dart';
import '../../../data/database/app_database.dart';

typedef Goal = GoalEntry;

class GoalCard extends StatelessWidget {
  final GoalEntry goal;
  final VoidCallback onIncrement;
  final VoidCallback onLogValue;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onIncrement,
    required this.onLogValue,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (goal.targetValue > 0)
        ? (goal.currentValue / goal.targetValue).clamp(0.0, 1.0)
        : 0.0;
    final percentInt = (progress * 100).toInt();

    return PastelCard(
      gradient: AppColors.goalPastelGradient,
      borderRadius: AppRadii.card,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: Title + Cadence Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: AppTypography.cardHeader.copyWith(
                        color: const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      '${goal.currentValue.toStringAsFixed(goal.currentValue.truncateToDouble() == goal.currentValue ? 0 : 1)} of ${goal.targetValue.toStringAsFixed(0)} ${goal.unit}',
                      style: AppTypography.cardSub.copyWith(
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  goal.type.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Progress Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTypography.cardSub.copyWith(
                  color: const Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$percentInt%',
                style: AppTypography.cardPercent.copyWith(
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          AppProgressBar(
            progress: progress,
            height: 5.0,
            barColor: const Color(0xFF1E293B),
            backgroundColor: Colors.white.withOpacity(0.55),
          ),

          const SizedBox(height: 14.0),

          // Bottom Action Row: Log & +1 quick button & options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Log progress text button
              GestureDetector(
                onTap: onLogValue,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_note_rounded, size: 14, color: Color(0xFF334155)),
                      SizedBox(width: 4),
                      Text(
                        'Set Value',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // +1 quick button
                  GestureDetector(
                    onTap: onIncrement,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 13, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            '+1',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.more_horiz_rounded, size: 20, color: Color(0xFF64748B)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                                title: const Text('Delete Goal', style: TextStyle(color: Colors.red)),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  onDelete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
