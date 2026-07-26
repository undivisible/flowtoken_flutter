import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animations.dart';
import 'code_block.dart';
import 'separator.dart';
import 'tokenized_text.dart';
import 'animated_image.dart';

/// Animated markdown for streaming LLM output — Flutter port of FlowToken.
///
/// When [animation] is null the widget renders static markdown (best for
/// completed messages). When set, newly appended text animates in using
/// [separator] — `diff` is recommended for token streaming.
class AnimatedMarkdown extends StatelessWidget {
  const AnimatedMarkdown({
    required this.content,
    this.separator = FlowTokenSeparator.diff,
    this.sep,
    this.animation = FlowTokenAnimation.fadeIn,
    this.duration,
    this.curve,
    this.animationIterationCount = 1,
    this.textStyle,
    this.codeStyle,
    this.imageHeight,
    super.key,
  });

  final String content;
  final FlowTokenSeparator separator;
  final FlowTokenSeparator? sep;
  final FlowTokenAnimation? animation;
  final Duration? duration;
  final Curve? curve;
  final int animationIterationCount;
  final TextStyle? textStyle;
  final TextStyle? codeStyle;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    if (animation == null || content.isEmpty) {
      return _StaticMarkdown(
        content: content,
        textStyle: textStyle,
        codeStyle: codeStyle,
        imageHeight: imageHeight,
      );
    }
    // Streaming path: animate incoming tokens as plain text while markdown
    // fences may still be incomplete. For completed-looking content without
    // obvious partial fences, prefer full markdown + diff overlay on tail.
    if (!_hasMarkdown(content)) {
      return TokenizedText(
        text: content,
        separator: sep ?? separator,
        animation: animation!,
        duration: duration,
        curve: curve,
        animationIterationCount: animationIterationCount,
        style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      );
    }
    return AnimatedSwitcher(
      duration: duration ?? animation!.defaultDuration,
      switchInCurve: curve ?? animation!.defaultCurve,
      switchOutCurve: curve ?? animation!.defaultCurve,
      transitionBuilder: (child, transition) => animation!.transition(
        animation: transition,
        child: child,
        curve: curve,
      ),
      child: KeyedSubtree(
        key: ValueKey(content),
        child: _StaticMarkdown(
          content: content,
          textStyle: textStyle,
          codeStyle: codeStyle,
          imageHeight: imageHeight,
          animation: animation,
          duration: duration,
          curve: curve,
          animationIterationCount: animationIterationCount,
        ),
      ),
    );
  }

  bool _hasMarkdown(String value) => RegExp(
        r'(^|\n)\s*(#{1,6}\s|[-*+]\s|\d+\.\s|```|>|---+$)|\*\*|__|`|\[.+?\]\(.+?\)|!\[',
        multiLine: true,
      ).hasMatch(value);
}

class _StaticMarkdown extends StatelessWidget {
  const _StaticMarkdown({
    required this.content,
    this.textStyle,
    this.codeStyle,
    this.imageHeight,
    this.animation,
    this.duration,
    this.curve,
    this.animationIterationCount = 1,
  });

  final String content;
  final TextStyle? textStyle;
  final TextStyle? codeStyle;
  final double? imageHeight;
  final FlowTokenAnimation? animation;
  final Duration? duration;
  final Curve? curve;
  final int animationIterationCount;

  @override
  Widget build(BuildContext context) => GptMarkdown(
        content,
        style: textStyle,
        codeBuilder: (context, language, code, closed) => FlowTokenCodeBlock(
          language: language,
          code: code,
          style: codeStyle,
          animation: animation,
          duration: duration,
          curve: curve,
          animationIterationCount: animationIterationCount,
        ),
        imageBuilder: (context, url, width, height) => AnimatedImage(
          src: url,
          alt: '',
          width: width,
          height: height ?? imageHeight,
          animation: animation,
          duration: duration,
          curve: curve,
          animationIterationCount: animationIterationCount,
        ),
        onLinkTap: (url, title) {
          final uri = Uri.tryParse(url);
          if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      );
}
