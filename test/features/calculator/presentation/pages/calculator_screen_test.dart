import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/features/calculator/presentation/pages/calculator_screen.dart';
import 'package:gym_tracker_app/features/calculator/presentation/widgets/calorie_calculator.dart';
import 'package:gym_tracker_app/features/calculator/presentation/widgets/macro_calculator.dart';
import 'package:gym_tracker_app/features/calculator/presentation/widgets/one_rep_max_calculator.dart';
// Import any required dependencies

void main() {
  testWidgets('CalculatorScreen renders all tabs correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: CalculatorScreen()));

    // Allow animations to complete
    await tester.pumpAndSettle();

    // Verify app bar title
    expect(find.text('Fitness Calculators'), findsOneWidget);

    // Verify all three tabs exist
    expect(find.text('  Calories  '), findsOneWidget);
    expect(find.text('  Macros  '), findsOneWidget);
    expect(find.text(' 1-Rep Max '), findsOneWidget);

    // Test tab navigation
    // First tab should be visible initially
    expect(find.byType(CalorieCalculatorTab), findsOneWidget);

    // Tap on second tab and verify it appears
    await tester.tap(find.text('  Macros  '));
    await tester.pumpAndSettle();
    expect(find.byType(MacroCalculatorTab), findsOneWidget);

    // Tap on third tab and verify it appears
    await tester.tap(find.text(' 1-Rep Max '));
    await tester.pumpAndSettle();
    expect(find.byType(OneRepMaxCalculatorTab), findsOneWidget);
  });
}
