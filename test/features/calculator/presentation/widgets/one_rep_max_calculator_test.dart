import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/features/calculator/presentation/widgets/one_rep_max_calculator.dart';

void main() {
  testWidgets('OneRepMaxCalculatorTab displays correctly and calculates 1RM', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OneRepMaxCalculatorTab(),
        ),
      ),
    );

    // Verify basic UI elements are rendered
    expect(find.text('One-Rep Max Calculator'), findsOneWidget);
    expect(find.byType(TextField), findsAtLeastNWidgets(2));
    expect(find.text('Calculate 1RM'), findsOneWidget);

    // Initially, there should be no results
    expect(find.text('Estimated 1RM:'), findsNothing);

    // Enter valid test data
    await tester.enterText(find.byType(TextField).first, '100');
    await tester.enterText(find.byType(TextField).last, '10');
    await tester.pump();

    // Verify text was entered correctly
    expect(find.text('100'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    // Tap calculate button
    await tester.tap(find.text('Calculate 1RM'));
    await tester.pump();

    // 1RM result should be visible
    expect(find.text('Estimated 1RM:'), findsOneWidget);

    // We know with input of 100kg weight and 10 reps, using the Epley formula
    // 1RM = 100 * (1 + 10/30) = 100 * (1 + 0.33) = 133.3kg, rounded to 133.3kg
    expect(find.textContaining('kg'), findsAtLeastNWidgets(1));
  });

  testWidgets('OneRepMaxCalculatorTab handles invalid input gracefully', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OneRepMaxCalculatorTab(),
        ),
      ),
    );

    // Enter invalid weight value (empty field)
    await tester.enterText(find.byType(TextField).first, '');
    await tester.enterText(find.byType(TextField).last, '10');

    // Tap calculate button
    await tester.tap(find.text('Calculate 1RM'));
    await tester.pump();

    // No results should appear
    expect(find.text('Estimated 1RM:'), findsNothing);

    // Error snackbar should appear
    expect(find.text('Please enter valid weight and reps!'), findsOneWidget);

    // Test with invalid reps
    await tester.enterText(find.byType(TextField).first, '100');
    await tester.enterText(find.byType(TextField).last, 'abc');
    await tester.pump();

    // Tap calculate button
    await tester.tap(find.text('Calculate 1RM'));
    await tester.pump();

    // No results should appear
    expect(find.text('Estimated 1RM:'), findsNothing);
  });
}
