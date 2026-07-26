import 'dart:async';

import 'package:flutter/material.dart';

import 'animations.dart';
import 'separator.dart';

/// A single animated span — either a diff chunk or a word/char token.
class _FlowToken {
  _FlowToken({required this.key, required this.text});

  final int key;
  final String text;
}

/// Token-by-token animated text, porting FlowToken's SplitText behaviour.
class TokenizedText extends StatefulWidget {
  const TokenizedText({
    required this.text,
    this.separator = FlowTokenSeparator.diff,
    this.animation = FlowTokenAnimation.fadeIn,
    this.duration,
    this.curve,
    this.animationIterationCount = 1,
    this.style,
    super.key,
  });

  final String text;
  final FlowTokenSeparator separator;
  final FlowTokenAnimation animation;
  final Duration? duration;
  final Curve? curve;
  final int animationIterationCount;
  final TextStyle? style;

  @override
  State<TokenizedText> createState() => _TokenizedTextState();
}

class _TokenizedTextState extends State<TokenizedText> {
  String _previous = '';
  String _full = '';
  final List<_FlowToken> _diffTokens = [];
  int _nextKey = 0;

  List<_FlowToken> _tokensFor(String input) {
    switch (widget.separator) {
      case FlowTokenSeparator.diff:
        if (_previous.isEmpty || input.length < _previous.length) {
          _diffTokens.clear();
          _full = '';
          _nextKey = 0;
        }
        if (input != _previous) {
          if (input.startsWith(_full) && input.length > _full.length) {
            final unique = input.substring(_full.length);
            if (unique.isNotEmpty) {
              _diffTokens.add(_FlowToken(key: _nextKey++, text: unique));
              _full = input;
            }
          } else {
            _diffTokens
              ..clear()
              ..add(_FlowToken(key: _nextKey++, text: input));
            _full = input;
          }
        }
        _previous = input;
        return List<_FlowToken>.from(_diffTokens);
      case FlowTokenSeparator.word:
        final parts = input.split(RegExp(r'(\s+)')).where((p) => p.isNotEmpty);
        var i = 0;
        return [
          for (final part in parts) _FlowToken(key: i++, text: part),
        ];
      case FlowTokenSeparator.char:
        var i = 0;
        return [
          for (final codeUnit in input.runes)
            _FlowToken(key: i++, text: String.fromCharCode(codeUnit)),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = _tokensFor(widget.text);
    final duration = widget.duration ?? widget.animation.defaultDuration;
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final token in tokens)
          _AnimatedToken(
            key: ValueKey<int>(token.key),
            text: token.text,
            animation: widget.animation,
            duration: duration,
            curve: widget.curve,
            animationIterationCount: widget.animationIterationCount,
            style: widget.style,
          ),
      ],
    );
  }
}

class _AnimatedToken extends StatefulWidget {
  const _AnimatedToken({
    required this.text,
    required this.animation,
    required this.duration,
    required this.curve,
    required this.animationIterationCount,
    this.style,
    super.key,
  });

  final String text;
  final FlowTokenAnimation animation;
  final Duration duration;
  final Curve? curve;
  final int animationIterationCount;
  final TextStyle? style;

  @override
  State<_AnimatedToken> createState() => _AnimatedTokenState();
}

class _AnimatedTokenState extends State<_AnimatedToken>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animationIterationCount > 1) {
      unawaited(_controller.repeat(count: widget.animationIterationCount));
    } else {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation == FlowTokenAnimation.highlight ||
        widget.animation == FlowTokenAnimation.colorTransition) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => widget.animation.transition(
          animation: _controller,
          curve: widget.curve,
          child: Text(
            widget.text,
            style: _styleWithColor(),
          ),
        ),
      );
    }
    return widget.animation.transition(
      animation: _controller,
      child: Text(widget.text, style: widget.style),
      curve: widget.curve,
    );
  }

  TextStyle _styleWithColor() {
    final color = widget.animation.colorAt(
      _controller,
      widget.curve ?? widget.animation.defaultCurve,
    );
    return switch (widget.animation) {
      FlowTokenAnimation.highlight =>
        (widget.style ?? const TextStyle()).copyWith(backgroundColor: color),
      FlowTokenAnimation.colorTransition =>
        (widget.style ?? const TextStyle()).copyWith(color: color),
      _ => widget.style ?? const TextStyle(),
    };
  }
}
