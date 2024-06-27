import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/location.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/datasources/ilocation_datasource.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/interfaces/repositories/ilocation_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;

  LocationRepositoryImpl({required this.locationDataSource});

  @override
  Future<List<Location>> getLocations({required String token}) async {
    return await locationDataSource.getLocations(token: token);
  }
}