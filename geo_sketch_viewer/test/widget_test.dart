import 'package:flutter_test/flutter_test.dart';

import 'package:geo_sketch_viewer/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GeoSketchApp());
    expect(find.text('GEO-SKETCH VIEWER'), findsOneWidget);
  });
}

