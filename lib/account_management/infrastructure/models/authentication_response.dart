class AuthenticationResponse {
  final int userId;
  final String accessToken;
  final String refreshToken;

  AuthenticationResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      userId: json['user_id'] as int,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}