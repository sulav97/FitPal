import 'package:flutter/material.dart';

class MacroCalculatorTab extends StatefulWidget {
  const MacroCalculatorTab({super.key});

  @override
  _MacroCalculatorTabState createState() => _MacroCalculatorTabState();
}

class _MacroCalculatorTabState extends State<MacroCalculatorTab> {
  final TextEditingController weightController = TextEditingController();
  String selectedGoal = "Maintain";
  Map<String, double>? macroResult;

  /// **Macro Calculation based on Goal**
  void calculateMacros() {
    final double? weight = double.tryParse(weightController.text);

    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid weight!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, double> macros;
    if (selectedGoal == "Gain Weight") {
      macros = {
        "Protein": weight * 2.2,
        "Carbs": weight * 3,
        "Fats": weight * 1
      };
    } else if (selectedGoal == "Lose Weight") {
      macros = {
        "Protein": weight * 2.5,
        "Carbs": weight * 2,
        "Fats": weight * 0.8
      };
    } else {
      macros = {
        "Protein": weight * 2,
        "Carbs": weight * 2.5,
        "Fats": weight * 0.9
      };
    }

    setState(() {
      macroResult = macros;
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
                      'Macro Calculator',
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
                      child: TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon:
                              Icon(Icons.monitor_weight, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Goal Dropdown with Glass Effect
                    Container(
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
                        decoration: const InputDecoration(
                          labelText: 'Goal',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon:
                              Icon(Icons.fitness_center, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        value: selectedGoal,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        isExpanded: true,
                        items: ['Maintain', 'Lose Weight', 'Gain Weight']
                            .map((goal) => DropdownMenuItem(
                                  value: goal,
                                  child: Text(goal,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedGoal = value ?? "Maintain"),
                      ),
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
                      onPressed: calculateMacros,
                      child: const Text(
                        'Calculate Macros',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Macro Results
                    if (macroResult != null) ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Macros Breakdown:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      _MacroResultTile(
                        label: 'Protein',
                        value: macroResult!['Protein']!.toStringAsFixed(1),
                        color: Colors.redAccent,
                      ),
                      _MacroResultTile(
                        label: 'Carbs',
                        value: macroResult!['Carbs']!.toStringAsFixed(1),
                        color: Colors.lightBlueAccent,
                      ),
                      _MacroResultTile(
                        label: 'Fats',
                        value: macroResult!['Fats']!.toStringAsFixed(1),
                        color: Colors.blueAccent,
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

class _MacroResultTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroResultTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            '$value g/day',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
