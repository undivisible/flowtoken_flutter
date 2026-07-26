import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Named animations matching the original FlowToken CSS keyframes.
enum FlowTokenAnimation {
  fadeIn,
  blurIn,
  typewriter,
  dropIn,
  slideUp,
  slideInFromLeft,
  fadeAndScale,
  rotateIn,
  bounceIn,
  elastic,
  colorTransition,
  highlight,
  blurAndSharpen,
  wave,
}

extension FlowTokenAnimationX on FlowTokenAnimation {
  Duration get defaultDuration => const Duration(seconds: 1);

  Curve get defaultCurve => Curves.easeInOut;

  Color? colorAt(Animation<double> animation, Curve curve) {
    final value = CurvedAnimation(parent: animation, curve: curve).value;
    return switch (this) {
      FlowTokenAnimation.colorTransition =>
        Color.lerp(const Color(0xffff0000), const Color(0xff000000), value),
      FlowTokenAnimation.highlight =>
        Color.lerp(const Color(0xffffff00), const Color(0x00000000), value),
      _ => null,
    };
  }

  /// Builds a transition for a newly revealed token span.
  Widget transition({
    required Animation<double> animation,
    required Widget child,
    Curve? curve,
  }) {
    final curved =
        CurvedAnimation(parent: animation, curve: curve ?? defaultCurve);
    return switch (this) {
      FlowTokenAnimation.fadeIn =>
        FadeTransition(opacity: curved, child: child),
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
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        ),
      FlowTokenAnimation.fadeAndScale => ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        ),
      FlowTokenAnimation.typewriter => AnimatedBuilder(
          animation: curved,
          builder: (context, child) => ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: curved.value,
              child: child,
            ),
          ),
          child: child,
        ),
      FlowTokenAnimation.rotateIn => AnimatedBuilder(
          animation: curved,
          builder: (context, child) => Opacity(
            opacity: curved.value,
            child: Transform.rotate(
              angle: (curved.value - 1) * math.pi * 2,
              child: child,
            ),
          ),
          child: child,
        ),
      FlowTokenAnimation.bounceIn => AnimatedBuilder(
          animation: curved,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _bounceOffset(curved.value)),
            child: child,
          ),
          child: child,
        ),
      FlowTokenAnimation.elastic => AnimatedBuilder(
          animation: curved,
          builder: (context, child) => Transform.scale(
            scale: _elasticScale(curved.value),
            child: child,
          ),
          child: child,
        ),
      FlowTokenAnimation.colorTransition => child,
      FlowTokenAnimation.highlight => child,
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
      FlowTokenAnimation.wave => AnimatedBuilder(
          animation: curved,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, -10 * math.sin(curved.value * math.pi)),
            child: child,
          ),
          child: child,
        ),
    };
  }

  double _bounceOffset(double value) {
    if (value < 0.2) return -10 * (value / 0.2);
    if (value < 0.4) return -10 * (1 - (value - 0.2) / 0.2);
    if (value < 0.6) return -5 * ((value - 0.4) / 0.2);
    if (value < 0.8) return -5 * (1 - (value - 0.6) / 0.2);
    return 0;
  }

  double _elasticScale(double value) {
    if (value < 0.1) return 1 + 0.2 * (value / 0.1);
    if (value < 0.2) return 1.2 - 0.2 * ((value - 0.1) / 0.1);
    return 1;
  }
}
