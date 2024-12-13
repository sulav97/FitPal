import 'package:fitpal/signup.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF007AFF),
          background: Colors.black,
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}
