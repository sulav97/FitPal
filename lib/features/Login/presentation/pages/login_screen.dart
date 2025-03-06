import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker_app/core/navigation_services.dart';
import 'package:gym_tracker_app/features/Login/presentation/cubit/login_cubit.dart';
import 'package:gym_tracker_app/features/Login/presentation/cubit/login_state.dart';
import 'package:gym_tracker_app/features/workout/presentation/pages/sign_up_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

// OnboardingSlide Widget
class OnboardingSlide extends StatelessWidget {
  final String image;
  final String quote;
  final int currentPage;
  final int pageIndex;
  final PageController pageController;
  final int totalOnboardingPages;
  final int loginPageIndex;

  const OnboardingSlide({
    required this.image,
    required this.quote,
    required this.currentPage,
    required this.pageIndex,
    required this.pageController,
    required this.totalOnboardingPages,
    required this.loginPageIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          fit: BoxFit.contain,
          height: 300,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            quote,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => pageController.jumpToPage(loginPageIndex),
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                children: List.generate(
                  totalOnboardingPages,
                      (index) => Icon(
                    index == currentPage ? Icons.circle : Icons.circle_outlined,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (pageIndex < totalOnboardingPages - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    pageController.jumpToPage(loginPageIndex);
                  }
                },
                child: Text(
                  pageIndex == totalOnboardingPages - 1 ? 'Get Started' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// LoginForm Widget
class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    super.key,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 26, 81, 28),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: Color.fromARGB(255, 26, 81, 28),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(
                Icons.lock,
                color: Color.fromARGB(255, 26, 81, 28),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: _validatePassword,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                context.read<LoginCubit>().loginFx(
                  context,
                  email: widget.emailController.text,
                  password: widget.passwordController.text,
                );
              }
            },
            child: const Text('Log In', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.grey[400]),
              ),
              TextButton(
                onPressed: () => navigateTo(context: context, screen: const SignupScreen()),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Color.fromARGB(255, 26, 81, 28)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// LoginScreen Widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late PageController _pageController;
  int _currentPage = 0;
  double _lastX = 0.0;
  double _lastY = 0.0;
  double _lastZ = 0.0;
  final double _shakeThreshold = 2.7;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    accelerometerEvents.listen((AccelerometerEvent event) {
      _handleShake(event);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleShake(AccelerometerEvent event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;

    final double deltaX = (x - _lastX).abs();
    final double deltaY = (y - _lastY).abs();
    final double deltaZ = (z - _lastZ).abs();

    if (deltaX > _shakeThreshold || deltaY > _shakeThreshold || deltaZ > _shakeThreshold) {
      final now = DateTime.now();
      if (_lastShakeTime == null || now.difference(_lastShakeTime!) > const Duration(seconds: 1)) {
        _lastShakeTime = now;
        _onShake();
      }
    }

    _lastX = x;
    _lastY = y;
    _lastZ = z;
  }

  void _onShake() {
    if (_currentPage == 3 && _formKey.currentState!.validate()) {
      context.read<LoginCubit>().loginFx(
        context,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Theme(
          data: ThemeData.dark().copyWith(
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
                borderSide: const BorderSide(color: Colors.lightBlue),
              ),
              labelStyle: const TextStyle(color: Colors.white70),
              errorStyle: TextStyle(color: Colors.red[300]),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 26, 81, 28),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Color.fromARGB(255, 30, 30, 30)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    OnboardingSlide(
                      image: 'assets/images/onboard1.png',
                      quote: 'The only bad workout is the one that didn\'t happen.',
                      currentPage: _currentPage,
                      pageIndex: 0,
                      pageController: _pageController,
                      totalOnboardingPages: 3,
                      loginPageIndex: 3,
                    ),
                    OnboardingSlide(
                      image: 'assets/images/onboard2.png',
                      quote: 'Strength doesn\'t come from what you can do. It comes from overcoming the things you once thought you couldn\'t.',
                      currentPage: _currentPage,
                      pageIndex: 1,
                      pageController: _pageController,
                      totalOnboardingPages: 3,
                      loginPageIndex: 3,
                    ),
                    OnboardingSlide(
                      image: 'assets/images/onboard3.png',
                      quote: 'Your body can stand almost anything. It\'s your mind that you have to convince.',
                      currentPage: _currentPage,
                      pageIndex: 2,
                      pageController: _pageController,
                      totalOnboardingPages: 3,
                      loginPageIndex: 3,
                    ),
                    // Updated Login Page Layout
                    SizedBox.expand(
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Center(
                            child: Card(
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey[800]!, width: 1),
                              ),
                              elevation: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: LoginForm(
                                  formKey: _formKey,
                                  emailController: _emailController,
                                  passwordController: _passwordController,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}