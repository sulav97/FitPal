import 'package:flutter/material.dart';

class NutritionView extends StatelessWidget {
  const NutritionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Plan your meals and track nutrition here!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
