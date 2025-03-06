import 'package:flutter/material.dart';

class CalorieCalculatorTab extends StatefulWidget {
  const CalorieCalculatorTab({super.key});

  @override
  _CalorieCalculatorTabState createState() => _CalorieCalculatorTabState();
}

class _CalorieCalculatorTabState extends State<CalorieCalculatorTab> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String selectedGender = "Male";
  String selectedActivity = "Sedentary";
  int? calorieResult;

  void calculateCalories() {
    final double? weight = double.tryParse(weightController.text);
    final double? height = double.tryParse(heightController.text);
    final int? age = int.tryParse(ageController.text);

    if (weight == null || height == null || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid numbers!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Calculate BMR (Basal Metabolic Rate)
    double bmr;
    if (selectedGender == "Male") {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    // Activity Level Multipliers
    final Map<String, double> activityMultipliers = {
      "Sedentary": 1.2,
      "Lightly Active": 1.375,
      "Moderate": 1.55,
      "Active": 1.725,
      "Very Active": 1.9,
    };

    final double calorieNeeds =
        bmr * (activityMultipliers[selectedActivity] ?? 1.2);

    setState(() {
      calorieResult = calorieNeeds.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Glassmorphic Card
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Calorie Calculator',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Weight TextField with Glass Effect
                    _GlassTextField(
                      controller: weightController,
                      label: 'Weight (kg)',
                      icon: Icons.line_weight,
                    ),

                    const SizedBox(height: 16),

                    // Height TextField with Glass Effect
                    _GlassTextField(
                      controller: heightController,
                      label: 'Height (cm)',
                      icon: Icons.height,
                    ),

                    const SizedBox(height: 16),

                    // Age TextField with Glass Effect
                    _GlassTextField(
                      controller: ageController,
                      label: 'Age',
                      icon: Icons.cake,
                    ),

                    const SizedBox(height: 16),

                    // Gender Dropdown with Glass Effect
                    _GlassDropdown(
                      label: 'Gender',
                      icon: Icons.person,
                      value: selectedGender,
                      items: const ['Male', 'Female'],
                      onChanged: (value) =>
                          setState(() => selectedGender = value ?? "Male"),
                    ),

                    const SizedBox(height: 16),

                    // Activity Level Dropdown with Glass Effect
                    _GlassDropdown(
                      label: 'Activity Level',
                      icon: Icons.directions_run,
                      value: selectedActivity,
                      items: const [
                        'Sedentary',
                        'Lightly Active',
                        'Moderate',
                        'Active',
                        'Very Active'
                      ],
                      onChanged: (value) => setState(
                          () => selectedActivity = value ?? "Sedentary"),
                    ),

                    const SizedBox(height: 20),

                    // Calculate Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: calculateCalories,
                      child: const Text(
                        'Calculate Calories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Calorie Result
                    if (calorieResult != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              Colors.lightGreenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.lightGreenAccent
                                .withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Estimated Calories Needed:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "$calorieResult kcal/day",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreenAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _GlassTextField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
    );
  }
}

class _GlassDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _GlassDropdown({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.tealAccent.withOpacity(0.2),
            Colors.cyanAccent.withOpacity(0.1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.tealAccent.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.grey[900],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        value: value,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        isExpanded: true,
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child:
                      Text(item, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
