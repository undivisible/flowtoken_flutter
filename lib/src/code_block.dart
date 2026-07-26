import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animations.dart';
import 'separator.dart';
import 'tokenized_text.dart';

class FlowTokenCodeBlock extends StatefulWidget {
  const FlowTokenCodeBlock({
    required this.language,
    required this.code,
    this.style,
    this.animation,
    this.duration,
    this.curve,
    this.animationIterationCount = 1,
    super.key,
  });

  final String language;
  final String code;
  final TextStyle? style;
  final FlowTokenAnimation? animation;
  final Duration? duration;
  final Curve? curve;
  final int animationIterationCount;

  @override
  State<FlowTokenCodeBlock> createState() => _FlowTokenCodeBlockState();
}

class _FlowTokenCodeBlockState extends State<FlowTokenCodeBlock> {
  var _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.language),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _copy,
                    icon: Icon(_copied ? Icons.check : Icons.copy, size: 16),
                    label: Text(_copied ? 'Copied!' : 'Copy code'),
                  ),
                ],
              ),
              if (widget.animation == null)
                SelectableText(
                  widget.code,
                  style:
                      widget.style ?? const TextStyle(fontFamily: 'monospace'),
                )
              else
                TokenizedText(
                  text: widget.code,
                  separator: FlowTokenSeparator.word,
                  animation: widget.animation!,
                  duration: widget.duration,
                  curve: widget.curve,
                  animationIterationCount: widget.animationIterationCount,
                  style:
                      widget.style ?? const TextStyle(fontFamily: 'monospace'),
                ),
            ],
          ),
        ),
      );
}
