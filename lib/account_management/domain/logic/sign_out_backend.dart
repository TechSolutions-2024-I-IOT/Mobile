import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class SignOutBackend {
  final IAuthRepository _authRepository;

  SignOutBackend({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call() async {
    await _authRepository.signOutBackend();
  }
}