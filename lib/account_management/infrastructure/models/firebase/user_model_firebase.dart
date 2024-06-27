import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelFirebase {
  final String id;
  final String name;
  final String email;
  final String? photoURL;

  UserModelFirebase({
    required this.id,
    required this.name,
    required this.email,
    this.photoURL,
  });

  // Método copyWith
  UserModelFirebase copyWith({
    String? id,
    String? name,
    String? email,
    String? photoURL,
  }) {
    return UserModelFirebase(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  // Convertir un Map a un UserModel (desde la base de datos)
  factory UserModelFirebase.fromJson(Map<String, dynamic> json) {
    return UserModelFirebase(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoURL: json['photoURL'],
    );
  }

  // Convertir un UserModel a un Map (para la base de datos)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoURL': photoURL,
    };
  }

  // Convertir un UserModel a un Map (para Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoURL': photoURL,
    };
  }

  // Convertir un DocumentSnapshot a un UserModel
  factory UserModelFirebase.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModelFirebase(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '', 
      photoURL: data['photoURL'],
    );
  }

}