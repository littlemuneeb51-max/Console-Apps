import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_paint_palettes/main.dart';

void main() {
  testWidgets('App launch and splash screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the splash screen title is displayed
    expect(find.text('House Paint Palettes'), findsOneWidget);
    expect(find.text('ARCHITECTURAL COLOR PALETTES'), findsOneWidget);

    // Verify that the paint roller icon is present
    expect(find.byIcon(Icons.format_paint_rounded), findsOneWidget);
  });
}
