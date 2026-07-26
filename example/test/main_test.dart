import 'package:flowtoken_flutter/flowtoken_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowtoken_flutter_example/main.dart';

void main() {
  testWidgets('shows the streaming message and links', (tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FlowTokenDemo());
    await tester.pump(const Duration(milliseconds: 180));

    expect(find.byType(AnimatedText), findsOneWidget);
    expect(find.text('FlowToken '), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('undivisible.dev'), findsOneWidget);
    expect(
      tester
          .widgetList<Text>(find.byType(Text))
          .where((text) => text.data == 'FlowToken ')
          .single
          .softWrap,
      isFalse,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
  });
}
