import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class LogCalorieScreen extends StatelessWidget {
  const LogCalorieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Log Nutrition ',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent.withOpacity(0.7),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const NutritionHomePage(),
    );
  }
}

class NutritionEntry {
  final DateTime date;
  final double protein;
  final double carbs;
  final double fat;
  final double totalCalories;

  NutritionEntry({
    required this.date,
    required this.protein,
    required this.carbs,
    required this.fat,
  }) : totalCalories = (protein * 4) + (carbs * 4) + (fat * 9);

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

  factory NutritionEntry.fromJson(Map<String, dynamic> json) => NutritionEntry(
        date: DateTime.parse(json['date']),
        protein: json['protein'],
        carbs: json['carbs'],
        fat: json['fat'],
      );
}

class NutritionStorageService {
  static const String _storageKey = 'nutrition_entries';

  Future<List<NutritionEntry>> getNutritionEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_storageKey) ?? [];
    return entriesJson
        .map((entry) => NutritionEntry.fromJson(json.decode(entry)))
        .toList();
  }

  Future<void> saveNutritionEntry(NutritionEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getNutritionEntries();

    // Remove existing entry for the same date if exists
    entries.removeWhere((e) =>
        e.date.year == entry.date.year &&
        e.date.month == entry.date.month &&
        e.date.day == entry.date.day);

    entries.add(entry);
    final entriesJson = entries.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, entriesJson);
  }

  Future<NutritionEntry?> getEntryForDate(DateTime date) async {
    final entries = await getNutritionEntries();
    try {
      return entries.firstWhere((entry) =>
          entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day);
    } catch (e) {
      return null;
    }
  }
}

class NutritionHomePage extends StatefulWidget {
  const NutritionHomePage({super.key});

  @override
  _NutritionHomePageState createState() => _NutritionHomePageState();
}

class _NutritionHomePageState extends State<NutritionHomePage> {
  final NutritionStorageService _storageService = NutritionStorageService();

  // Form Controllers
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  // Calendar Variables
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Tracked Entries
  Map<DateTime, List<NutritionEntry>> _nutritionMap = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadNutritionEntries();
  }

  Future<void> _loadNutritionEntries() async {
    final entries = await _storageService.getNutritionEntries();

    Map<DateTime, List<NutritionEntry>> nutritionMap = {};

    for (var entry in entries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (nutritionMap[date] == null) {
        nutritionMap[date] = [];
      }
      nutritionMap[date]!.add(entry);
    }

    setState(() {
      _nutritionMap = nutritionMap;
    });
  }

  void _logNutrition() async {
    // Validate inputs
    if (_proteinController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _fatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Create nutrition entry
    final entry = NutritionEntry(
      date: _selectedDay ?? DateTime.now(),
      protein: double.parse(_proteinController.text),
      carbs: double.parse(_carbsController.text),
      fat: double.parse(_fatController.text),
    );

    // Save entry
    await _storageService.saveNutritionEntry(entry);

    // Reload entries and update UI
    await _loadNutritionEntries();

    // Clear controllers
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Nutrition logged for ${DateFormat('MMM dd, yyyy').format(_selectedDay!)}',
        ),
      ),
    );
  }

  Widget _buildNutritionDetailCard(NutritionEntry entry) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.tealAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildNutrientRow('Protein', entry.protein, Colors.redAccent),
          _buildNutrientRow('Carbs', entry.carbs, Colors.lightBlueAccent),
          _buildNutrientRow('Fat', entry.fat, Colors.blueAccent),
          const Divider(color: Colors.white30),
          Text(
            'Total Calories: ${entry.totalCalories.toStringAsFixed(0)}',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String nutrient, double value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nutrient,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          Text('${value.toStringAsFixed(1)} g'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracker'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Glassmorphic Container for Calendar and Input
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Calendar
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
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
                        todayDecoration: BoxDecoration(
                          color: Colors.tealAccent.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: Colors.tealAccent,
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: const TextStyle(color: Colors.white),
                        weekendTextStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                    const Divider(color: Colors.white30),

                    // Nutrition Input Fields
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _proteinController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Protein (g)',
                              labelStyle: TextStyle(color: Colors.white70),
                              prefixIcon: Icon(Icons.fitness_center,
                                  color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                            ),
                          ),
                          const Divider(color: Colors.white30),
                          TextField(
                            controller: _carbsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Carbs (g)',
                              labelStyle: TextStyle(color: Colors.white70),
                              prefixIcon:
                                  Icon(Icons.grain, color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                            ),
                          ),
                          const Divider(color: Colors.white30),
                          TextField(
                            controller: _fatController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Fat (g)',
                              labelStyle: TextStyle(color: Colors.white70),
                              prefixIcon:
                                  Icon(Icons.lunch_dining, color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _logNutrition,
                      child: const Text('   Log Nutrition   '),
                    ),
                  ],
                ),
              ),

              // Nutrition Details for Selected Day
              FutureBuilder<NutritionEntry?>(
                future: _storageService.getEntryForDate(_selectedDay!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data == null) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: Text(
                          'No nutrition data for this day',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return _buildNutritionDetailCard(snapshot.data!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _prot

  @override
  void dispose() {
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }
}
