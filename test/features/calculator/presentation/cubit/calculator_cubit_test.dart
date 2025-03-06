import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/features/calculator/presentation/cubit/calculator_cubit.dart';

void main() {
  group('CalculatorCubit', () {
    late CalculatorCubit calculatorCubit;

    setUp(() {
      calculatorCubit = CalculatorCubit();
    });

    test('initial state should be CalculatorInitial', () {
      expect(calculatorCubit.state, isA<CalculatorInitial>());
    });

    tearDown(() {
      calculatorCubit.close();
    });
  });
}
