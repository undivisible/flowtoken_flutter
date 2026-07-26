import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowtoken_flutter/flowtoken_flutter.dart';

void main() {
  testWidgets('diff mode only animates appended suffix', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _DiffHarness(initial: 'Hello'),
        ),
      ),
    );
    expect(find.text('Hello'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: _DiffHarness(initial: 'Hello world'),
        ),
      ),
    );
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text(' world'), findsOneWidget);
  });

  testWidgets('supports every upstream animation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            children: [
              for (final animation in FlowTokenAnimation.values)
                AnimatedText(content: animation.name, animation: animation),
            ],
          ),
        ),
      ),
    );

    expect(FlowTokenAnimation.values, hasLength(14));
    expect(find.text('wave'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}

class _DiffHarness extends StatelessWidget {
  const _DiffHarness({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return AnimatedText(
      content: initial,
      separator: FlowTokenSeparator.diff,
      animation: FlowTokenAnimation.fadeIn,
    );
  }
}
