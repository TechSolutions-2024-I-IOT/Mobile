part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final bool isFirebase;

  const Authenticated({ required this.user, required this.isFirebase });

  @override
  List<Object> get props => [user];
}

class UnAuthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthSuccess extends AuthState {}

class ResetPasswordSuccess extends AuthState {}