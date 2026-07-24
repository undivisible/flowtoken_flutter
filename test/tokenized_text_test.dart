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
