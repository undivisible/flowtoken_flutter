import 'package:flowtoken_flutter/flowtoken_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowtoken_flutter_example/main.dart';

void main() {
  testWidgets('shows the streaming and completed examples', (tester) async {
    await tester.pumpWidget(const FlowTokenDemo());

    expect(find.text('FlowToken Flutter'), findsOneWidget);
    expect(find.text('Streaming response'), findsOneWidget);
    expect(find.byType(AnimatedText), findsOneWidget);
    expect(find.byType(AnimatedMarkdown), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
