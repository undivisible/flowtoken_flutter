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
    this.style,
    super.key,
  });

  final String content;
  final FlowTokenSeparator separator;
  final FlowTokenAnimation? animation;
  final Duration? duration;
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
      style: style,
    );
  }
}
