import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/authentication_response.dart';

class RegisterBackend {
  final IAuthRepository _authRepository;

  RegisterBackend({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<AuthenticationResponse> call({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    return await _authRepository.registerBackend(
      email: email,
      password: password,
      role: role,
      firstName: firstName,
      lastName: lastName,
    );
  }
}