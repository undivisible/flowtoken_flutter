import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animations.dart';
import 'separator.dart';
import 'tokenized_text.dart';

/// Animated markdown for streaming LLM output — Flutter port of FlowToken.
///
/// When [animation] is null the widget renders static markdown (best for
/// completed messages). When set, newly appended text animates in using
/// [separator] — `diff` is recommended for token streaming.
class AnimatedMarkdown extends StatelessWidget {
  const AnimatedMarkdown({
    required this.content,
    this.separator = FlowTokenSeparator.diff,
    this.animation = FlowTokenAnimation.fadeIn,
    this.duration,
    this.textStyle,
    super.key,
  });

  final String content;
  final FlowTokenSeparator separator;
  final FlowTokenAnimation? animation;
  final Duration? duration;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (animation == null || content.isEmpty) {
      return _StaticMarkdown(content: content);
    }
    // Streaming path: animate incoming tokens as plain text while markdown
    // fences may still be incomplete. For completed-looking content without
    // obvious partial fences, prefer full markdown + diff overlay on tail.
    if (_looksComplete(content)) {
      return _StaticMarkdown(content: content);
    }
    return TokenizedText(
      text: content,
      separator: separator,
      animation: animation!,
      duration: duration,
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
    );
  }

  bool _looksComplete(String value) {
    if (value.contains('```') && value.split('```').length.isOdd) return false;
    return true;
  }
}

class _StaticMarkdown extends StatelessWidget {
  const _StaticMarkdown({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) => GptMarkdown(
        content,
        onLinkTap: (url, title) {
          final uri = Uri.tryParse(url);
          if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      );
}
