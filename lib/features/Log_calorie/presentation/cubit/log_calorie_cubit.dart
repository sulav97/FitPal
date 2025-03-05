import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'log_calorie_state.dart';

class LogCalorieCubit extends Cubit<LogCalorieState> {
  LogCalorieCubit() : super(LogCalorieInitial());
}
