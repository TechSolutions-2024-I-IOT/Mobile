import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class SignOut {
  final IAuthRepository _authRepository;

  SignOut({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call() async {
    return await _authRepository.signOut();
  }
}