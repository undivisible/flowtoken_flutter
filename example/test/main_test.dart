import 'package:flowtoken_flutter/flowtoken_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowtoken_flutter_example/main.dart';

void main() {
  testWidgets('streams one paragraph and keeps the completed text stable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FlowTokenDemo());
    await tester.pump();

    expect(find.byType(AnimatedText), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('undivisible.dev'), findsOneWidget);

    for (var index = 0; index < 100; index++) {
      await tester.pump(const Duration(milliseconds: 32));
    }

    expect(find.text('FlowToken '), findsOneWidget);
    expect(find.text('fragments.'), findsOneWidget);
    expect(
      tester
          .widgetList<Text>(find.byType(Text))
          .where((text) => text.data == 'FlowToken ')
          .single
          .softWrap,
      isFalse,
    );
    final completedText = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .whereType<String>()
        .toList();

    await tester.pump(const Duration(seconds: 1));

    expect(
      tester
          .widgetList<Text>(find.byType(Text))
          .map((text) => text.data)
          .whereType<String>()
          .toList(),
      completedText,
    );
    expect(tester.takeException(), isNull);
  });
}
