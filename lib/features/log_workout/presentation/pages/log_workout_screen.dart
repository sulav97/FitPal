import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/log_workout/data/datasources/log_local_services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class LogWorkoutScreen extends StatefulWidget {
  const LogWorkoutScreen({super.key});

  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const WorkoutPage(),
    const CalendarPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.black],
          ),
        ),
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black87,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ... (Rest of the code remains the same until the WorkoutPage build method)
class WorkoutCategory {
  final String name;
  final String description;

  WorkoutCategory({required this.name, required this.description});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };

  factory WorkoutCategory.fromJson(Map<String, dynamic> json) {
    return WorkoutCategory(
      name: json['name'],
      description: json['description'],
    );
  }
}

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final int restTime; // in seconds
  final int currentRepMax;
  final int oneRepMax;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restTime,
    required this.currentRepMax,
    required this.oneRepMax,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'restTime': restTime,
        'currentRepMax': currentRepMax,
        'oneRepMax': oneRepMax,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight'],
      restTime: json['restTime'],
      currentRepMax: json['currentRepMax'],
      oneRepMax: json['oneRepMax'],
    );
  }
}

class Workout {
  final String date;
  final String category;
  final List<Exercise> exercises;

  Workout({
    required this.date,
    required this.category,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'category': category,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      date: json['date'],
      category: json['category'],
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // ... (Rest of the code remains the same until the build method)
  final StorageService _storageService = StorageService();
  final List<Exercise> _exercises = [];

  // Form controllers
  final _categoryNameController = TextEditingController();
  final _categoryDescriptionController = TextEditingController();
  final _exerciseNameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _restTimeController = TextEditingController();
  final _currentRepMaxController = TextEditingController();
  final _oneRepMaxController = TextEditingController();

  String? _selectedCategory;
  List<WorkoutCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _storageService.getCategories();
    setState(() {
      _categories = categories;
      if (categories.isNotEmpty) {
        _selectedCategory = categories.first.name;
      }
    });
  }

  void _addExercise() {
    if (_exerciseNameController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _restTimeController.text.isEmpty ||
        _currentRepMaxController.text.isEmpty ||
        _oneRepMaxController.text.isEmpty) {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all exercise fields')),
      );
      return;
    }

    final exercise = Exercise(
      name: _exerciseNameController.text,
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      weight: double.parse(_weightController.text),
      restTime: int.parse(_restTimeController.text),
      currentRepMax: int.parse(_currentRepMaxController.text),
      oneRepMax: int.parse(_oneRepMaxController.text),
    );

    setState(() {
      _exercises.add(exercise);
      // Clear form fields
      _exerciseNameController.clear();
      _setsController.clear();
      _repsController.clear();
      _weightController.clear();
      _restTimeController.clear();
      _currentRepMaxController.clear();
      _oneRepMaxController.clear();
    });
  }

  void _logWorkout() async {
    if (_exercises.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add exercises and select a category')),
      );
      return;
    }

    final now = DateTime.now();
    final dateFormatted = DateFormat('yyyy-MM-dd').format(now);

    final workout = Workout(
      date: dateFormatted,
      category: _selectedCategory!,
      exercises: List.from(_exercises),
    );

    await _storageService.saveWorkout(workout);

    setState(() {
      _exercises.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Workout logged for ${DateFormat('MMM dd yyyy').format(now)}')),
      );
    }
  }

  void _createCategory() async {
    if (_categoryNameController.text.isEmpty ||
        _categoryDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all category fields')),
      );
      return;
    }

    final category = WorkoutCategory(
      name: _categoryNameController.text,
      description: _categoryDescriptionController.text,
    );

    await _storageService.saveCategory(category);
    await _loadCategories();

    setState(() {
      _selectedCategory = category.name;
      _categoryNameController.clear();
      _categoryDescriptionController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category "${category.name}" created')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker',
            style: TextStyle(
              color: Colors.white70,
              // fontSize: 18,
              // fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.black],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.black.withOpacity(0.5),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create New Workout Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _categoryNameController,
                        decoration: const InputDecoration(
                          hintText: 'Category Name',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlueAccent),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _categoryDescriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlueAccent),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _createCategory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Create Category'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ... (Rest of the code remains the same)
              const SizedBox(height: 8),
              if (_categories.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Select Category',
                      labelStyle: TextStyle(color: Colors.white)),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
              Card(
                color: Colors.black87,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exercises',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _exerciseNameController,
                        decoration: const InputDecoration(
                            hintText: 'Exercise Name',
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              // fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _setsController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Sets',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _repsController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Reps',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Weight',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _restTimeController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Rest Time (seconds)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _currentRepMaxController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Current Rep Max',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _oneRepMaxController,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  // fontSize: 18,
                                  // fontWeight: FontWeight.bold,
                                ),
                                hintText: 'One Rep Max',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            color: Colors.white,
                            child: const Text(
                              'LBS',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Exercise',
                              style: TextStyle(
                                color: Colors.white70,
                                // fontSize: 18,
                                // fontWeight: FontWeight.bold,
                              )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 12, 80, 14),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Display added exercises
              if (_exercises.isNotEmpty) ...[
                const Text(
                  'Added Exercises:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(_exercises.length, (index) {
                  final exercise = _exercises[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                          '${exercise.sets} sets × ${exercise.reps} reps × ${exercise.weight} lbs'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _exercises.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _logWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Log Workout for ${DateFormat('MMM dd yyyy').format(DateTime.now())}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
// }

// ... (Rest of the code remains the same)
  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryDescriptionController.dispose();
    _exerciseNameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _restTimeController.dispose();
    _currentRepMaxController.dispose();
    _oneRepMaxController.dispose();
    super.dispose();
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final StorageService _storageService = StorageService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Workout> _selectedWorkouts = [];
  Map<DateTime, List<Workout>> _workoutMap = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await _storageService.getWorkouts();

    Map<DateTime, List<Workout>> workoutMap = {};

    for (var workout in workouts) {
      final date = DateFormat('yyyy-MM-dd').parse(workout.date);
      if (workoutMap[date] == null) {
        workoutMap[date] = [];
      }
      workoutMap[date]!.add(workout);
    }

    setState(() {
      _workoutMap = workoutMap;
      _updateSelectedDayWorkouts();
    });
  }

  void _updateSelectedDayWorkouts() {
    if (_selectedDay == null) return;

    final selectedDate =
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    setState(() {
      _selectedWorkouts = _workoutMap[selectedDate] ?? [];
    });
  }
  // ... (Rest of the code remains the same until the build method)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Calendar',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.black],
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return _workoutMap[DateTime(day.year, day.month, day.day)] ??
                    [];
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _updateSelectedDayWorkouts();
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                markerDecoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: _selectedWorkouts.isEmpty
                  ? const Center(
                      child: Text('No workouts for selected day',
                          style: TextStyle(
                            color: Colors.white,
                            // fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          )),
                    )
                  : ListView.builder(
                      itemCount: _selectedWorkouts.length,
                      itemBuilder: (context, index) {
                        final workout = _selectedWorkouts[index];
                        return Card(
                          color: Colors.black.withOpacity(0.5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout.category,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...workout.exercises.map((exercise) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exercise.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${exercise.sets} sets × ${exercise.reps} reps × ${exercise.weight} lbs',
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          'Rest: ${exercise.restTime}s | 1RM: ${exercise.oneRepMax} lbs',
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
