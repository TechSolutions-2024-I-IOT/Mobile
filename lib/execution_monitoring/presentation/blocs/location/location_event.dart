part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}


class OnNewUserLocationEvent extends LocationEvent {
  final LatLng newLocation;
  const OnNewUserLocationEvent(this.newLocation);
}

class OnStartFollowingUser extends LocationEvent {}

class OnStopFollowingUser extends LocationEvent {}

class FetchInitialLocationEvent extends LocationEvent {
  final String token; 

  const FetchInitialLocationEvent({required this.token});
}

class UserLocationChangedEvent extends LocationEvent {
  final LatLng? location; 

  const UserLocationChangedEvent({this.location});
}