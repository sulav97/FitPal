import 'package:college_community_mobileapp/app/di/di.dart';
import 'package:college_community_mobileapp/core/app_theme.dart';
import 'package:college_community_mobileapp/features/splash/presentation/view/splash_screen_view.dart';
import 'package:college_community_mobileapp/features/splash/presentation/view_model/splash_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Learning',
      theme: AppTheme.getApplicationTheme(isDarkMode: false),
      home: BlocProvider.value(
        value: getIt<
            SplashCubit>(), // Ensure SplashCubit is properly provided by getIt
        child:
            const SplashscreenView(), // SplashScreen widget is being used from the correct package
      ),
    );
  }
}
