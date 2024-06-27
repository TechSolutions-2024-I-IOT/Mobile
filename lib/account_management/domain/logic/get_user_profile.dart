import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class GetUserProfile {
  final IAuthRepository _authRepository;

  GetUserProfile({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<User?> call() async {
    return await _authRepository.getUserProfile();
  }
}