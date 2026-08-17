import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_unit_converter/main.dart';

void main() {
  testWidgets('Unit Converter App builds and has tabs', (WidgetTester tester) async {
    // Build the home screen directly to bypass the splash screen timer in test
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: ConverterHomeScreen(toggleTheme: () {}),
      ),
    );

    // Verify app bar title
    expect(find.text('Mini Unit Converter'), findsOneWidget);
    expect(find.text('Construction & Land Mapping'), findsOneWidget);

    // Verify Tab Bar items are present
    expect(find.text('Land Area'), findsOneWidget);
    expect(find.text('Length'), findsOneWidget);
  });

  testWidgets('Land Area conversion verification (Kanal to Square Feet)', (WidgetTester tester) async {
    // Increase physical size to fit everything
    tester.view.physicalSize = const Size(1200, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(
          body: UnitConverterBody(category: ConversionCategory.area),
        ),
      ),
    );

    // Find TextField and Dropdowns
    final textFieldFinder = find.byType(TextField).first;

    // Enter value '2'
    await tester.enterText(textFieldFinder, '2');
    await tester.pump();

    // The default FROM unit is Marla and TO unit is Square Feet.
    // 2 Marla * 225 = 450 Sq Ft.
    expect(find.text('450'), findsOneWidget);

    // Swap units preset check
    // Press '1 Kanal' preset chip
    final chipFinder = find.text('1 Kanal (20 Marla)');
    expect(chipFinder, findsOneWidget);
    await tester.ensureVisible(chipFinder);
    await tester.tap(chipFinder);
    await tester.pump();

    // 1 Kanal * 4500 = 4500 Sq Ft.
    expect(find.text('4500'), findsOneWidget);
  });

  testWidgets('Length conversion verification (Feet to Meters)', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(
          body: UnitConverterBody(category: ConversionCategory.length),
        ),
      ),
    );

    final textFieldFinder = find.byType(TextField).first;
    await tester.enterText(textFieldFinder, '10');
    await tester.pump();

    // Default FROM is Feet, TO is Meters.
    // 10 Feet / 3.280839895 = 3.048 Meters.
    // In the real-time result box: displayResult = 3.048 (after trimming trailing zeros).
    expect(find.text('3.048'), findsOneWidget);
  });

  testWidgets('Saved Calculations CRUD operations (Save, Edit label, Delete)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const Scaffold(
          body: UnitConverterBody(category: ConversionCategory.area),
        ),
      ),
    );

    // Enter a number in TextField
    final textFields = find.byType(TextField);
    // There are multiple TextFields now: 1 for input, 1 for optional label in result card
    // The first one is the value input field.
    await tester.enterText(textFields.first, '10');
    await tester.pump();

    // 10 Marla -> 2250 Sq Ft.
    expect(find.text('2250'), findsOneWidget);

    // Type a custom label in the second TextField (tag)
    await tester.enterText(textFields.at(1), 'North boundary');
    await tester.pump();

    // Tap "SAVE TO HISTORY"
    final saveButton = find.text('SAVE TO HISTORY');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify it appears in the history list
    expect(find.text('North boundary'), findsOneWidget);
    expect(find.text('10 Marla = 2250 Square Feet'), findsOneWidget);

    // Tap the edit button
    final editButton = find.byIcon(Icons.edit_outlined);
    expect(editButton, findsOneWidget);
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // Wait for Dialog to animate open

    // Enter new description in dialog
    final dialogTextField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dialogTextField, 'South boundary');
    await tester.pump();

    // Tap SAVE in Dialog
    final dialogSaveButton = find.text('SAVE');
    await tester.tap(dialogSaveButton);
    await tester.pumpAndSettle();

    // Verify description is updated to 'South boundary'
    expect(find.text('South boundary'), findsOneWidget);
    expect(find.text('North boundary'), findsNothing);

    // Tap delete button to remove it
    final deleteButton = find.byIcon(Icons.delete_outline);
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Verify history is empty
    expect(find.text('South boundary'), findsNothing);
  });
}
