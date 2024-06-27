import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? photoURL;
  final String? role;
  final String? password;
  final String? name; 

  const User({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.photoURL,
    this.role,
    this.password,
    this.name,
  });

  // Método copyWith
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? photoURL,
    String? role,
    String? password,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      password: password ?? this.password,
      name: name ?? this.name,
    );
  }

  // fromJson factory constructor
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as int).toString(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String,
      photoURL: json['photoURL'] as String?,
      role: json['role'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'photoURL': photoURL,
    'role': role,
    'password': password,
    'name': name,
  };

  @override
  List<Object?> get props => [id, firstName, lastName, email, photoURL, role, password, name]; 
}