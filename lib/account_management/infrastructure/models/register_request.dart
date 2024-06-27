class RegisterRequest {
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String lastName;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': role,
        'firstName': firstName,
        'lastName': lastName,
      };
}