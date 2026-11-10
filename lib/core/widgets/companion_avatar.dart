import 'package:flutter/material.dart';
import '../theme/app_motion.dart';

/// All 12 signature expressions of Pip, the FALL Fox Companion.
enum CompanionExpression {
  welcome('assets/images/companion/pip_welcome.png', 'Pip waving warmly'),
  idle('assets/images/companion/pip_idle.png', 'Pip waiting calmly'),
  happy('assets/images/companion/pip_happy.png', 'Pip smiling happily'),
  celebrating('assets/images/companion/pip_celebrating.png', 'Pip celebrating progress'),
  thinking('assets/images/companion/pip_thinking.png', 'Pip thinking through a problem'),
  focused('assets/images/companion/pip_focused.png', 'Pip focused deeply'),
  curious('assets/images/companion/pip_curious.png', 'Pip looking curious'),
  encouraging('assets/images/companion/pip_encouraging.png', 'Pip encouraging your next step'),
  sleeping('assets/images/companion/pip_sleeping.png', 'Pip resting during quiet time'),
  supportive('assets/images/companion/pip_supportive.png', 'Pip offering gentle support'),
  learning('assets/images/companion/pip_learning.png', 'Pip reading a roadmap book'),
  achievement('assets/images/companion/pip_achievement.png', 'Pip holding an achievement crest');

  final String assetPath;
  final String semanticLabel;
  const CompanionExpression(this.assetPath, this.semanticLabel);
}

/// Standardized rendering component for Pip, supporting optional gentle celebratory settle
/// animation that respects reduced-motion accessibility settings.
class CompanionAvatar extends StatefulWidget {
  final CompanionExpression expression;
  final double size;
  final bool animate;

  const CompanionAvatar({
    super.key,
    required this.expression,
    this.size = 88.0,
    this.animate = false,
  });

  @override
  State<CompanionAvatar> createState() => _CompanionAvatarState();
}

class _CompanionAvatarState extends State<CompanionAvatar>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant CompanionAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate || oldWidget.expression != widget.expression) {
      _syncController();
    }
  }

  void _syncController() {
    if (!widget.animate) {
      _controller?.dispose();
      _controller = null;
      return;
    }
    _controller ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller!
      ..reset()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = AppMotion.isReducedMotion(context);
    final image = Semantics(
      image: true,
      label: widget.expression.semanticLabel,
      child: Image.asset(
        widget.expression.assetPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => SizedBox(
          width: widget.size,
          height: widget.size,
          child: const Icon(Icons.pets_rounded, size: 32.0),
        ),
      ),
    );

    if (_controller == null || reduced) return image;

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        final t = Curves.easeInOutSine.transform(_controller!.value);
        final scale = 1.0 + (t * 0.035);
        final dy = -t * 2.5;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: image,
    );
  }
}

