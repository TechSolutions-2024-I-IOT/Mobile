import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class ResetPassword {
  final IAuthRepository _authRepository;

  ResetPassword({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call({required String email}) async {
    return await _authRepository.resetPassword(email: email);
  }
}