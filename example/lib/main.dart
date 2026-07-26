import 'dart:async';

import 'package:flowtoken_flutter/flowtoken_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _message =
    'FlowToken brings gentle, token-by-token motion to streamed LLM text and '
    'Markdown in Flutter.';

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
  var _cursor = 0;

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
      setState(() => _cursor = _message.length);
      return;
    }
    _timer = Timer.periodic(const Duration(milliseconds: 36), (timer) {
      if (!mounted || _cursor >= _message.length) {
        timer.cancel();
        return;
      }
      setState(() {
        final next = _cursor + 3;
        _cursor = next > _message.length ? _message.length : next;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedText(
                content: _message.substring(0, _cursor),
                separator: FlowTokenSeparator.diff,
                animation: FlowTokenAnimation.fadeIn,
                alignment: WrapAlignment.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  height: 1.35,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 8,
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
  );
}
