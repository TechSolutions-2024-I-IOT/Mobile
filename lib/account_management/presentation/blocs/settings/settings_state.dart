part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final User user; // Now uses UserBackend

  const SettingsLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class SettingsUpdateSuccess extends SettingsState {
  final User user; // Now uses UserBackend

  const SettingsUpdateSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object> get props => [message];
}