import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';
import 'app_progress_bar.dart';
import 'avatar_stack.dart';
import 'pastel_card.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String? subtitle;
  final String? date;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.subtitle,
    this.date,
    this.gradient,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final cardGradient = gradient ?? AppColors.cyanPastelGradient;
    final percentInt = (progress.clamp(0.0, 1.0) * 100).toInt();

    return PastelCard(
      gradient: cardGradient,
      borderRadius: AppRadii.card,
      padding: const EdgeInsets.all(18.0),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Title + 3-dots menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cardHeader.copyWith(
                    fontSize: 18.0,
                    color: const Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onMore != null)
                GestureDetector(
                  onTap: onMore,
                  child: const Icon(
                    Icons.more_vert_rounded,
                    size: 20.0,
                    color: Color(0xFF475569),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14.0),

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

          // Bottom Row: Avatar stack + Date / info pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AvatarStack(
                size: 22.0,
                overlap: 8.0,
                maxAvatars: 3,
              ),
              if (date != null && date!.isNotEmpty)
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
                        Icons.calendar_today_rounded,
                        size: 11.0,
                        color: Color(0xFF475569),
                      ),
                      const SizedBox(width: 4.5),
                      Text(
                        date!,
                        style: const TextStyle(
                          fontSize: 10.5,
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
