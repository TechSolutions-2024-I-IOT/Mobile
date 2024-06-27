import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/bus.dart';

class BusModel {
    final int id;
    final String licensePlate;
    final int seatingCapacity;
    final int totalCapacity;
    final int year;
    final String state;
    final int user;
    final bool isDeleted;

    BusModel({
        required this.id,
        required this.licensePlate,
        required this.seatingCapacity,
        required this.totalCapacity,
        required this.year,
        required this.state,
        required this.user,
        required this.isDeleted,
    });

    factory BusModel.fromJson(Map<String, dynamic> json) => BusModel(
        id: json["id"],
        licensePlate: json["licensePlate"],
        seatingCapacity: json["seatingCapacity"],
        totalCapacity: json["totalCapacity"],
        year: json["year"],
        state: json["state"],
        user: json["user"],
        isDeleted: json["isDeleted"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "licensePlate": licensePlate,
        "seatingCapacity": seatingCapacity,
        "totalCapacity": totalCapacity,
        "year": year,
        "state": state,
        "user": user,
        "isDeleted": isDeleted,
    };

    Bus toEntity() {
    return Bus(
      id: id,
      licensePlate: licensePlate,
      seatingCapacity: seatingCapacity,
      totalCapacity: totalCapacity,
      year: year,
      state: state,
      userId: user, // Adjust if your Bus entity uses a different property name
      isDeleted: isDeleted,
    );
  }
}
