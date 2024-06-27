import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/authentication_response.dart';

class LoginBackend {
  final IAuthRepository _authRepository;

  LoginBackend({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<AuthenticationResponse> call({
    required String email,
    required String password,
  }) async {
    return await _authRepository.loginBackend(
      email: email,
      password: password,
    );
  }
}