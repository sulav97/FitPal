import 'dart:convert';
import 'package:college_community_mobileapp/features/auth/presentation/view/register_view.dart';
import 'package:college_community_mobileapp/features/bottom_navigation/presentation/view/bottom_navigation_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // For showing loading state

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2FC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.1),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF896CFE),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5E4AB9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please enter your details to access your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.035,
                          color: const Color(0xFF5E4AB9).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _emailController,
                  label: 'Username or email',
                  hint: 'example@example.com',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: '••••••••',
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to Forget Password screen
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF896CFE),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,  // Disable button when loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF896CFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator
                        : const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'or sign up with',
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: const Color(0xFF5E4AB9).withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(Icons.g_mobiledata, const Color(0xFF896CFE)),
                    const SizedBox(width: 16),
                    _buildSocialIcon(Icons.facebook, const Color(0xFF896CFE)),
                    const SizedBox(width: 16),
                    _buildSocialIcon(Icons.fingerprint, const Color(0xFF896CFE)),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                          color: const Color(0xFF5E4AB9).withOpacity(0.7)),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: Color(0xFF896CFE),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterView(),
                                ),
                              );
                              // Navigate to Register screen
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF5E4AB9).withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
            TextStyle(color: const Color(0xFF5E4AB9).withOpacity(0.3)),
            filled: true,
            fillColor: const Color(0xFFECEAFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Color(0xFF5E4AB9)),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: color,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  // Login function that makes an HTTP request
  Future<void> _login() async {


    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if(email.isEmpty || password.isEmpty){
      _showError("All Fields Required");
      return;
    }
    if (!_isValidEmail(email)) {
      _showError('Invalid email address.');
      return;
    }
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    final response = await http.post(
      Uri.parse('http://192.168.1.138:3000/login'),  // Replace with your backend API URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;  // Hide loading indicator
    });

    if (response.statusCode == 200) {
      // Successfully logged in, navigate to the next screen
      final data = json.decode(response.body);
      final userName = data['user']['name'];  // Extract the user's name from the response
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
             BottomNavigationView(userName: userName)),
      );
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text("Login Success "),backgroundColor: Colors.green,),
      );
    } else {
      // Invalid credentials, show error message
      _showError('Invalid credentials. Please try again.');

    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }


  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}
