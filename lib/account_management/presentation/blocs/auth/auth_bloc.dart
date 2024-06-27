import 'package:bloc/bloc.dart';
import 'package:chapa_tu_bus_app/account_management/application/auth_facade_service.dart';
import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFacadeService _authFacadeService;

  AuthBloc({required AuthFacadeService authFacadeService})
      : _authFacadeService = authFacadeService,
        super(AuthInitialState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInWithEmailAndPasswordRequested>(_onSignInWithEmailAndPasswordRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignUpWithEmailAndPasswordRequested>(_onSignUpWithEmailAndPasswordRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LoginBackendRequested>(_onLoginBackendRequested);
    on<RegisterBackendRequested>(_onRegisterBackendRequested);
  }

  

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      final token = await _authFacadeService.getToken();
      final userBackend = await _authFacadeService.getUserProfile();
      if (token != null && userBackend != null) {  
          emit(Authenticated(user: userBackend, isFirebase: false));
        return; 
      } else {
        emit(const AuthError('Error fetching user profile after login'));  
      }

      final user = await _authFacadeService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user, isFirebase: true));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithEmailAndPasswordRequested(
      SignInWithEmailAndPasswordRequested event,
      Emitter<AuthState> emit) async {
    try {
      await _authFacadeService.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(AuthSuccess());
      final user = await _authFacadeService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user, isFirebase: true));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogleRequested(
      SignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    try {
      await _authFacadeService.signInWithGoogle();
      emit(AuthSuccess());
      final user = await _authFacadeService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user, isFirebase: true));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpWithEmailAndPasswordRequested(
      SignUpWithEmailAndPasswordRequested event,
      Emitter<AuthState> emit) async {
    try {
      await _authFacadeService.signUpWithEmailAndPassword(
          email: event.email, password: event.password, name: event.name);
      emit(AuthSuccess());
      final user = await _authFacadeService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user, isFirebase: true));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginBackendRequested(
      LoginBackendRequested event, Emitter<AuthState> emit) async {
    try {
      final authResponse = await _authFacadeService.loginBackend(
        email: event.email,
        password: event.password,
      );
      await _authFacadeService.saveToken(authResponse.accessToken);
      print('Token: ${authResponse.accessToken}');

      final user = await _authFacadeService.getUserProfile();
      if (user != null) {
        emit(Authenticated(user: user, isFirebase: false));
      } else {
        emit(const AuthError('Error fetching user profile after login'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      final userBackend = await _authFacadeService.getUserProfile();
        if (userBackend == null) {
          _authFacadeService.signOut();
          emit(UnAuthenticated()); // Firebase sign out
        } else {
          _authFacadeService.signOutBackend();
          emit(UnAuthenticated()); // Backend sign out
        }
      
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event, Emitter<AuthState> emit) async {
    try {
      await _authFacadeService.resetPassword(email: event.email);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  

  Future<void> _onRegisterBackendRequested(
      RegisterBackendRequested event, Emitter<AuthState> emit) async {
    try {
      final authResponse = await _authFacadeService.registerBackend(
        email: event.email,
        password: event.password,
        role: event.role,
        firstName: event.firstName,
        lastName: event.lastName,
      );
      await _authFacadeService.saveToken(authResponse.accessToken);
      print('Token: ${authResponse.accessToken}');

      // Handle potential errors when fetching the user profile
      final user = await _authFacadeService.getUserProfile();
      if (user != null || authResponse.accessToken.isEmpty) {
        emit(Authenticated(user: user!, isFirebase: false));
      } else {
        emit(const AuthError('Error fetching user profile after registration')); 
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

