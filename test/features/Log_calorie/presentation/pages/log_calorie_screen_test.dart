import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/features/Log_calorie/presentation/pages/log_calorie_screen.dart';

void main() {
  testWidgets('NutritionTrackerTab calculates calories correctly', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(home: NutritionTrackerTab()));

    // Enter test values
    await tester.enterText(find.byType(TextField).at(0), '30'); // Protein
    await tester.enterText(find.byType(TextField).at(1), '50'); // Carbs
    await tester.enterText(find.byType(TextField).at(2), '15'); // Fats

    // Tap calculate button
    await tester.tap(find.byType(ElevatedButton));

    // Allow the widget to rebuild
    await tester.pumpAndSettle();

    // Check for the total calories text
    expect(find.text('Total Calories: 455 kcal'), findsOneWidget);

    // Check for macronutrient values - looking at the actual widget structure
    expect(find.text('Protein:'), findsOneWidget);
    expect(find.text('30.0 g'), findsOneWidget);
    expect(find.text('Carbs:'), findsOneWidget);
    expect(find.text('50.0 g'), findsOneWidget);
    expect(find.text('Fats:'), findsOneWidget);
    expect(find.text('15.0 g'), findsOneWidget);
  });
}
