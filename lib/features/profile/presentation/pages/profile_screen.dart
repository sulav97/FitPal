import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker_app/app/di/di.dart';
import 'package:gym_tracker_app/core/api_endpoints.dart';
import 'package:gym_tracker_app/features/Login/presentation/cubit/login_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController usernameController =
      TextEditingController(text: "Admin");
  final TextEditingController ageController = TextEditingController(text: "23");
  final TextEditingController weightController =
      TextEditingController(text: '65');
  final TextEditingController heightController =
      TextEditingController(text: '175');
  String selectedGoal = "Maintain";
  File? profileImage;
  String? apiImage;

  Future<void> pickImage() async {
    final status = await Permission.photos.request();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  void updateProfile() {
    final String username = usernameController.text;
    final String age = ageController.text;
    final String weight = weightController.text;
    final String height = heightController.text;

    if (username.isEmpty || age.isEmpty || weight.isEmpty || height.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }

    context.read<LoginCubit>().updateProfile(
          context,
          name: username,
          age: age,
          weight: weight,
          height: height,
          fitnessGoal: selectedGoal,
          profilepic: profileImage,
        );
  }

  @override
  void initState() {
    super.initState();
    var user = getIt<LoginCubit>().state.userData;
    usernameController.text = user?.name ?? '';
    selectedGoal = user?.fitnessGoal ?? 'Maintain';
    apiImage = user?.profilePic ?? '';
  }

  @override
  Widget build(BuildContext context) {
    const isDarkMode = true;

    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: const MaterialColor(0xFF1B5E20, {
          50: Color(0xFFE8F5E9),
          100: Color(0xFFC8E6C9),
          200: Color(0xFFA5D6A7),
          300: Color(0xFF81C784),
          400: Color(0xFF66BB6A),
          500: Color(0xFF4CAF50),
          600: Color(0xFF43A047),
          700: Color(0xFF388E3C),
          800: Color(0xFF2E7D32),
          900: Color(0xFF1B5E20),
        }),
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor:
              isDarkMode ? Colors.grey[900] : Colors.lightBlue[800],
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color:
                  isDarkMode ? Colors.lightBlue[700]! : Colors.lightBlue[800]!,
              width: 2,
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Profile",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<LoginCubit>().logOut(context),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            isDarkMode ? Colors.grey[700] : Colors.grey[300],
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : (apiImage != null && apiImage!.isNotEmpty
                                ? NetworkImage(
                                    '${APIEndPoints.mediaUrl}$apiImage')
                                : null),
                        // backgroundImage: null,
                        child: (profileImage == null &&
                                (apiImage == null || apiImage!.isEmpty))
                            ? const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color:
                                    isDarkMode ? Colors.white70 : Colors.grey,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[700]
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  usernameController.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField("Username", usernameController,
                    isNumber: false),
                _buildTextField("Age", ageController, isNumber: true),
                _buildTextField("Weight (kg)", weightController,
                    isNumber: true),
                _buildTextField("Height (cm)", heightController,
                    isNumber: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DropdownButtonFormField<String>(
                    value: selectedGoal,
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      hintText: 'Select Fitness Goal',
                    ),
                    items:
                        ["Lose Weight", "Gain Muscle", "Maintain"].map((goal) {
                      return DropdownMenuItem(
                        value: goal,
                        child: Text(
                          goal,
                          style: const TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedGoal = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.lightBlue[800]
                        : Colors.lightBlue[800],
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: updateProfile,
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    const isDarkMode = true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }
}
