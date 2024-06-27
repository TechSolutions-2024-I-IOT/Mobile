import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class SignUpWithEmailAndPassword {
  final IAuthRepository _authRepository;

  SignUpWithEmailAndPassword({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _authRepository.signUpWithEmailAndPassword(
      email: email, 
      password: password,
      name: name, 
    );
  }
}