import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/avatar_stack.dart';
import '../../../core/widgets/pastel_card.dart';
import '../../../data/repositories/learning_repository.dart';

class LearningCard extends StatelessWidget {
  final SkillWithRoadmap skillWithRoadmap;
  final VoidCallback onTap;
  final Gradient? gradient;

  const LearningCard({
    super.key,
    required this.skillWithRoadmap,
    required this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final skill = skillWithRoadmap.skill;
    final progress = skillWithRoadmap.progressPercentage;
    final percentInt = (progress * 100).toInt();

    final cardGradient = gradient ?? AppColors.learningPastelGradient;

    return PastelCard(
      gradient: cardGradient,
      borderRadius: AppRadii.card,
      padding: const EdgeInsets.all(18.0),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Skill Name & Level badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.name,
                      style: AppTypography.cardHeader.copyWith(
                        fontSize: 18.0,
                        color: const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      '${skill.category} · ${skill.currentLevel.toUpperCase()}',
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
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  skill.targetLevel.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF7C3AED),
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

          const SizedBox(height: 16.0),

          // Bottom Row: Avatars & Topics Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AvatarStack(
                size: 22.0,
                overlap: 8.0,
                maxAvatars: 3,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
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
                      Icons.check_circle_outline_rounded,
                      size: 12.0,
                      color: Color(0xFF7C3AED),
                    ),
                    const SizedBox(width: 4.5),
                    Text(
                      '${skillWithRoadmap.completedTopics} of ${skillWithRoadmap.totalTopics} Topics',
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Backward-compatible SkillCard alias
typedef SkillCard = LearningCard;
