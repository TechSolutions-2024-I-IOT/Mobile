part of 'location_bloc.dart';

class LocationState extends Equatable {

  final bool followingUser;
  final LatLng? lastKnownLocation;
  final List<LatLng> myLocationHistory;
  final LatLng? initialLocation;


  const LocationState({
    this.followingUser = false,
    this.lastKnownLocation,
    this.initialLocation,
    myLocationHistory
  }): myLocationHistory = myLocationHistory ?? const [];
  
  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnownLocation,
    List<LatLng>? myLocationHistory,
    LatLng? initialLocation
  }) {
    return LocationState(
      followingUser: followingUser ?? this.followingUser,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      initialLocation: initialLocation ?? this.initialLocation
    );
  }

  @override
  List<Object?> get props => [followingUser, lastKnownLocation, myLocationHistory, initialLocation];
}
