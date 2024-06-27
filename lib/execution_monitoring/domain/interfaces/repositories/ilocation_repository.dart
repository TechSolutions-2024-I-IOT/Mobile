import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/location.dart';

abstract class LocationRepository {
  Future<List<Location>> getLocations({required String token});
}