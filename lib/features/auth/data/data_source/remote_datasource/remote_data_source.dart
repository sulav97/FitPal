import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  // Base URL for the API
  final String baseUrl = "http://192.168.1.138:3000";

  // Function to send sign-up data to the backend with image upload


  Future<Map<String, dynamic>> signUp({
    required String name,
    required String dob,
    required String email,
    required String password,
    required String confirmPassword,
    required String height,
    required String weight,
    required File? imageFile,
  }) async {
    // Prepare the request headers
    final Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
    };

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/signup'));

      // Add form fields
      request.fields['name'] = name;
      request.fields['dob'] = dob;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['height'] = height;
      request.fields['weight'] = weight;

      // Add image file to the request (if available)
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      // Send the request and get the response
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'User created successfully!',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to create user.',
        };
      }
    } catch (e) {
      // If an error occurs during the request
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
