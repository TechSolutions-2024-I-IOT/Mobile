class UserModelBackend {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? photoURL;
  final String? role;

  UserModelBackend({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.photoURL,
    this.role,
  });

  // Método copyWith
  UserModelBackend copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? photoURL,
    String? role,
  }) {
    return UserModelBackend(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
    );
  }

  // Convertir un Map a un UserModel (desde la base de datos)
  factory UserModelBackend.fromJson(Map<String, dynamic> json) {
    return UserModelBackend(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      password: json['password'] ?? '',
      photoURL: json['photoURL'],
      role: json['role'] ?? '',
    );
  }

  // Convertir un UserModel a un Map (para la base de datos)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'photoURL': photoURL,
      'role': role,
    };
  }

}