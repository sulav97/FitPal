import 'package:flutter/material.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        centerTitle: true,
        toolbarHeight: 35,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Text(
              "Let's Get Moving!",
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Track your workouts and progress here.",
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: size.height * 0.03),
            // Workout Exercise List
            Text(
              "Exercises",
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            _buildWorkoutCard(context, "Push-Up", "3 sets of 15 reps", Icons.fitness_center, Colors.orange.shade100),
            SizedBox(height: size.height * 0.02),
            _buildWorkoutCard(context, "Pull-Up", "3 sets of 8 reps", Icons.fitness_center, Colors.green.shade100),
            SizedBox(height: size.height * 0.02),
            _buildWorkoutCard(context, "Squat", "4 sets of 20 reps", Icons.directions_run, Colors.blue.shade100),
            SizedBox(height: size.height * 0.03),
            // Progress Tracking
            Text(
              "Your Progress",
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            _buildProgressCard(context, "Push-Up Progress", 0.8, "80%", Colors.blue.shade300),
            SizedBox(height: size.height * 0.02),
            _buildProgressCard(context, "Pull-Up Progress", 0.6, "60%", Colors.green.shade300),
            SizedBox(height: size.height * 0.02),
            _buildProgressCard(context, "Squat Progress", 0.75, "75%", Colors.orange.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, String exerciseName, String details, IconData icon, Color bgColor) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: size.width * 0.08, color: Colors.black87),
          SizedBox(width: size.width * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exerciseName,
                  style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold)),
              Text(details, style: TextStyle(fontSize: size.width * 0.045, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, String title, double progress, String progressText, Color progressColor) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ))),
              SizedBox(width: size.width * 0.01),
              Text(progressText, style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
