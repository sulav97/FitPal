import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker_app/features/workout/presentation/cubit/workout_cubit.dart';
import 'package:gym_tracker_app/features/workout/presentation/cubit/workout_state.dart';

class BodyPartDropdown extends StatefulWidget {
  final WorkOutState state;
  const BodyPartDropdown({super.key, required this.state});

  @override
  State<BodyPartDropdown> createState() => _BodyPartDropdownState();
}

class _BodyPartDropdownState extends State<BodyPartDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final List<String> items = widget.state.workOutBodyPartsList;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.grey[900],
        decoration: InputDecoration(
          labelText: 'Body Focus',
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.fitness_center, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        value: selectedValue,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        isExpanded: true,
        hint: const Text('Select Body Focus', style: TextStyle(color: Colors.white54)),
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
            context.read<WorkoutCubit>().filterBodyParts(value!);
          });
        },
      ),
    );
  }
}

class DifficultyDropdown extends StatefulWidget {
  final WorkOutState state;
  const DifficultyDropdown({super.key, required this.state});

  @override
  State<DifficultyDropdown> createState() => _DifficultyDropdownState();
}

class _DifficultyDropdownState extends State<DifficultyDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final List<String> items = widget.state.workOutLevelsList;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.tealAccent.withOpacity(0.2), Colors.cyanAccent.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.tealAccent.withOpacity(0.3),
          width: 1.5,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.tealAccent.withOpacity(0.3),
        //     blurRadius: 10,
        //     spreadRadius: 2,
        //   )
        // ],
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.grey[900],
        decoration: InputDecoration(
          labelText: 'Workout Intensity',
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.speed, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        value: selectedValue,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        isExpanded: true,
        hint: const Text('Select Intensity', style: TextStyle(color: Colors.white54)),
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
            context.read<WorkoutCubit>().filterDifficultyLevel(value!);
          });
        },
      ),
    );
  }
}
