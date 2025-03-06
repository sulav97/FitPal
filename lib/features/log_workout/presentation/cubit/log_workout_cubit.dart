import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'log_workout_state.dart';

class LogWorkoutCubit extends Cubit<LogWorkoutState> {
  LogWorkoutCubit() : super(LogWorkoutInitial());
}
