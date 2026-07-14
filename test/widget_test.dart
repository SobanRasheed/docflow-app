// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docflow/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We wrap DocFlowApp in ProviderScope because it uses Riverpod.
    await tester.pumpWidget(
      const ProviderScope(
        child: DocFlowApp(),
      ),
    );

    // Verify that the app builds without crashing.
    expect(find.byType(DocFlowApp), findsOneWidget);
  });
}
