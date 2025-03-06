import 'dart:convert';

import 'package:gym_tracker_app/features/log_workout/presentation/pages/log_workout_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String categoriesKey = 'workout_categories';
  static const String workoutsKey = 'workouts';

  Future<List<WorkoutCategory>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? categoriesJson = prefs.getString(categoriesKey);
    if (categoriesJson == null) {
      return [];
    }
    final List<dynamic> decoded = jsonDecode(categoriesJson);
    return decoded.map((item) => WorkoutCategory.fromJson(item)).toList();
  }

  // Future<void> saveCategory(WorkoutCategory category) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final categories = await getCategories();
  //   categories.add(category);
  //   await prefs.setString(categoriesKey, jsonEncode(categories.map((e) => e.toJson()).toList()));
  // }
  Future<void> saveCategory(WorkoutCategory category) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getCategories();

    // Check if category already exists
    if (!categories.any((c) => c.name == category.name)) {
      categories.add(category);
      await prefs.setString(categoriesKey, jsonEncode(categories.map((e) => e.toJson()).toList()));
    }
  }

  Future<List<Workout>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? workoutsJson = prefs.getString(workoutsKey);
    if (workoutsJson == null) {
      return [];
    }
    final List<dynamic> decoded = jsonDecode(workoutsJson);
    return decoded.map((item) => Workout.fromJson(item)).toList();
  }

  // Future<void> saveWorkout(Workout workout) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final workouts = await getWorkouts();
  //   workouts.add(workout);
  //   await prefs.setString(workoutsKey, jsonEncode(workouts.map((e) => e.toJson()).toList()));
  // }
  Future<void> saveWorkout(Workout workout) async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = await getWorkouts();

    // Check if workout already exists (based on date and category)
    // if (!workouts.any((w) => w.date == workout.date && w.category == workout.category)) {
    workouts.add(workout);
    await prefs.setString(workoutsKey, jsonEncode(workouts.map((e) => e.toJson()).toList()));
    // }
  }

  Future<List<Workout>> getWorkoutsByDate(String date) async {
    final workouts = await getWorkouts();
    return workouts.where((workout) => workout.date == date).toList();
  }
}
