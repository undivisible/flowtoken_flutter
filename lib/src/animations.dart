import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Named animations matching the original FlowToken CSS keyframes.
enum FlowTokenAnimation {
  fadeIn,
  blurIn,
  dropIn,
  slideUp,
  slideInFromLeft,
  fadeAndScale,
  blurAndSharpen,
}

extension FlowTokenAnimationX on FlowTokenAnimation {
  Duration get defaultDuration => switch (this) {
        FlowTokenAnimation.fadeIn => const Duration(milliseconds: 500),
        FlowTokenAnimation.blurIn => const Duration(milliseconds: 600),
        FlowTokenAnimation.dropIn => const Duration(milliseconds: 450),
        FlowTokenAnimation.slideUp => const Duration(milliseconds: 450),
        FlowTokenAnimation.slideInFromLeft => const Duration(milliseconds: 500),
        FlowTokenAnimation.fadeAndScale => const Duration(milliseconds: 500),
        FlowTokenAnimation.blurAndSharpen => const Duration(milliseconds: 550),
      };

  Curve get defaultCurve => Curves.easeOutCubic;

  /// Builds a transition for a newly revealed token span.
  Widget transition({
    required Animation<double> animation,
    required Widget child,
  }) {
    final curved = CurvedAnimation(parent: animation, curve: defaultCurve);
    return switch (this) {
      FlowTokenAnimation.fadeIn => FadeTransition(opacity: curved, child: child),
      FlowTokenAnimation.blurIn => AnimatedBuilder(
          animation: curved,
          builder: (context, child) {
            final t = curved.value;
            return Opacity(
              opacity: t,
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: (1 - t) * 5,
                  sigmaY: (1 - t) * 5,
                ),
                child: child,
              ),
            );
          },
          child: child,
        ),
      FlowTokenAnimation.dropIn => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.08),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        ),
      FlowTokenAnimation.slideUp => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        ),
      FlowTokenAnimation.slideInFromLeft => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.12, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        ),
      FlowTokenAnimation.fadeAndScale => ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        ),
      FlowTokenAnimation.blurAndSharpen => AnimatedBuilder(
          animation: curved,
          builder: (context, child) {
            final t = curved.value;
            return Opacity(
              opacity: t,
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: (1 - t) * 4,
                  sigmaY: (1 - t) * 4,
                ),
                child: child,
              ),
            );
          },
          child: child,
        ),
    };
  }
}
