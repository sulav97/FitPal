import 'package:flutter/material.dart';

class NutritionTrackerTab extends StatefulWidget {
  const NutritionTrackerTab({super.key});

  @override
  _NutritionTrackerTabState createState() => _NutritionTrackerTabState();
}

class _NutritionTrackerTabState extends State<NutritionTrackerTab> {
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();

  double totalCalories = 0;
  Map<String, double> macronutrients = {
    'Protein': 0,
    'Carbs': 0,
    'Fats': 0,
  };

  void calculateNutrition() {
    final double? protein = double.tryParse(proteinController.text);
    final double? carbs = double.tryParse(carbsController.text);
    final double? fats = double.tryParse(fatsController.text);

    if (protein == null || carbs == null || fats == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid nutritional values!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      macronutrients['Protein'] = protein;
      macronutrients['Carbs'] = carbs;
      macronutrients['Fats'] = fats;

      // Standard macro calorie calculations
      totalCalories = (protein * 4) + (carbs * 4) + (fats * 9);
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
                    colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
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
                      'Calculate Nutrition',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Protein TextField with Glass Effect
                    _GlassTextField(
                      controller: proteinController,
                      label: 'Protein (g)',
                      icon: Icons.set_meal,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // Carbs TextField with Glass Effect
                    _GlassTextField(
                      controller: carbsController,
                      label: 'Carbs (g)',
                      icon: Icons.bakery_dining,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // Fats TextField with Glass Effect
                    _GlassTextField(
                      controller: fatsController,
                      label: 'Fats (g)',
                      icon: Icons.oil_barrel,
                      keyboardType: TextInputType.number,
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
                      onPressed: calculateNutrition,
                      child: const Text(
                        'Calculate Nutrition',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Nutrition Result
                    if (totalCalories > 0) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.tealAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.tealAccent.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Nutritional Breakdown:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Total Calories: ${totalCalories.toStringAsFixed(0)} kcal",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...macronutrients.entries.map((entry) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${entry.key}:',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                      Text(
                                        '${entry.value.toStringAsFixed(1)} g',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )),
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
  final TextInputType keyboardType;

  const _GlassTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
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
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
    );
  }
}
