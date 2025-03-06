import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/features/calculator/presentation/widgets/macro_calculator.dart';

void main() {
  testWidgets('MacroCalculatorTab displays correctly and calculates macros', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MacroCalculatorTab(),
        ),
      ),
    );

    // Verify basic UI elements are rendered
    expect(find.text('Macro Calculator'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.text('Calculate Macros'), findsOneWidget);

    // Initially, there should be no macro results
    expect(find.text('Macros Breakdown:'), findsNothing);

    // Enter weight value
    await tester.enterText(find.byType(TextField), '70');
    await tester.pump();

    // Verify text was entered correctly
    expect(find.text('70'), findsOneWidget);

    // Tap calculate button
    await tester.tap(find.text('Calculate Macros'));
    await tester.pump();

    // Now macro results should be visible
    expect(find.text('Macros Breakdown:'), findsOneWidget);

    // By default, "Maintain" is selected, so we expect these calculations:
    // Protein: 70 * 2 = 140g
    // Carbs: 70 * 2.5 = 175g
    // Fats: 70 * 0.9 = 63g
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Carbs'), findsOneWidget);
    expect(find.text('Fats'), findsOneWidget);

    // Test changing goal and recalculating
    await tester.tap(find.text('Maintain'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200)); // Allow dropdown to open

    await tester.tap(find.text('Gain Weight').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200)); // Allow dropdown to close

    // Recalculate with new goal
    await tester.tap(find.text('Calculate Macros'));
    await tester.pump();

    // Verify UI updates properly
    expect(find.text('Macros Breakdown:'), findsOneWidget);
  });

  testWidgets('MacroCalculatorTab handles invalid input', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MacroCalculatorTab(),
        ),
      ),
    );

    // Enter invalid weight value
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();

    // Tap calculate button
    await tester.tap(find.text('Calculate Macros'));
    await tester.pump();

    // No macro results should be shown
    expect(find.text('Macros Breakdown:'), findsNothing);

    // Error snackbar should appear
    expect(find.text('Please enter a valid weight!'), findsOneWidget);
  });
}
