class LoginRequest {
  final String userEmail;
  final String userPassword;

  LoginRequest({
    required this.userEmail,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() => {
        'userEmail': userEmail,
        'userPassword': userPassword,
      };
}
