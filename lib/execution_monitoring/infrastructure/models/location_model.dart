import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/location.dart';

class LocationModel {
    final int id;
    final double lat;
    final double lng;

    LocationModel({
        required this.id,
        required this.lat,
        required this.lng,
    });

    factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        lat: json["lat"],
        lng: json["lng"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "lng": lng,
    };

    Location toEntity() {
    return Location(
      id: id, 
      lat: lat, 
      lng: lng,
    );
  }
}
