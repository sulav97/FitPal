import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2FC), // Light purple background
      appBar: AppBar(
        backgroundColor: const Color(0xFF896CFE), // Purple app bar
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard,
                color: const Color(0xFF896CFE),
                size: size.width * 0.2,
              ),
              const SizedBox(height: 16),
              Text(
                'This is Dashboard',
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5E4AB9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome to the dashboard page',
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  color: const Color(0xFF5E4AB9).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Add navigation or functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF896CFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                    vertical: size.height * 0.015,
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
