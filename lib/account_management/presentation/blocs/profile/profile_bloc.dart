import 'package:bloc/bloc.dart';
import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthApi _authApi;

  ProfileBloc({required AuthApi authApi})
      : _authApi = authApi,
        super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileSignOutRequested>(_onProfileSignOutRequested);
  }

  Future<void> _onProfileLoadRequested(
      ProfileLoadRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
     
      final user =
          await _authApi.getCurrentUser(); // Use this if signed in with Google
      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        final userProfile = await _authApi.getUserProfile();
        emit(ProfileLoaded(
            user: userProfile!)); // Use this if logged in with backend
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onProfileSignOutRequested(
      ProfileSignOutRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      
      final currentUser = await _authApi.getCurrentUser();
      if (currentUser != null) {
        // If user is from Firebase, use signOut
        await _authApi.signOut();
      } else {
        // If user is from backend, use signOutBackend
        await _authApi.signOutBackend();
      }
      emit(ProfileSignOutSuccess());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
