import 'package:flutter/material.dart';

import 'animations.dart';
import 'separator.dart';
import 'tokenized_text.dart';

/// Plain-text streaming animation (no markdown parsing).
class AnimatedText extends StatelessWidget {
  const AnimatedText({
    required this.content,
    this.separator = FlowTokenSeparator.diff,
    this.animation = FlowTokenAnimation.fadeIn,
    this.duration,
    this.curve,
    this.animationIterationCount = 1,
    this.alignment = WrapAlignment.start,
    this.style,
    super.key,
  });

  final String content;
  final FlowTokenSeparator separator;
  final FlowTokenAnimation? animation;
  final Duration? duration;
  final Curve? curve;
  final int animationIterationCount;
  final WrapAlignment alignment;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (animation == null) {
      return Text(content, style: style);
    }
    return TokenizedText(
      text: content,
      separator: separator,
      animation: animation!,
      duration: duration,
      curve: curve,
      animationIterationCount: animationIterationCount,
      alignment: alignment,
      style: style,
    );
  }
}
