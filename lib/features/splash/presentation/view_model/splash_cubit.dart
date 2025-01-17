import 'package:college_community_mobileapp/features/auth/presentation/view/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit() : super(null);

  // Method to handle initialization and navigation
  void init(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    });
  }
}
