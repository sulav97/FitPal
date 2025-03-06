import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker_app/core/navigation_services.dart';
import 'package:gym_tracker_app/features/Login/presentation/cubit/login_cubit.dart';
import 'package:gym_tracker_app/features/Login/presentation/cubit/login_state.dart';
import 'package:gym_tracker_app/features/Login/presentation/pages/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Offset> _logoAnimation;
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Password validation status
  bool _hasCapital = false;
  bool _hasSpecial = false;
  bool _has6Chars = false;
  bool _hasNumber = false;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 800),
    // )..forward();

    // _logoAnimation = Tween<Offset>(
    //   begin: const Offset(0, -1),
    //   end: Offset.zero,
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInOut,
    // ));

    // Add listener to validate password in real-time
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasCapital = RegExp(r'[A-Z]').hasMatch(password);
      _hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
      _has6Chars = password.length >= 6;
      _hasNumber = RegExp(r'[0-9]').hasMatch(password);
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().signUpFx(
            context,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            nickName: _nicknameController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50); // lightBlue primary color

    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color.fromARGB(255, 30, 30, 30)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset('assets/logo/gym_logo.png', height: 100),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey[800]!, width: 1),
                      ),
                      elevation: 8,
                      margin: const EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Sign  Up',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // First Name and Last Name in a Row
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('First Name',
                                      style: TextStyle(color: Colors.white70)),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter first name',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),

                              // Last Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 16),
                                  const Text('Last Name',
                                      style: TextStyle(color: Colors.white70)),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    // width: 300,
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter last name',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Other form fields follow the same pattern...
                              // (Only showing a few to demonstrate the theme)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Nickname',
                                      style: TextStyle(color: Colors.white70)),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _nicknameController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter nickname',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a nickname';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Email
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Email'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter email',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Password
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Password'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter password',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: primaryColor,
                                        ),
                                        onPressed: () => setState(() =>
                                            _isPasswordVisible =
                                                !_isPasswordVisible),
                                      ),
                                    ),
                                    obscureText: !_isPasswordVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      if (!_hasCapital ||
                                          !_hasSpecial ||
                                          !_has6Chars ||
                                          !_hasNumber) {
                                        return 'Password does not meet requirements';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Confirm Password
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Confirm Password'),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _confirmPasswordController,
                                    decoration: InputDecoration(
                                      hintText: 'Confirm password',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isConfirmPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: primaryColor,
                                        ),
                                        onPressed: () => setState(() =>
                                            _isConfirmPasswordVisible =
                                                !_isConfirmPasswordVisible),
                                      ),
                                    ),
                                    obscureText: !_isConfirmPasswordVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Password requirements
                              // Column(
                              //   children: [
                              //     _buildRequirement('One capital letter', _hasCapital),
                              //     _buildRequirement('One special character', _hasSpecial),
                              //     _buildRequirement('At least 6 characters long', _has6Chars),
                              //     _buildRequirement('At least one number', _hasNumber),
                              //   ],
                              // ),
                              const SizedBox(height: 24),

                              // Sign Up Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  child: BlocBuilder<LoginCubit, LoginState>(
                                    builder: (context, state) {
                                      return state.isLoadingState
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : const Text('Sign Up',
                                              style: TextStyle(fontSize: 16));
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Login Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account?",
                                      style: TextStyle(color: Colors.white70)),
                                  TextButton(
                                    onPressed: () => navigateAndPushReplacement(
                                        context: context,
                                        screen: const LoginScreen()),
                                    child: const Text('Sign In',
                                        style: TextStyle(color: primaryColor)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            color: isMet ? Colors.lightBlue : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(color: isMet ? Colors.lightBlue : Colors.red)),
        ],
      ),
    );
  }
}
