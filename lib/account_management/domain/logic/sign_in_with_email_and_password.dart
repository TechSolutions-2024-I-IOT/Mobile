import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class SignInWithEmailAndPassword {
  final IAuthRepository _authRepository;

  SignInWithEmailAndPassword({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call({required String email, required String password}) async {
    return await _authRepository.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
