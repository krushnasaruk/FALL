import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centralized Motion Tokens & Accessibility-Aware Animation Helpers for FALL.
/// Durations remain short and calm, and collapse cleanly when the system
/// "Remove Animations" / reduced-motion accessibility setting is enabled.
class AppMotion {
  AppMotion._();

  // Durations
  static const Duration fast = Duration(milliseconds: 110);
  static const Duration normal = Duration(milliseconds: 180);
  static const Duration moderate = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 340);
  static const Duration celebration = Duration(milliseconds: 460);
  static const Duration shimmer = Duration(milliseconds: 1400);

  // Curves
  static const Curve easeOut = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOutCubic;
  static const Curve crisp = Curves.easeOutQuart;
  static const Curve gentleSettle = Curves.easeOutBack;

  // Scales & Offsets
  static const double pressScale = 0.97;
  static const Offset subtleSlideOffset = Offset(0.0, 0.035);

  /// Returns true when the platform prefers reduced motion.
  static bool isReducedMotion(BuildContext context) {
    return MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  }

  /// Collapses non-essential animation durations when reduced motion is enabled.
  static Duration resolveDuration(BuildContext context, Duration duration) {
    return isReducedMotion(context) ? Duration.zero : duration;
  }

  /// Subtle slide-up + fade transition for pushed detail views and secondary tools.
  static CustomTransitionPage<T> buildDetailPage<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      transitionDuration: moderate,
      reverseTransitionDuration: normal,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (isReducedMotion(context)) return child;
        final curved = CurvedAnimation(parent: animation, curve: easeOut, reverseCurve: Curves.easeIn);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

