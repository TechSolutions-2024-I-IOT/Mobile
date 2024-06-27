import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/location.dart';

abstract class LocationDataSource {
  Future<List<Location>> getLocations({required String token});
}