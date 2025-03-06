class APIEndPoints {
  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // static String baseUrl = "http://localhost:5000/api/";
  // static String baseUrl = "http://192.168.1.71:5000/api/";

  // static String pointUrl = "http://192.168.42.9:5000/";
  // static String pointUrl = "http://192.168.1.71:5000/";
  // static String pointUrl = "http://localhost:8080";
  static String pointUrl = "http://192.168.137.1:8080/";
  static String baseUrl = "$pointUrl/api/";
  static String signUpUrl = "users/register";
  static String loginUrl = "auth";
  //
  static String mediaUrl = "${pointUrl}uploads/";
  static String workOutsUrl = "workouts";
  static String meUrl = "auth/me";
  static String logOutUrl = "auth/logout";
  static String editProfileUrl = "users/profile";
}

// TODO :: NOTE
// change pointUrl to your Wifi IP addess or Local host Server