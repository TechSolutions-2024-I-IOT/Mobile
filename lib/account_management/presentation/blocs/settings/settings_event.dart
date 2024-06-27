part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {}

class SettingsUpdateRequested extends SettingsEvent {
  final String firstName;
  final String lastName;
  final String? photoURL;

  const SettingsUpdateRequested({
    required this.firstName,
    required this.lastName,
    this.photoURL,
  });

  @override
  List<Object> get props => [firstName, lastName, photoURL ?? ''];
}

class SettingsImagePicked extends SettingsEvent {
  final String imagePath;

  const SettingsImagePicked({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}