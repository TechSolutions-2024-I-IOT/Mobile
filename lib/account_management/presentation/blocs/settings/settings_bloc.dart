import 'package:bloc/bloc.dart';
import 'package:chapa_tu_bus_app/account_management/application/auth_facade_service.dart';
import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';

import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthFacadeService _authFacadeService; // Use AuthFacadeService

  SettingsBloc({
    required AuthFacadeService authFacadeService, // Inject AuthFacadeService
  })  : _authFacadeService = authFacadeService,
        super(SettingsInitial()) {
    on<SettingsLoadRequested>(_onSettingsLoadRequested);
    on<SettingsUpdateRequested>(_onSettingsUpdateRequested);
    on<SettingsImagePicked>(_onSettingsImagePicked);
  }

  Future<void> _onSettingsLoadRequested(
      SettingsLoadRequested event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final user = await _authFacadeService.getUserProfile();
      final userFirebase = await _authFacadeService.getCurrentUser(); // Use getCurrentUser from AuthFacadeService
      if (user != null && user.role == 'ROLE_USER') {
        emit(SettingsLoaded(user: user));
      } else if (userFirebase != null) {
        emit(SettingsLoaded(user: userFirebase));
      } else {
        emit(const SettingsError(message: 'Usuario no encontrado'));
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onSettingsUpdateRequested(
      SettingsUpdateRequested event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      // Update the user's profile in the backend
      await _authFacadeService.updateUserProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        photoUrl: event.photoURL,
      );

      // Update the user in the local database
      final user = await _authFacadeService.getCurrentUser();
      if (user != null) {
        emit(SettingsUpdateSuccess(user: user));
      } else {
        emit(const SettingsError(message: 'Error updating user'));
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onSettingsImagePicked(
      SettingsImagePicked event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentUser = (state as SettingsLoaded).user;
      emit(SettingsLoaded(
          user: currentUser.copyWith(photoURL: event.imagePath)));
    }
  }
}