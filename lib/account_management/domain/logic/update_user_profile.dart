import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';

class UpdateUserProfile {
  final IAuthRepository _authRepository;

  UpdateUserProfile({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> call({
    required String firstName,
    required String lastName,
    String? photoUrl,
  }) async {
    await _authRepository.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
    );
  }
}