import 'package:flutter/material.dart';
import 'Bottom_Screen/home_view.dart';
import 'Bottom_Screen/nutrition_view.dart';
import 'Bottom_Screen/profile_view.dart';
import 'Bottom_Screen/workout_view.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  int _selectedIndex = 0;

  // List of screens corresponding to each bottom navigation item
  final List<Widget> _screens = [
    const HomeView(),
    const WorkoutView(),
    const NutritionView(),
    const ProfileView(),
  ];

  // Function to handle item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Show the selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple, // Active icon color
        unselectedItemColor: Colors.grey, // Inactive icon color
        showUnselectedLabels: true, // Show labels for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Home icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), // Dumbbell for workouts
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu), // Food for nutrition
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profile icon
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
