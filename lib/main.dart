import 'package:college_community_mobileapp/app/app.dart';
import 'package:college_community_mobileapp/app/di/di.dart';
import 'package:college_community_mobileapp/core/network/hive_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive Database
  await HiveService.init();

  // Delete all the hive data and boxes
  // await HiveService().clearAll();
  // Initialize Dependencies
  await initDependencies();

  runApp(
    const App(),
  );
}
