import 'package:chapa_tu_bus_app/account_management/application/auth_facade_service.dart';
import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/authentication_response.dart';
import 'package:chapa_tu_bus_app/injections.dart';

class AuthApi {
  final AuthFacadeService _authFacadeService = serviceLocator<AuthFacadeService>();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _authFacadeService.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    await _authFacadeService.signInWithGoogle();
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await _authFacadeService.signUpWithEmailAndPassword(
        email: email, password: password, name: name);
  }

  Future<void> signOut() async {
    await _authFacadeService.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _authFacadeService.resetPassword(email: email);
  }

  Future<User?> getCurrentUser() async {
    return await _authFacadeService.getCurrentUser();
  }

  Future<User?> getUserProfile() async {
    return await _authFacadeService.getUserProfile(); 
  }

  Future<AuthenticationResponse> loginBackend({
    required String email,
    required String password,
  }) async {
    return await _authFacadeService.loginBackend(
      email: email,
      password: password,
    );
  }

  Future<AuthenticationResponse> registerBackend({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    return await _authFacadeService.registerBackend(
      email: email,
      password: password,
      role: role,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<void> signOutBackend() async {
    await _authFacadeService.signOutBackend(); 
  }

  Future<void> saveToken(String token) async {
    await _authFacadeService.saveToken(token);
  }
}