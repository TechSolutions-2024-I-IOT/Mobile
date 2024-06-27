import 'dart:io';

import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data/local_database_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data_sources/backend_auth_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data_sources/firebase_auth_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/authentication_response.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/backend/user_model_backend.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/firebase/user_model_firebase.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuthDatasource _firebaseAuthDatasource;
  final LocalDatabaseDatasource _localDatabaseDatasource;
  final BackendAuthDatasource _backendAuthDatasource;

  AuthRepositoryImpl({
    required FirebaseAuthDatasource firebaseAuthDatasource,
    required LocalDatabaseDatasource localDatabaseDatasource,
    required BackendAuthDatasource backendAuthDatasource,
  })  : _firebaseAuthDatasource = firebaseAuthDatasource,
        _localDatabaseDatasource = localDatabaseDatasource,
        _backendAuthDatasource = backendAuthDatasource;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Autenticación con Firebase
      final userCredential = await _firebaseAuthDatasource
          .signInWithEmailAndPassword(email: email, password: password);

      // 2. Obtener el usuario de Firebase
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 3. Intentar obtener el usuario de la base de datos local
        UserModelFirebase? localUser =
            await _localDatabaseDatasource.getUserByIdFirebase(firebaseUser.uid);

        // 4. Si no existe en local, crear un nuevo UserModel
        if (localUser == null) {
          localUser = UserModelFirebase(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoURL: firebaseUser.photoURL ??
                'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgQrn0h8YlouX1uYeAHOjVV_1zOiEzM0Q_Ftq_kDVXy8XUJVc2bLiMCHa6-hYHGBKHswAnzu6McRzACcS7kAwtq0Q8f-2vzFpOtBmnMGs9M7a5avCRCGuyMzRRUOGHLTNxlzQ1WcwgmM6xhJ-_3GycyKrQstuDFIVisogfV9FaYpaJzfciWLj8B1VOxlfA/s1600/Ellipse%2049.png',
          );

          // 5. Guardar el nuevo usuario en la base de datos local
          await _localDatabaseDatasource.insertUserFirebase(localUser);
        }
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _firebaseAuthDatasource.signInWithGoogle();
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 1. Intentar obtener el usuario de la base de datos local
        UserModelFirebase? localUser =
            await _localDatabaseDatasource.getUserByIdFirebase(firebaseUser.uid);

        // 2. Si no existe en local, crear un nuevo UserModel
        if (localUser == null) {
          localUser = UserModelFirebase(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoURL: firebaseUser.photoURL,
          );

          // 3. Guardar el nuevo usuario en la base de datos local
          await _localDatabaseDatasource.insertUserFirebase(localUser);
        }
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Registrar el usuario en Firebase
      final userCredential = await _firebaseAuthDatasource
          .signUpWithEmailAndPassword(email: email, password: password);

      // 2. Obtener el usuario de Firebase
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 3. Crear un nuevo UserModel
        final userModel = UserModelFirebase(
          id: firebaseUser.uid,
          name: name,
          email: firebaseUser.email ?? '',
          photoURL: firebaseUser.photoURL,
        );

        // 4. Guardar el nuevo usuario en la base de datos local
        await _localDatabaseDatasource.insertUserFirebase(userModel);
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    // 1. Obtén el usuario actual de Firebase (antes de cerrar sesión)
    final firebaseUser = _firebaseAuthDatasource.getCurrentUser();
    String? userId; // Variable para almacenar el ID del usuario

    // 2. Obtiene el ID del usuario si existe
    if (firebaseUser != null) {
      userId = firebaseUser.uid;
    }

    // 3. Cierra la sesión en Firebase
    await _firebaseAuthDatasource.signOut();

    // 4. Elimina el usuario de la base de datos local (si se obtuvo el ID)
    if (userId != null) {
      await _localDatabaseDatasource.dropDatabase();
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuthDatasource.resetPassword(email: email);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    // 1. Obtener el usuario de Firebase
    final firebaseUser = _firebaseAuthDatasource.getCurrentUser();

    if (firebaseUser != null) {
      // 2. Intentar obtener el usuario de la base de datos local
      final UserModelFirebase? localUser =
          await _localDatabaseDatasource.getUserByIdFirebase(firebaseUser.uid);

      // 3. Si existe en local, convertirlo a una entidad de dominio
      if (localUser != null) {
        return User(
          id: localUser.id,
          name: localUser.name,
          email: localUser.email,
          photoURL: localUser.photoURL,
        );
      }
    }
    return null;
  }


  // Backend methods
  @override
  Future<AuthenticationResponse> registerBackend({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    return await _backendAuthDatasource.signUpWithEmailAndPassword(
      email: email,
      password: password,
      role: role,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<AuthenticationResponse> loginBackend({
    required String email,
    required String password,
  }) async {
    return await _backendAuthDatasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<User?> getUserProfile() async {
    try {
      return await _backendAuthDatasource.getUserProfile();
    } catch (e) {
      // Handle the error (e.g., log it or return null)
      print('Error fetching user profile: $e');
      return null; 
    }
  }

  @override
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    String? photoUrl,
  }) async {
    try {
      // 1. Retrieve the current user from the local database
      final user = await getCurrentUser();
      if (user != null) {
        // 2. Handle new photo upload if provided
        if (photoUrl != null) {
          // 2.a. Upload image to Firebase Storage
          final downloadURL = await _uploadImageToFirebaseStorage(
              user.id, photoUrl); 

          // 2.b. Update the user object with the new photo URL
          photoUrl = downloadURL; 

          // 2.c. Update the user in both the local database and backend
          await _updateUser(user: user); // Use _updateUser for local DB update
        } else {
          // 3. Update user in backend without photoURL
          await _backendAuthDatasource.updateUserProfile(
            firstName: firstName,
            lastName: lastName,
          );
        }
        // 4. Update user in the backend with the updated data
        await _backendAuthDatasource.updateUserProfile(
          firstName: firstName,
          lastName: lastName,
          photoUrl: photoUrl,
        );
      }
    } catch (e) {
      // Handle potential errors during the update process
      print('Error updating user profile: $e');
      rethrow; // Optionally rethrow the exception to be caught at a higher level
    }
  }

  Future<void> _updateUser({required User user}) async {
    // Update user in local database
    var userModel = UserModelBackend(
      id: user.id,
      firstName: user.firstName ?? '',
      lastName: user.lastName ?? '',
      email: user.email,
      password: user.password ?? '',
      photoURL: user.photoURL,
    );
    await _localDatabaseDatasource.updateUser(userModel);
  }

  Future<String> _uploadImageToFirebaseStorage(String userId, String filePath) async {
    try {
      final file = XFile(filePath.replaceAll('file://', ''));
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_images/$userId');
      await storageRef.putFile(file as File);
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw Exception('Error uploading image to Firebase Storage');
    }
  }

  @override
  Future<void> signOutBackend() async {
    final user = await _backendAuthDatasource.getCurrentUser();
    if (user != null) {
      await _localDatabaseDatasource.dropDatabase();
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await _localDatabaseDatasource.saveToken(token); 
  }

  @override
  Future<String?> getToken() async {
    return await _localDatabaseDatasource.getToken(); 
  }
  
}