import 'package:college_community_mobileapp/core/theme/theme.dart';
import 'package:college_community_mobileapp/view/splashscreen.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dashboard',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashscreenView(),
    );
  }
}
