import 'package:flutter/material.dart';

import 'animations.dart';

class AnimatedImage extends StatelessWidget {
  const AnimatedImage({
    required this.src,
    required this.alt,
    this.animation = FlowTokenAnimation.fadeIn,
    this.duration,
    this.curve,
    this.animationIterationCount = 1,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String src;
  final String alt;
  final FlowTokenAnimation? animation;
  final Duration? duration;
  final Curve? curve;
  final int animationIterationCount;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      src,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        height: height,
        width: width,
      ),
    );
    if (animation == null) return image;
    return _AnimatedImage(
      animation: animation!,
      duration: duration ?? animation!.defaultDuration,
      curve: curve,
      animationIterationCount: animationIterationCount,
      child: image,
    );
  }
}

class _AnimatedImage extends StatefulWidget {
  const _AnimatedImage({
    required this.animation,
    required this.duration,
    required this.curve,
    required this.animationIterationCount,
    required this.child,
  });

  final FlowTokenAnimation animation;
  final Duration duration;
  final Curve? curve;
  final int animationIterationCount;
  final Widget child;

  @override
  State<_AnimatedImage> createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<_AnimatedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animationIterationCount > 1) {
      _controller.repeat(count: widget.animationIterationCount);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.animation.transition(
        animation: _controller,
        child: widget.child,
        curve: widget.curve,
      );
}
