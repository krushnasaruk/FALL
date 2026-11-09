import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pastel_card.dart';
import '../../../data/repositories/habit_repository.dart';

class HabitCard extends StatelessWidget {
  final HabitWithEntries habitWithEntries;
  final VoidCallback onToggleToday;
  final VoidCallback onDelete;
  final List<String> weekDayLabels;

  const HabitCard({
    super.key,
    required this.habitWithEntries,
    required this.onToggleToday,
    required this.onDelete,
    this.weekDayLabels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
  });

  @override
  Widget build(BuildContext context) {
    final habit = habitWithEntries.habit;
    final isDone = habitWithEntries.isCompletedToday;
    final streak = habitWithEntries.currentStreak;
    final activity = habitWithEntries.last7DaysActivity;

    return PastelCard(
      gradient: AppColors.habitPastelGradient,
      borderRadius: AppRadii.card,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: Title + Streak badge & delete
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Check circle
              GestureDetector(
                onTap: onToggleToday,
                child: Container(
                  width: 26.0,
                  height: 26.0,
                  margin: const EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? const Color(0xFF1E293B) : Colors.white,
                    border: Border.all(
                      color: isDone ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded, size: 16.0, color: Colors.white)
                      : null,
                ),
              ),

              // Title and streak
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: AppTypography.cardHeader.copyWith(
                        color: const Color(0xFF1E293B),
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      '$streak day streak · ${isDone ? "Today ✓" : "Pending"}',
                      style: AppTypography.cardSub.copyWith(
                        color: const Color(0xFF475569),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Streak Flame Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.5),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 14.0,
                      color: Color(0xFFEA580C),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '$streak d',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.more_horiz_rounded, size: 20, color: Color(0xFF64748B)),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                            title: const Text('Delete Habit', style: TextStyle(color: Colors.red)),
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

          const SizedBox(height: 16.0),

          // 7-day activity dots
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.65),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (idx) {
                final done = activity[idx];
                final dayLabel = weekDayLabels.length > idx ? weekDayLabels[idx] : '';
                return Column(
                  children: [
                    Text(
                      dayLabel,
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? const Color(0xFF1E293B) : Colors.white,
                        border: Border.all(
                          color: done ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: done
                          ? const Icon(Icons.check, size: 13, color: Colors.white)
                          : null,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
