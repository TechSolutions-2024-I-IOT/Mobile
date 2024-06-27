import 'package:chapa_tu_bus_app/account_management/infrastructure/models/firebase/user_model_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users'; // Nombre de la colección en Firestore

  Future<UserModelFirebase?> getUserById(String userId) async {
    try {
      final documentSnapshot =
          await _firestore.collection(_collectionPath).doc(userId).get();

      if (documentSnapshot.exists) {
        return UserModelFirebase.fromFirestore(documentSnapshot);
      } else {
        return null; // El usuario no existe en Firestore
      }
    } catch (e) {
      // Manejo de errores de Firestore
      print('Error getting user from Firestore: $e');
      throw Exception('Error getting user from Firestore');
    }
  }

  Future<void> createUser(UserModelFirebase user) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(user.id)
          .set(user.toFirestore());
    } catch (e) {
      // Manejo de errores de Firestore
      print('Error creating user in Firestore: $e');
      throw Exception('Error creating user in Firestore');
    }
  }

  Future<void> updateUser(UserModelFirebase user) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      // Manejo de errores de Firestore
      print('Error updating user in Firestore: $e');
      throw Exception('Error updating user in Firestore');
    }
  }
}