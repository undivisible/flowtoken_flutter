import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowtoken_flutter_example/main.dart';

void main() {
  testWidgets('shows the streaming message and links', (tester) async {
    await tester.pumpWidget(const FlowTokenDemo());

    expect(find.byType(AnimatedText), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('undivisible.dev'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
