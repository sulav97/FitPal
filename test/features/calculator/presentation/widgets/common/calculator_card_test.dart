import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/features/calculator/presentation/widgets/common/calculator_card.dart';

void main() {
  testWidgets('CalculatorCard renders correctly with title and fields', (WidgetTester tester) async {
    // Define test data
    const String testTitle = 'Test Calculator';
    final List<Widget> testFields = [
      const TextField(decoration: InputDecoration(labelText: 'Field 1')),
      const TextField(decoration: InputDecoration(labelText: 'Field 2')),
    ];

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorCard(
            title: testTitle,
            fields: testFields,
          ),
        ),
      ),
    );

    // Verify the title is rendered
    expect(find.text(testTitle), findsOneWidget);

    // Verify the fields are rendered
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Field 1'), findsOneWidget);
    expect(find.text('Field 2'), findsOneWidget);

    // Verify the card is rendered
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('CalculatorCard handles empty fields list', (WidgetTester tester) async {
    // Define test data
    const String testTitle = 'Empty Calculator';
    final List<Widget> emptyFields = [];

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorCard(
            title: testTitle,
            fields: emptyFields,
          ),
        ),
      ),
    );

    // Verify the title is still rendered
    expect(find.text(testTitle), findsOneWidget);

    // Verify there are no fields
    expect(find.byType(TextField), findsNothing);

    // Verify the card is still rendered
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('CalculatorCard works with different types of widgets', (WidgetTester tester) async {
    // Define test data with different widget types
    const String testTitle = 'Mixed Widgets';
    final List<Widget> mixedWidgets = [
      const TextField(decoration: InputDecoration(labelText: 'Text Field')),
      const Text('Simple Text'),
      ElevatedButton(onPressed: () {}, child: const Text('Button')),
    ];

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorCard(
            title: testTitle,
            fields: mixedWidgets,
          ),
        ),
      ),
    );

    // Verify all different widgets are rendered
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Simple Text'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Button'), findsOneWidget);
  });
}
