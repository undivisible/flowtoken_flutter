import 'dart:async';

import 'package:flowtoken_flutter/flowtoken_flutter.dart';
import 'package:flutter/material.dart';

const _streamReply =
    'FlowToken reveals incoming text one token at a time, so streamed replies '
    'stay readable without waiting for the full response. Every new token gets '
    'the exact reveal treatment you choose.';

const _completedReply = '''## Completed markdown

Use `AnimatedMarkdown` for finished messages and keep the same visual language.

- Markdown renders normally
- Links remain interactive
- Streaming stays lightweight

```dart
AnimatedMarkdown(content: buffer, animation: FlowTokenAnimation.wave)
```''';

void main() => runApp(const FlowTokenDemo());

class FlowTokenDemo extends StatelessWidget {
  const FlowTokenDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'FlowToken Flutter',
    theme: ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff79e0ff),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xff0b0d10),
      useMaterial3: true,
    ),
    home: const FlowTokenDemoPage(),
  );
}

class FlowTokenDemoPage extends StatefulWidget {
  const FlowTokenDemoPage({super.key});

  @override
  State<FlowTokenDemoPage> createState() => _FlowTokenDemoPageState();
}

class _FlowTokenDemoPageState extends State<FlowTokenDemoPage> {
  Timer? _timer;
  var _cursor = 0;
  var _streaming = false;
  var _animation = FlowTokenAnimation.blurAndSharpen;
  var _separator = FlowTokenSeparator.diff;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _replay();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _replay() {
    _timer?.cancel();
    if (MediaQuery.disableAnimationsOf(context)) {
      setState(() {
        _cursor = _streamReply.length;
        _streaming = false;
      });
      return;
    }
    setState(() {
      _cursor = 0;
      _streaming = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (!mounted || _cursor >= _streamReply.length) {
        timer.cancel();
        if (mounted) setState(() => _streaming = false);
        return;
      }
      setState(() {
        final next = _cursor + 3;
        _cursor = next > _streamReply.length ? _streamReply.length : next;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final content = _streamReply.substring(0, _cursor);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('FlowToken Flutter', style: textTheme.displaySmall),
                const SizedBox(height: 8),
                Text(
                  'Faithful Flutter motion for streamed LLM text and markdown.',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 32),
                _DemoCard(
                  title: 'Controls',
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      DropdownButton<FlowTokenAnimation>(
                        value: _animation,
                        items: [
                          for (final animation in FlowTokenAnimation.values)
                            DropdownMenuItem(
                              value: animation,
                              child: Text(animation.name),
                            ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _animation = value);
                          _replay();
                        },
                      ),
                      DropdownButton<FlowTokenSeparator>(
                        value: _separator,
                        items: [
                          for (final separator in FlowTokenSeparator.values)
                            DropdownMenuItem(
                              value: separator,
                              child: Text(separator.name),
                            ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _separator = value);
                          _replay();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _DemoCard(
                  title: 'Streaming response',
                  trailing: FilledButton.icon(
                    onPressed: _replay,
                    icon: const Icon(Icons.replay),
                    label: const Text('Replay'),
                  ),
                  child: AnimatedText(
                    content: content,
                    separator: _separator,
                    animation: _streaming ? _animation : null,
                    style: textTheme.titleMedium?.copyWith(height: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
                _DemoCard(
                  title: 'Completed response',
                  child: const AnimatedMarkdown(
                    content: _completedReply,
                    animation: null,
                  ),
                ),
                const SizedBox(height: 24),
                Text('Every upstream animation', style: textTheme.titleSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final animation in FlowTokenAnimation.values)
                      _AnimationChip(animation: animation),
                  ],
                ),
                const SizedBox(height: 24),
                SelectableText(
                  'AnimatedText(content: buffer, separator: '
                  'FlowTokenSeparator.diff, animation: FlowTokenAnimation.$_animation)',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimationChip extends StatelessWidget {
  const _AnimationChip({required this.animation});

  final FlowTokenAnimation animation;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xff15191e),
      border: Border.all(color: Colors.white12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: AnimatedText(
        content: animation.name,
        separator: FlowTokenSeparator.word,
        animation: animation,
        animationIterationCount: switch (animation) {
          FlowTokenAnimation.bounceIn ||
          FlowTokenAnimation.elastic ||
          FlowTokenAnimation.wave => 3,
          _ => 1,
        },
      ),
    ),
  );
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xff15191e),
      border: Border.all(color: Colors.white12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    ),
  );
}
