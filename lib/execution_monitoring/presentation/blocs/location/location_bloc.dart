import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/repositories/ilocation_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  StreamSubscription<Position>? positionStream;

  LocationBloc(this._locationRepository) : super(const LocationState()) {
    on<OnStartFollowingUser>((event, emit) => emit(state.copyWith(followingUser: true)),);

    on<OnStopFollowingUser>((event, emit) => emit(state.copyWith(followingUser: false)),);

    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
        lastKnownLocation: event.newLocation,
        myLocationHistory: [...state.myLocationHistory, event.newLocation]
      ));
    });

    on<FetchInitialLocationEvent>((event, emit) async {
      final locations = await _locationRepository.getLocations(token: event.token);
      // Assuming your API returns a list of locations, pick the first one
      if (locations.isNotEmpty) {
        final firstLocation = locations.first;
        emit(state.copyWith(initialLocation: LatLng(firstLocation.lat.toDouble(), firstLocation.lng.toDouble()))); 
      } 
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();

    print('Position: $position');

    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() {
    add(OnStartFollowingUser());
    print('Started following user');

    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
      print('Position: $position');
    });
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    add(OnStopFollowingUser());
    print('Stopped following user');
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }


}