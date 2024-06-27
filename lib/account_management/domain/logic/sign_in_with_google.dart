import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class SignInWithGoogle {
  final IAuthRepository _authRepository;

  SignInWithGoogle({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call() async {
    return await _authRepository.signInWithGoogle();
  }
}