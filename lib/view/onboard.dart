import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import './login.dart';

class OnboardView extends StatelessWidget {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/fitness_onboard.png', // Ensure the path is correct
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          // Content on top of the background
          SafeArea(
            child: Column(
              children: [
                // Spacer for alignment (added extra space to push the content further down)
                Expanded(flex: 2, child: Container()),

                // Middle Section with Text (shortened to reduce space)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to FitPal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text is white for contrast
                            shadows: [
                              Shadow(
                                blurRadius: 6.0,
                                color: Colors.black.withOpacity(0.7),
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track your workouts, set goals, and stay motivated to achieve the healthiest version of yourself!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.045,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                            shadows: [
                              Shadow(
                                blurRadius: 6.0,
                                color: Colors.black.withOpacity(0.7),
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Section with Buttons (more space for button)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to LoginView
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginView(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF896CFE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                            ),
                            children: [
                              TextSpan(
                                text: 'Log In',
                                style: const TextStyle(
                                  color: Color(0xFF896CFE),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to LoginView
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginView(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
