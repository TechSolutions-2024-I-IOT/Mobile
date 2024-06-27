part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController mapController;
  const OnMapInitializedEvent(this.mapController);

  GoogleMapController? get controller => null;
}
