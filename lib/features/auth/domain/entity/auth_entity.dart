class AuthEntity {
  final String? userId;
  final String email;
  final String fname;
  final String lname;
  final String password;

  AuthEntity({
    this.userId,
    required this.email,
    required this.fname,
    required this.lname,
    required this.password,
  });
}
