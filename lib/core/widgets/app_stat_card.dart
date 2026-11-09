import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_typography.dart';
import 'pastel_card.dart';

class AppStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? accentColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.accentColor,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (accentColor ?? AppColors.taskBlue).withOpacity(0.28),
            (accentColor ?? AppColors.taskBlue).withOpacity(0.12),
          ],
        );

    final iconColor = accentColor ?? AppColors.textPrimary;

    return PastelCard(
      onTap: onTap,
      gradient: effectiveGradient,
      padding: const EdgeInsets.all(16.0),
      borderRadius: AppRadii.lg,
      hasOrganicWave: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14.0, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            value,
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3.0),
            Text(
              subtitle!,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
