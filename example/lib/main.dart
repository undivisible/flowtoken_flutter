import 'dart:async';
import 'dart:math';

import 'package:flowtoken_flutter/flowtoken_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _message =
    'FlowToken is a Flutter library for the moment an LLM reply becomes '
    'visible: each arriving word settles into place instead of flashing, '
    'jumping, or forcing the reader to wait for a completed message. It keeps '
    'live responses calm and legible while the model is still thinking, works '
    'with plain text and Markdown, and gives streaming interfaces the kind of '
    'deliberate motion that makes a conversation feel continuous rather than '
    'assembled in fragments.';

final _streamTokens = RegExp(
  r'\S+\s*',
).allMatches(_message).map((match) => match.group(0)!).toList(growable: false);

void main() => runApp(const FlowTokenDemo());

class FlowTokenDemo extends StatelessWidget {
  const FlowTokenDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'FlowToken Flutter',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
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
  final _random = Random();
  Timer? _timer;
  var _baseLatencyMilliseconds = 100;
  var _tokenCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _stream();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stream() {
    if (MediaQuery.disableAnimationsOf(context)) {
      setState(() => _tokenCount = _streamTokens.length);
      return;
    }
    _streamNextToken();
  }

  void _streamNextToken() {
    if (!mounted || _tokenCount >= _streamTokens.length) return;
    final delay = _baseLatencyMilliseconds + _random.nextInt(11);
    _timer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() {
        _tokenCount++;
        if (_tokenCount % 10 == 0 && _random.nextBool()) {
          _baseLatencyMilliseconds += 20;
        }
      });
      _streamNextToken();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 72, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedText(
                    content: _streamTokens.take(_tokenCount).join(),
                    separator: FlowTokenSeparator.diff,
                    animation: FlowTokenAnimation.fadeIn,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 4,
                    children: [
                      TextButton(
                        onPressed: () => launchUrl(
                          Uri.parse(
                            'https://github.com/undivisible/flowtoken_flutter',
                          ),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: const Text('GitHub'),
                      ),
                      TextButton(
                        onPressed: () => launchUrl(
                          Uri.parse('https://undivisible.dev'),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: const Text('undivisible.dev'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
