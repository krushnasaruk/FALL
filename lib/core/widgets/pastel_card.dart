import 'package:flutter/material.dart';
import '../theme/app_radii.dart';

class PastelCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool hasOrganicWave;
  final Color? waveColor;

  const PastelCard({
    super.key,
    required this.child,
    required this.gradient,
    this.onTap,
    this.padding = const EdgeInsets.all(18.0),
    this.borderRadius = AppRadii.card,
    this.width,
    this.height,
    this.hasOrganicWave = true,
    this.waveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Subtle organic background shape (as seen in the reference cards)
            if (hasOrganicWave)
              Positioned(
                top: -30,
                right: -20,
                child: Container(
                  width: 140,
                  height: 90,
                  decoration: BoxDecoration(
                    color: (waveColor ?? Colors.white).withOpacity(0.22),
                    borderRadius: const BorderRadius.all(Radius.elliptical(120, 80)),
                  ),
                ),
              ),
            if (hasOrganicWave)
              Positioned(
                top: 15,
                left: -20,
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (waveColor ?? Colors.white).withOpacity(0.12),
                    borderRadius: const BorderRadius.all(Radius.elliptical(80, 40)),
                  ),
                ),
              ),

            // Content
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
