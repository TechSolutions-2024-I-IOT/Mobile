import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/get_current_user.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/get_user_profile.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/login_backend.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/register_backend.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/reset_password.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_in_with_email_and_password.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_in_with_google.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_out.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_out_backend.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_up_with_email_and_password.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/update_user_profile.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/authentication_response.dart';

class AuthFacadeService {
  final IAuthRepository authRepository;
  final SignInWithEmailAndPassword _signInWithEmailAndPassword;
  final SignInWithGoogle _signInWithGoogle;
  final SignUpWithEmailAndPassword _signUpWithEmailAndPassword;
  final SignOut _signOut;
  final ResetPassword _resetPassword;
  final UpdateUserProfile _updateUserProfile;
  final SignOutBackend _signOutBackend;
  final GetUserProfile _getUserProfile;
  final GetCurrentUser _getCurrentUser;
  final LoginBackend _loginBackend;
  final RegisterBackend _registerBackend;

  AuthFacadeService({
    required this.authRepository,
    required SignInWithEmailAndPassword signInWithEmailAndPassword,
    required SignInWithGoogle signInWithGoogle,
    required SignUpWithEmailAndPassword signUpWithEmailAndPassword,
    required SignOut signOut,
    required ResetPassword resetPassword,
    required GetCurrentUser getCurrentUser,
    required UpdateUserProfile updateUserProfile,
    required SignOutBackend signOutBackend,
    required GetUserProfile getUserProfile,
    required LoginBackend loginBackend,
    required RegisterBackend registerBackend,
  })  : _signInWithEmailAndPassword = signInWithEmailAndPassword,
        _signInWithGoogle = signInWithGoogle,
        _signUpWithEmailAndPassword = signUpWithEmailAndPassword,
        _signOut = signOut,
        _resetPassword = resetPassword,
        _updateUserProfile = updateUserProfile,
        _signOutBackend = signOutBackend,
        _getUserProfile = getUserProfile,
        _getCurrentUser = getCurrentUser,
        _loginBackend = loginBackend,
        _registerBackend = registerBackend;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    await _signInWithGoogle();
  }

  Future<void> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    await _signUpWithEmailAndPassword(
        email: email, password: password, name: name);
  }

  Future<void> signOut() async {
    
    await _signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _resetPassword(email: email);
  }

  Future<void> signOutBackend() async {
    await _signOutBackend();
  }

  Future<User?> getCurrentUser() async {
    return await _getCurrentUser();
  }

  Future<User?> getUserProfile() async {
    return await _getUserProfile();
  }

  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    String? photoUrl,
  }) async {
    await _updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
    );
  }

  Future<AuthenticationResponse> loginBackend({
    required String email,
    required String password,
  }) async {
    return await _loginBackend(
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
    return await _registerBackend(
      email: email,
      password: password,
      role: role,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<void> saveToken(String token) async {
    await authRepository.saveToken(token);
  }

  Future<String?> getToken() async {
    return await authRepository.getToken();
  }
}
