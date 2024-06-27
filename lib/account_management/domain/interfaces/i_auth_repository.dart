import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/authentication_response.dart';

abstract class IAuthRepository {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  Future<User?> getCurrentUser();

   // Backend methods
  Future<User?> getUserProfile();
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    String? photoUrl,
  });

  Future<AuthenticationResponse> registerBackend({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  });

  Future<AuthenticationResponse> loginBackend({
    required String email,
    required String password,
  });

  Future<void> signOutBackend();

  Future<void> saveToken(String token);

  Future<String?> getToken();

}