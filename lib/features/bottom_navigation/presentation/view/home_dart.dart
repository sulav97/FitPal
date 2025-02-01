import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final String userName;
  const HomeView({required this.userName , super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              )
            : const Text("Home"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        centerTitle: true,
        toolbarHeight: 35,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                  }
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                // Navigate to progress tracking page
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              "Hello, ${widget.userName}",
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Ready to achieve your fitness goals?",
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: size.height * 0.03),
            // Quick Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatsCard(context, Icons.directions_run, "Workouts", "5",
                    Colors.blue.shade200, () => _navigateToWorkout(context)),
                _buildStatsCard(context, Icons.restaurant, "Meals", "3",
                    Colors.green.shade200, () => _navigateToNutrition(context)),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            // Daily Goal Progress
            _buildProgressCard(
              context,
              "Daily Goal",
              0.75,
              "75%",
              const Color(0xFF896CFE),
            ),
            SizedBox(height: size.height * 0.02),
            // Latest Workout Summary
            Text(
              "Latest Activity",
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            _buildActivityCard(context, "Morning Jog", "30 min",
                Icons.directions_run, Colors.orange.shade100),
            SizedBox(height: size.height * 0.03),
            // Recommendations Section
            Text(
              "Recommended for You",
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: SizedBox(
                height:
                    size.height * 0.17, // Increased height for exercise names
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    String imagePath = '';
                    String exerciseName = '';
                    if (index == 0) {
                      imagePath = 'assets/images/recom1.png';
                      exerciseName = 'Squat';
                    } else if (index == 1) {
                      imagePath = 'assets/images/recom2.png';
                      exerciseName = 'Stretch';
                    }
                    return _buildRecommendationCard(
                        context, exerciseName, imagePath);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, IconData icon, String title,
      String value, Color bgColor, void Function() onTap) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        width: size.width * 0.4,
        child: Column(
          children: [
            Icon(icon, size: size.width * 0.08, color: Colors.black87),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    fontSize: size.width * 0.04, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, String title, double progress,
      String progressText, Color progressColor) {
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
          Text(title,
              style: TextStyle(
                  fontSize: size.width * 0.05, fontWeight: FontWeight.bold)),
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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                      ))),
              SizedBox(width: size.width * 0.01),
              Text(progressText,
                  style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, String activityName,
      String activityTime, IconData icon, Color bgColor) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Icon(icon, size: size.width * 0.08, color: Colors.black87),
            SizedBox(
              width: size.width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activityName,
                    style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w500)),
                Text(activityTime,
                    style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.grey.shade500)
      ]),
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, String title, String imagePath) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      width: size.width * 0.4,
      child: Column(
        children: [
          // Add the image instead of the icon
          Image.asset(
            imagePath,
            fit: BoxFit.contain, // Make sure the image fits well
          ),
          const SizedBox(height: 7),
          // Add exercise name below the image
          Text(
            title,
            style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.black87,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _navigateToWorkout(BuildContext context) {
    Navigator.pushNamed(context, '/workout');
  }

  void _navigateToNutrition(BuildContext context) {
    Navigator.pushNamed(context, '/nutrition');
  }
}
