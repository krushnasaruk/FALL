import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// FALL Logo Component (Version 3 - Full-Bleed Cute Light Theme)
/// Features:
/// - Light theme aesthetic (seamless warm ivory background matching full-bleed logo asset)
/// - Cute minimalist baby fox / animal motif with soft blush accents
/// - Subtle OpenAI-inspired constellation of geometric tech dots
/// - Uppercase bold branding: "FALL."
class FallLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final TextStyle? textStyle;
  final Color? markColor;
  final Color? backgroundColor;
  final bool isCircle;

  const FallLogo({
    super.key,
    this.size = 36.0,
    this.showText = false,
    this.textStyle,
    this.markColor,
    this.backgroundColor,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFFDF5E2));
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFF3E5C8);

    Widget logoMark = Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(size * 0.28),
        border: Border.all(color: borderCol, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/fall_logo_light.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Elegant cute vector fallback
            return CustomPaint(
              size: Size(size * 0.70, size * 0.70),
              painter: _CuteFallLogoPainter(
                strokeColor: const Color(0xFF1E293B),
                accentColor: const Color(0xFFFF9EAA),
                dotColor: const Color(0xFF70BDEB),
              ),
            );
          },
        ),
      ),
    );

    if (!showText) return logoMark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoMark,
        const SizedBox(width: 8.0),
        RichText(
          text: TextSpan(
            text: 'FALL',
            style: textStyle ??
                AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.62,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.white : const Color(0xFF19213D),
                ),
            children: const [
              TextSpan(
                text: '.',
                style: TextStyle(
                  color: Color(0xFFFF5E97), // Soft coral dot
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the cute minimalist baby fox + OpenAI-style radial club dots
class _CuteFallLogoPainter extends CustomPainter {
  final Color strokeColor;
  final Color accentColor;
  final Color dotColor;

  _CuteFallLogoPainter({
    required this.strokeColor,
    required this.accentColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    final linePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = math.max(1.5, w * 0.075)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    final blushPaint = Paint()
      ..color = accentColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // 1. Cute rounded animal ears
    final leftEar = Path()
      ..moveTo(cx - w * 0.28, cy - h * 0.05)
      ..quadraticBezierTo(cx - w * 0.38, cy - h * 0.40, cx - w * 0.16, cy - h * 0.32)
      ..close();
    canvas.drawPath(leftEar, fillPaint);

    final rightEar = Path()
      ..moveTo(cx + w * 0.28, cy - h * 0.05)
      ..quadraticBezierTo(cx + w * 0.38, cy - h * 0.40, cx + w * 0.16, cy - h * 0.32)
      ..close();
    canvas.drawPath(rightEar, fillPaint);

    // 2. Cute rounded face silhouette
    final faceRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.08), width: w * 0.72, height: h * 0.60),
      Radius.circular(w * 0.30),
    );
    canvas.drawRRect(faceRect, Paint()..color = const Color(0xFFFFF6EE));
    canvas.drawRRect(faceRect, linePaint);

    // 3. Cute smiling curved eyes
    final eyeY = cy + h * 0.06;
    // Left eye curve
    final leftEye = Path()
      ..moveTo(cx - w * 0.18, eyeY)
      ..quadraticBezierTo(cx - w * 0.13, eyeY - h * 0.05, cx - w * 0.08, eyeY);
    canvas.drawPath(leftEye, linePaint);

    // Right eye curve
    final rightEye = Path()
      ..moveTo(cx + w * 0.08, eyeY)
      ..quadraticBezierTo(cx + w * 0.13, eyeY - h * 0.05, cx + w * 0.18, eyeY);
    canvas.drawPath(rightEye, linePaint);

    // 4. Tiny heart/snout
    canvas.drawCircle(Offset(cx, cy + h * 0.14), w * 0.035, fillPaint);

    // 5. Cute soft blush cheeks
    canvas.drawCircle(Offset(cx - w * 0.22, cy + h * 0.14), w * 0.065, blushPaint);
    canvas.drawCircle(Offset(cx + w * 0.22, cy + h * 0.14), w * 0.065, blushPaint);

    // 6. OpenAI-style club radial constellation of 6 dots above head
    final clusterCenter = Offset(cx, cy - h * 0.28);
    final clusterRadius = w * 0.13;
    final dotRadius = w * 0.032;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      final dx = clusterCenter.dx + clusterRadius * math.cos(angle);
      final dy = clusterCenter.dy + clusterRadius * math.sin(angle);

      if (i % 2 == 0) {
        canvas.drawCircle(Offset(dx, dy), dotRadius * 1.1, dotPaint);
      } else {
        canvas.drawCircle(Offset(dx, dy), dotRadius, fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CuteFallLogoPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.dotColor != dotColor;
  }
}
