import 'dart:async';

import 'package:flowtoken_flutter/flowtoken_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _message =
    'Max Carter makes things for people—compilers, runtimes, operating '
    'systems, and native tools that make complicated systems feel direct. '
    'FlowToken Flutter is a Flutter port of Ephibbs’ original FlowToken: a '
    'small text visualization library for turning live LLM output into '
    'something calm, readable, and continuous while it is still arriving.';

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
  Timer? _timer;
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
    _timer = Timer(const Duration(milliseconds: 32), () {
      if (!mounted) return;
      setState(() => _tokenCount++);
      _streamNextToken();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedText(
                        content: _streamTokens.take(_tokenCount).join(),
                        separator: FlowTokenSeparator.diff,
                        animation: FlowTokenAnimation.fadeIn,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
      ),
    ),
  );
}
